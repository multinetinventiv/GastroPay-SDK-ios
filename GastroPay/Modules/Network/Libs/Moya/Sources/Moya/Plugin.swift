import Foundation
import Result

***REMOVED***/ A Moya Plugin receives callbacks to perform side effects wherever a request is sent or received.
***REMOVED***/
***REMOVED***/ for example, a plugin may be used to
***REMOVED***/     - log network requests
***REMOVED***/     - hide and show a network activity indicator
***REMOVED***/     - inject additional information into a request
public protocol PluginType {
    ***REMOVED***/ Called to modify a request before sending.
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest

    ***REMOVED***/ Called immediately before a request is sent over the network (or stubbed).
    func willSend(_ request: RequestType, target: TargetType)

    ***REMOVED***/ Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceive(_ result: Result<MResponse, MoyaError>, target: TargetType)

    ***REMOVED***/ Called to modify a result before completion.
    func process(_ result: Result<MResponse, MoyaError>, target: TargetType) -> Result<MResponse, MoyaError>
}

public extension PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest { return request }
    func willSend(_ request: RequestType, target: TargetType) { }
    func didReceive(_ result: Result<MResponse, MoyaError>, target: TargetType) { }
    func process(_ result: Result<MResponse, MoyaError>, target: TargetType) -> Result<MResponse, MoyaError> { return result }
}

***REMOVED***/ Request type used by `willSend` plugin function.
public protocol RequestType {

    ***REMOVED*** Note:
    ***REMOVED***
    ***REMOVED*** We use this protocol instead of the Alamofire request to avoid leaking that abstraction.
    ***REMOVED*** A plugin should not know about Alamofire at all.

    ***REMOVED***/ Retrieve an `NSURLRequest` representation.
    var request: URLRequest? { get }

    ***REMOVED***/ Authenticates the request with a username and password.
    func authenticate(user: String, password: String, persistence: URLCredential.Persistence) -> Self

    ***REMOVED***/ Authenticates the request with an `NSURLCredential` instance.
    func authenticate(usingCredential credential: URLCredential) -> Self
}
