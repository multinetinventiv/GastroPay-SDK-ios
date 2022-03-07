


public final class NetworkAdapterBuilderNew<T: GazelRestAPITarget> {
    public typealias BuilderClosure = (NetworkAdapterBuilderNew) -> Void

    public var authenticationProvider: NetworkAuthenticationProvider? = .Gazel
    public var tokenProvider: NetworkAuthenticationTokenProvider?
    public var logNetworkRequests: Bool = false
    public var accessTokenExpiredResultCode: Int?
    public var refreshTokenExpiredResultCode: Int?
    public var refreshTokenExpiredCallback: ((_ error: Error) -> Void)?

    public init(buildClosure: BuilderClosure) { buildClosure(self) }

    public func build() -> NetworkAdapterNew<T> { return NetworkAdapterNew<T>.init(builder: self) }
}

public struct GazelErrorResponse: Codable {
    var resultCode: Int
    var resultMessage: String?
}

public class NetworkAdapterNew<Target: GazelRestAPITarget> {
    
    fileprivate var provider: MoyaProvider<Target>?

    convenience init(builder: NetworkAdapterBuilderNew<Target>) {
        self.init()

        let sessionManager = SessionManager.default
        var plugins: [PluginType] = []

        if builder.authenticationProvider == .Gazel {
            let authHandler = GazelNetworkAuthenticationHandler<Target>(
                tokenProvider: builder.tokenProvider!,
                refreshTokenEndpoint: Target.refreshTokenEndpoint as! GazelRestAPITarget,
                networkAdapter: self,
                accessTokenExpiredResultCode: String(builder.accessTokenExpiredResultCode!),
                refreshTokenExpiredResultCode: String(builder.refreshTokenExpiredResultCode!),
                refreshTokenExpiredCallback: builder.refreshTokenExpiredCallback
            )
            sessionManager.adapter = authHandler
            sessionManager.retrier = authHandler
        }

        if builder.logNetworkRequests {
            plugins.append(NetworkLoggerPlugin(verbose: true))
        }

        self.provider = MoyaProvider<Target>(
            manager: sessionManager,
            plugins: plugins
        )
    }

    public func fetchNew<T: Codable>(_ target: Target, completion: @escaping NetworkCompletionClosure<T>) {
        provider!.request(target) { (result) in
            switch result {
            case let .success(response):
                let decoder = JSONDecoder()

                if response.statusCode >= 200 && response.statusCode < 300 {
                    do {
                        let data = response.statusCode == 204 ? String("{}").data(using: .utf8)! : response.data
                        let model = try decoder.decode(T.self, from: data)
                        completion(.success(model))
                    } catch {
                        print("decode error: \(error)")
                        completion(.failure(error))
                    }
                } else if let resultCode = Int(self.getValueFromHeader(response: response, key: target.resultCodeHeaderKey) ?? ""), var resultMessage = self.getValueFromHeader(response: response, key: target.resultMessageHeaderKey) {
                    if resultMessage.count == 0 {
                        resultMessage = "Bir hata oluştu. Lütfen daha sonra tekrar deneyin."
                    }

                    completion(.failure(NSError(domain: "", code: resultCode, userInfo: [NSLocalizedDescriptionKey: String(response.statusCode) + " - " + resultMessage])))
                } else {
                    let resultCode = response.statusCode
                    let resultMessage = "Bir hata oluştu. Lütfen daha sonra tekrar deneyin."
                    completion(.failure(NSError(domain: "", code: resultCode, userInfo: [NSLocalizedDescriptionKey: String(response.statusCode) + " - " + resultMessage])))
                }
            case .failure(let error):
                if let responseData = error.response?.data {
                    let jsonDecoder = JSONDecoder()

                    do {
                        let gazelErrorResponse = try jsonDecoder.decode(GazelErrorResponse.self, from: responseData)
                        completion(.failure(NSError(domain: "", code: gazelErrorResponse.resultCode, userInfo: [NSLocalizedDescriptionKey: gazelErrorResponse.resultMessage ?? ""])))
                        print("Network error desc: \(error.localizedDescription) resultMessage: \(String(describing: gazelErrorResponse.resultMessage))")
                        return
                    } catch {
                        debugPrint(error)
                    }
                }

                completion(.failure(NSError(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey: "-999 - Ağ hatası"])))
            }
        }
    }

    func getValueFromHeader(response: MResponse, key: String) -> String? {
        if let header = response.response?.allHeaderFields as? [String: String] {
            if let resultCode = header[key] {
                return resultCode
            }
        }
        return nil
    }

}

class GazelNetworkAuthenticationHandler<Target: GazelRestAPITarget>: RequestAdapter, RequestRetrier {
    
    enum RetryHttpStatusCodes: Int{
        case RequestTimeout = 408
        case GatewayTimeout = 504
        case NetworkReadTimeout = 598
        case CloudfalreTimeOut = 524
        case AWSTimeout = 460
        case ServiceUnavailable = 503
    }
    
    private let badRequestStatusCode = 400
    
    private typealias RefreshCompletion = (_ error: Error?, _ accessToken: String?, _ refreshToken: String?) -> Void

