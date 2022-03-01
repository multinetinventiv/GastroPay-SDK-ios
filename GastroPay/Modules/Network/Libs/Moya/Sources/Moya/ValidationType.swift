import Foundation

***REMOVED***/ Represents the status codes to validate through Alamofire.
public enum ValidationType {

    ***REMOVED***/ No validation.
    case none

    ***REMOVED***/ Validate success codes (only 2xx).
    case successCodes

    ***REMOVED***/ Validate success codes and redirection codes (only 2xx and 3xx).
    case successAndRedirectCodes

    ***REMOVED***/ Validate only the given status codes.
    case customCodes([Int])

    ***REMOVED***/ The list of HTTP status codes to validate.
    var statusCodes: [Int] {
        switch self {
        case .successCodes:
            return Array(200..<300)
        case .successAndRedirectCodes:
            return Array(200..<400)
        case .customCodes(let codes):
            return codes
        case .none:
            return []
        }
    }
}

extension ValidationType: Equatable {

    public static func == (lhs: ValidationType, rhs: ValidationType) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.successCodes, .successCodes),
             (.successAndRedirectCodes, .successAndRedirectCodes):
            return true
        case (.customCodes(let code1), .customCodes(let code2)):
            return code1 == code2
        default:
            return false
        }
    }
}
