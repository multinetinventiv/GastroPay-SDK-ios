import Foundation

***REMOVED***/ The protocol used to define the specifications necessary for a `MoyaProvider`.
public protocol TargetType {

    ***REMOVED***/ The target's base `URL`.
    var baseURL: URL { get }

    ***REMOVED***/ The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    ***REMOVED***/ The HTTP method used in the request.
    var method: Method { get }

    ***REMOVED***/ Provides stub data for use in testing.
    var sampleData: Data { get }

    ***REMOVED***/ The type of HTTP task to be performed.
    var task: Task { get }

    ***REMOVED***/ The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { get }

    ***REMOVED***/ The headers to be used in the request.
    var headers: [String: String]? { get }
}

public extension TargetType {

    ***REMOVED***/ The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType {
        return .none
    }
}
