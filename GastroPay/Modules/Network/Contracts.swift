


/*
 Typealiases START
 */

public typealias NetworkAPIValidationType = ValidationType
public typealias NetworkAPITask = Task
public typealias NetworkAPIMethod = Method

public typealias NetworkParameterEncoding = ParameterEncoding
public typealias NetworkJSONEncoding = JSONEncoding
public typealias NetworkURLEncoding = URLEncoding
public typealias NetworkResponseValidationType = ValidationType

public typealias NetworkResponse = MResponse
public typealias NetworkCompletionClosure<T: Codable> = (Result<T, Error>) -> ()

/*
 Typealiases END
*/

/*
 Network Target Protocols START
 */

public protocol NetworkAPITarget: TargetType {
    var parameterEncoding: ParameterEncoding { get }
    var parameters: [String: Any] { get }
}

public protocol NetworkAPIAuthenticatedTarget: NetworkAPITarget {
    var shouldAuthenticate: Bool { get }
}

public protocol NetworkAPIRefreshesToken {
    static var refreshTokenEndpoint: NetworkAPITarget { get }
}

public protocol NetworkTargetWithHeaderResult {
    var resultCodeHeaderKey: String { get }
    var resultMessageHeaderKey: String { get }
}

public protocol NetworkAPIRefreshesTokenWithHeaderCode: NetworkAPIRefreshesToken {
    var accessTokenExpiredResultCode: Int { get }
    var refreshTokenExpiredResultCode: Int { get }
}

public protocol GazelRestAPITarget: NetworkAPIAuthenticatedTarget, NetworkAPIRefreshesTokenWithHeaderCode, NetworkTargetWithHeaderResult {}

/*
 Network Target Protocols END
*/

/*
 Network Adapter Protocols START
*/

public struct RefreshTokensResponseModel: Codable {
    public var userToken: String
    public var refreshToken: String

}

public protocol NetworkAuthenticationTokenProvider {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
}

public enum NetworkAuthenticationProvider {
    case Gazel
}

/*
 Network Adapter Protocols END
*/