    private var tokenProvider: NetworkAuthenticationTokenProvider

    private let adapter: NetworkAdapterNew<Target>
    private var isRefreshingTokens: Bool = false
    private let accessTokenExpiredResultCode: String
    private let refreshTokenExpiredResultCode: String
    private var refreshTokenEndpoint: GazelRestAPITarget
    private var refreshTokenExpiredCallback: ((_ error: Error) -> Void)?

    private let retryCheckLock = NSLock()
    private var requestsToRetry: [RequestRetryCompletion] = []
    private var numberOfRetries = 0
    private let maxNumberOfRetries = 10

    init(tokenProvider: NetworkAuthenticationTokenProvider, refreshTokenEndpoint: GazelRestAPITarget, networkAdapter: NetworkAdapterNew<Target>, accessTokenExpiredResultCode: String, refreshTokenExpiredResultCode: String, refreshTokenExpiredCallback: ((_ error: Error) -> Void)?) {
        self.tokenProvider = tokenProvider
        self.refreshTokenEndpoint = refreshTokenEndpoint
        self.adapter = networkAdapter
        self.accessTokenExpiredResultCode = accessTokenExpiredResultCode
        self.refreshTokenExpiredResultCode = refreshTokenExpiredResultCode
        self.refreshTokenExpiredCallback = refreshTokenExpiredCallback
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if let accessToken = tokenProvider.accessToken, !urlRequest.url!.absoluteString.contains("refresh_token") {
            urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        }
        print(urlRequest.url!.absoluteString)
        print("requestHeaders: ")
        print(urlRequest.allHTTPHeaderFields ?? "")
        return urlRequest
    }

    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        retryCheckLock.lock() ; defer { retryCheckLock.unlock() }
        print("new request \(String(describing: (request.task?.response as? HTTPURLResponse)?.url?.absoluteString))")
        print("new request headerFields")
        print((request.task?.response as? HTTPURLResponse)?.allHeaderFields ?? "")

        let response = request.task?.response as? HTTPURLResponse
        print(response?.statusCode ?? "")
        print(response?.allHeaderFields["X-Result-Code"] as? String ?? "")

        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == badRequestStatusCode, let resultCode = response.allHeaderFields["X-Result-Code"] as? String, resultCode == accessTokenExpiredResultCode {
            requestsToRetry.append(completion)
            print("new request added to retry array \(String(describing: (request.task?.response as? HTTPURLResponse)?.url?.absoluteString))")
            print()


            if !isRefreshingTokens {
                print("will send refresh token request \(String(describing: (request.task?.response as? HTTPURLResponse)?.url?.absoluteString))")

                refreshTokens { [weak self] error, accessToken, refreshToken in
                    guard let self = self else { return }
                    self.retryCheckLock.lock() ; defer { self.retryCheckLock.unlock() }

                    if let error = error {
                        self.requestsToRetry.forEach { $0(false, 0) }
                        self.requestsToRetry.removeAll()

                        if let refreshTokenExpiredCallback = self.refreshTokenExpiredCallback {
                            refreshTokenExpiredCallback(error)
                        }

                        return;
                    }

                    if let accessToken = accessToken, let refreshToken = refreshToken {
                        self.tokenProvider.accessToken = accessToken
                        self.tokenProvider.refreshToken = refreshToken
                    }
                    print("accessToken: \(self.tokenProvider.accessToken) refreshToken: \(String(describing: self.tokenProvider.refreshToken))")

                    self.requestsToRetry.forEach { $0(true, 1.0) }
                    self.requestsToRetry.removeAll()
                }
            }
        } else {
            
            if let response = request.task?.response as? HTTPURLResponse, response.statusCode !=  RetryHttpStatusCodes.AWSTimeout.rawValue, response.statusCode !=  RetryHttpStatusCodes.CloudfalreTimeOut.rawValue, response.statusCode !=  RetryHttpStatusCodes.GatewayTimeout.rawValue, response.statusCode !=  RetryHttpStatusCodes.NetworkReadTimeout.rawValue, response.statusCode !=  RetryHttpStatusCodes.RequestTimeout.rawValue, response.statusCode != RetryHttpStatusCodes.ServiceUnavailable.rawValue
            {
                completion(false, 0.0)
            }
            else if numberOfRetries <= maxNumberOfRetries {
                print("Going to retry request \(request)")
                numberOfRetries += 1
                completion(true, 0.5)
            }
            else{
                completion(false, 0.0)
            }
            
        }
    }

    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshingTokens else { return }
        isRefreshingTokens = true

        requestRefreshToken { (result) in
            switch result {
            case .success(let model):
                completion(nil, model.userToken, model.refreshToken)
            case .failure(let error):
                completion(error, nil, nil)
            }

            self.isRefreshingTokens = false
        }
    }

    func requestRefreshToken(completed: @escaping NetworkCompletionClosure<RefreshTokensResponseModel>) {
        let _: [String: Any] = [
            "access_token": self.tokenProvider.accessToken ?? "",
            "refresh_token": self.tokenProvider.refreshToken ?? ""
        ]

        adapter.fetchNew(self.refreshTokenEndpoint as! Target, completion: completed)
    }
}
