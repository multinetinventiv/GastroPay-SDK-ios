import Foundation

***REMOVED***/ Represents an HTTP task.
public enum Task {

    ***REMOVED***/ A request with no additional data.
    case requestPlain

    ***REMOVED***/ A requests body set with data.
    case requestData(Data)

    ***REMOVED***/ A request body set with `Encodable` type
    case requestJSONEncodable(Encodable)

    ***REMOVED***/ A request body set with `Encodable` type and custom encoder
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)

    ***REMOVED***/ A requests body set with encoded parameters.
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)

    ***REMOVED***/ A requests body set with data, combined with url parameters.
    case requestCompositeData(bodyData: Data, urlParameters: [String: Any])

    ***REMOVED***/ A requests body set with encoded parameters combined with url parameters.
    case requestCompositeParameters(bodyParameters: [String: Any], bodyEncoding: ParameterEncoding, urlParameters: [String: Any])

    ***REMOVED***/ A file upload task.
    case uploadFile(URL)

    ***REMOVED***/ A "multipart/form-data" upload task.
    case uploadMultipart([MoyaMultipartFormData])

    ***REMOVED***/ A "multipart/form-data" upload task  combined with url parameters.
    case uploadCompositeMultipart([MoyaMultipartFormData], urlParameters: [String: Any])

    ***REMOVED***/ A file download task to a destination.
    case downloadDestination(DownloadDestination)

    ***REMOVED***/ A file download task to a destination with extra parameters using the given encoding.
    case downloadParameters(parameters: [String: Any], encoding: ParameterEncoding, destination: DownloadDestination)
}
