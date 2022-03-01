import Foundation
import Result

***REMOVED*** MARK: - Method

extension Method {
    ***REMOVED***/ A Boolean value determining whether the request supports multipart.
    public var supportsMultipart: Bool {
        switch self {
        case .post, .put, .patch, .connect:
            return true
        case .get, .delete, .head, .options, .trace:
            return false
        }
    }
}

***REMOVED*** MARK: - MoyaProvider

***REMOVED***/ Internal extension to keep the inner-workings outside the main swift file.
public extension MoyaProvider {
    ***REMOVED***/ Performs normal requests.
    func requestNormal(_ target: Target, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping Completion) -> Cancellable {
        let endpoint = self.endpoint(target)
        let stubBehavior = self.stubClosure(target)
        let cancellableToken = CancellableWrapper()

        ***REMOVED*** Allow plugins to modify response
        let pluginsWithCompletion: Completion = { result in
            let processedResult = self.plugins.reduce(result) { $1.process($0, target: target) }
            completion(processedResult)
        }

        if trackInflights {
            objc_sync_enter(self)
            var inflightCompletionBlocks = self.inflightRequests[endpoint]
            inflightCompletionBlocks?.append(pluginsWithCompletion)
            self.inflightRequests[endpoint] = inflightCompletionBlocks
            objc_sync_exit(self)

            if inflightCompletionBlocks != nil {
                return cancellableToken
            } else {
                objc_sync_enter(self)
                self.inflightRequests[endpoint] = [pluginsWithCompletion]
                objc_sync_exit(self)
            }
        }

        let performNetworking = { (requestResult: Result<URLRequest, MoyaError>) in
            if cancellableToken.isCancelled {
                self.cancelCompletion(pluginsWithCompletion, target: target)
                return
            }

            var request: URLRequest!

            switch requestResult {
            case .success(let urlRequest):
                request = urlRequest
            case .failure(let error):
                pluginsWithCompletion(.failure(error))
                return
            }

            ***REMOVED*** Allow plugins to modify request
            let preparedRequest = self.plugins.reduce(request) { $1.prepare($0, target: target) }

            let networkCompletion: Completion = { result in
              if self.trackInflights {
                self.inflightRequests[endpoint]?.forEach { $0(result) }

                objc_sync_enter(self)
                self.inflightRequests.removeValue(forKey: endpoint)
                objc_sync_exit(self)
              } else {
                pluginsWithCompletion(result)
              }
            }

            cancellableToken.innerCancellable = self.performRequest(target, request: preparedRequest, callbackQueue: callbackQueue, progress: progress, completion: networkCompletion, endpoint: endpoint, stubBehavior: stubBehavior)
        }

        requestClosure(endpoint, performNetworking)

        return cancellableToken
    }

    ***REMOVED*** swiftlint:disable:next function_parameter_count
    private func performRequest(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping Completion, endpoint: Endpoint, stubBehavior: StubBehavior) -> Cancellable {
        switch stubBehavior {
        case .never:
            switch endpoint.task {
            case .requestPlain, .requestData, .requestJSONEncodable, .requestCustomJSONEncodable, .requestParameters, .requestCompositeData, .requestCompositeParameters:
                return self.sendRequest(target, request: request, callbackQueue: callbackQueue, progress: progress, completion: completion)
            default:
                return self.sendRequest(target, request: request, callbackQueue: callbackQueue, progress: progress, completion: completion)
            }
        default:
            return self.stubRequest(target, request: request, callbackQueue: callbackQueue, completion: completion, endpoint: endpoint, stubBehavior: stubBehavior)
        }
    }

    func cancelCompletion(_ completion: Completion, target: Target) {
        let error = MoyaError.underlying(NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil), nil)
        plugins.forEach { $0.didReceive(.failure(error), target: target) }
        completion(.failure(error))
    }

    ***REMOVED***/ Creates a function which, when called, executes the appropriate stubbing behavior for the given parameters.
    final func createStubFunction(_ token: CancellableToken, forTarget target: Target, withCompletion completion: @escaping Completion, endpoint: Endpoint, plugins: [PluginType], request: URLRequest) -> (() -> Void) { ***REMOVED*** swiftlint:disable:this function_parameter_count
        return {
            if token.isCancelled {
                self.cancelCompletion(completion, target: target)
                return
            }

            let validate = { (response: MResponse) -> Result<MResponse, MoyaError> in
                let validCodes = target.validationType.statusCodes
                guard !validCodes.isEmpty else { return .success(response) }
                if validCodes.contains(response.statusCode) {
                    return .success(response)
                } else {
                    let statusError = MoyaError.statusCode(response)
                    let error = MoyaError.underlying(statusError, response)
                    return .failure(error)
                }
            }

            switch endpoint.sampleResponseClosure() {
            case .networkResponse(let statusCode, let data):
                let response = MResponse(statusCode: statusCode, data: data, request: request, response: nil)
                let result = validate(response)
                plugins.forEach { $0.didReceive(result, target: target) }
                completion(result)
            case .response(let customResponse, let data):
                let response = MResponse(statusCode: customResponse.statusCode, data: data, request: request, response: customResponse)
                let result = validate(response)
                plugins.forEach { $0.didReceive(result, target: target) }
                completion(result)
            case .networkError(let error):
                let error = MoyaError.underlying(error, nil)
                plugins.forEach { $0.didReceive(.failure(error), target: target) }
                completion(.failure(error))
            }
        }
    }

    ***REMOVED***/ Notify all plugins that a stub is about to be performed. You must call this if overriding `stubRequest`.
    final func notifyPluginsOfImpendingStub(for request: URLRequest, target: Target) {
        let alamoRequest = manager.request(request as URLRequestConvertible)
        plugins.forEach { $0.willSend(alamoRequest, target: target) }
    }
}



