import Foundation
import Result

***REMOVED***/ Provides each request with optional URLCredentials.
public final class CredentialsPlugin: PluginType {

    public typealias CredentialClosure = (TargetType) -> URLCredential?
    let credentialsClosure: CredentialClosure

    ***REMOVED***/ Initializes a CredentialsPlugin.
    public init(credentialsClosure: @escaping CredentialClosure) {
        self.credentialsClosure = credentialsClosure
    }

    ***REMOVED*** MARK: Plugin

    public func willSend(_ request: RequestType, target: TargetType) {
        if let credentials = credentialsClosure(target) {
            _ = request.authenticate(usingCredential: credentials)
        }
    }
}
