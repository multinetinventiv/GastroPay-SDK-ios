import Foundation


***REMOVED***/ Represents "multipart/form-data" for an upload.
public struct MoyaMultipartFormData {

    ***REMOVED***/ Method to provide the form data.
    public enum FormDataProvider {
        case data(Foundation.Data)
        case file(URL)
        case stream(InputStream, UInt64)
    }

    public init(provider: FormDataProvider, name: String, fileName: String? = nil, mimeType: String? = nil) {
        self.provider = provider
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }

    ***REMOVED***/ The method being used for providing form data.
    public let provider: FormDataProvider

    ***REMOVED***/ The name.
    public let name: String

    ***REMOVED***/ The file name.
    public let fileName: String?

    ***REMOVED***/ The MIME type
    public let mimeType: String?

}