private extension MoyaProvider {
    /*
    func sendUploadMultipart(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, multipartBody: [MoyaMultipartFormData], progress: ProgressBlock? = nil, completion: @escaping Completion) -> CancellableWrapper {
        let cancellable = CancellableWrapper()

        let multipartFormData: (RequestMultipartFormData) -> Void = { form in
            form.applyMoyaMultipartFormData(multipartBody)
        }

        manager.upload(multipartFormData: multipartFormData, with: request) { result in
            switch result {
            case .success(let alamoRequest, _, _):
                if cancellable.isCancelled {
                    self.cancelCompletion(completion, target: target)
                    return
                }
                let validationCodes = target.validationType.statusCodes
                let validatedRequest = validationCodes.isEmpty ? alamoRequest : alamoRequest.validate(statusCode: validationCodes)
                cancellable.innerCancellable = self.sendAlamofireRequest(validatedRequest, target: target, callbackQueue: callbackQueue, progress: progress, completion: completion)
            case .failure(let error):
                completion(.failure(MoyaError.underlying(error as NSError, nil)))
            }
        }

        return cancellable
    }

    func sendUploadFile(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, file: URL, progress: ProgressBlock? = nil, completion: @escaping Completion) -> CancellableToken {
        let uploadRequest = manager.upload(file, with: request)
        let validationCodes = target.validationType.statusCodes
        let alamoRequest = validationCodes.isEmpty ? uploadRequest : uploadRequest.validate(statusCode: validationCodes)
        return self.sendAlamofireRequest(alamoRequest, target: target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }

    func sendDownloadRequest(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, destination: @escaping DownloadDestination, progress: ProgressBlock? = nil, completion: @escaping Completion) -> CancellableToken {
        let downloadRequest = manager.download(request, to: destination)
        let validationCodes = target.validationType.statusCodes
        let alamoRequest = validationCodes.isEmpty ? downloadRequest : downloadRequest.validate(statusCode: validationCodes)
        return self.sendAlamofireRequest(alamoRequest, target: target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
 */

    func sendRequest(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping Completion) -> CancellableToken {
        let initialRequest = manager.request(request as URLRequestConvertible)
        let validationCodes = target.validationType.statusCodes
        let alamoRequest = validationCodes.isEmpty ? initialRequest : initialRequest.validate(statusCode: validationCodes)
        return sendAlamofireRequest(alamoRequest, target: target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }

    ***REMOVED*** swiftlint:disable:next cyclomatic_complexity
    func sendAlamofireRequest<T>(_ alamoRequest: T, target: Target, callbackQueue: DispatchQueue?, progress progressCompletion: ProgressBlock?, completion: @escaping Completion) -> CancellableToken where T: Requestable, T: Request {
        ***REMOVED*** Give plugins the chance to alter the outgoing request
        let plugins = self.plugins
        plugins.forEach { $0.willSend(alamoRequest, target: target) }

        var progressAlamoRequest = alamoRequest
        let progressClosure: (Progress) -> Void = { progress in
            let sendProgress: () -> Void = {
                progressCompletion?(ProgressResponse(progress: progress))
            }

            if let callbackQueue = callbackQueue {
                callbackQueue.async(execute: sendProgress)
            } else {
                sendProgress()
            }
        }

        ***REMOVED*** Perform the actual request
        if progressCompletion != nil {
            switch progressAlamoRequest {
            case let downloadRequest as DownloadRequest:
                if let downloadRequest = downloadRequest.downloadProgress(closure: progressClosure) as? T {
                    progressAlamoRequest = downloadRequest
                }
            case let uploadRequest as UploadRequest:
                if let uploadRequest = uploadRequest.uploadProgress(closure: progressClosure) as? T {
                    progressAlamoRequest = uploadRequest
                }
            case let dataRequest as DataRequest:
                if let dataRequest = dataRequest.downloadProgress(closure: progressClosure) as? T {
                    progressAlamoRequest = dataRequest
                }
            default: break
            }
        }

        let completionHandler: RequestableCompletion = { response, request, data, error in
            let result = convertResponseToResult(response, request: request, data: data, error: error)
            ***REMOVED*** Inform all plugins about the response
            plugins.forEach { $0.didReceive(result, target: target) }
            if let progressCompletion = progressCompletion {
                switch progressAlamoRequest {
                case let downloadRequest as DownloadRequest:
                    progressCompletion(ProgressResponse(progress: downloadRequest.progress, response: result.value))
                case let uploadRequest as UploadRequest:
                    progressCompletion(ProgressResponse(progress: uploadRequest.uploadProgress, response: result.value))
                case let dataRequest as DataRequest:
                    progressCompletion(ProgressResponse(progress: dataRequest.progress, response: result.value))
                default:
                    progressCompletion(ProgressResponse(response: result.value))
                }
            }
            completion(result)
        }

        progressAlamoRequest = progressAlamoRequest.response(callbackQueue: callbackQueue, completionHandler: completionHandler)

        progressAlamoRequest.resume()

        return CancellableToken(request: progressAlamoRequest)
    }
}
