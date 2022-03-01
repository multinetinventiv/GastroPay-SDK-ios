import Foundation

***REMOVED***/ A type representing possible errors Moya can throw.
public enum MoyaError: Swift.Error {

    ***REMOVED***/ Indicates a response failed to map to an image.
    case imageMapping(MResponse)

    ***REMOVED***/ Indicates a response failed to map to a JSON structure.
    case jsonMapping(MResponse)

    ***REMOVED***/ Indicates a response failed to map to a String.
    case stringMapping(MResponse)

    ***REMOVED***/ Indicates a response failed to map to a Decodable object.
    case objectMapping(Swift.Error, MResponse)

    ***REMOVED***/ Indicates that Encodable couldn't be encoded into Data
    case encodableMapping(Swift.Error)

    ***REMOVED***/ Indicates a response failed with an invalid HTTP status code.
    case statusCode(MResponse)

    ***REMOVED***/ Indicates a response failed due to an underlying `Error`.
    case underlying(Swift.Error, MResponse?)

    ***REMOVED***/ Indicates that an `Endpoint` failed to map to a `URLRequest`.
    case requestMapping(String)

    ***REMOVED***/ Indicates that an `Endpoint` failed to encode the parameters for the `URLRequest`.
    case parameterEncoding(Swift.Error)
}

public extension MoyaError {
    ***REMOVED***/ Depending on error type, returns a `Response` object.
    var response: MResponse? {
        switch self {
        case .imageMapping(let response): return response
        case .jsonMapping(let response): return response
        case .stringMapping(let response): return response
        case .objectMapping(_, let response): return response
        case .encodableMapping: return nil
        case .statusCode(let response): return response
        case .underlying(_, let response): return response
        case .requestMapping: return nil
        case .parameterEncoding: return nil
        }
    }

    ***REMOVED***/ Depending on error type, returns an underlying `Error`.
    internal var underlyingError: Swift.Error? {
        switch self {
        case .imageMapping: return nil
        case .jsonMapping: return nil
        case .stringMapping: return nil
        case .objectMapping(let error, _): return error
        case .encodableMapping(let error): return error
        case .statusCode: return nil
        case .underlying(let error, _): return error
        case .requestMapping: return nil
        case .parameterEncoding(let error): return error
        }
    }
}

***REMOVED*** MARK: - Error Descriptions

extension MoyaError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .imageMapping:
            return "Failed to map data to an Image."
        case .jsonMapping:
            return "Failed to map data to JSON."
        case .stringMapping:
            return "Failed to map data to a String."
        case .objectMapping:
            return "Failed to map data to a Decodable object."
        case .encodableMapping:
            return "Failed to encode Encodable object into data."
        case .statusCode:
            return "Status code didn't fall within the given range."
        case .underlying(let error, _):
            return error.localizedDescription
        case .requestMapping:
            return "Failed to map Endpoint to a URLRequest."
        case .parameterEncoding(let error):
            return "Failed to encode parameters for URLRequest. \(error.localizedDescription)"
        }
    }
}

***REMOVED*** MARK: - Error User Info

extension MoyaError: CustomNSError {
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        userInfo[NSUnderlyingErrorKey] = underlyingError
        return userInfo
    }
}
