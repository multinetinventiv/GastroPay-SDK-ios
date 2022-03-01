***REMOVED***
***REMOVED***  AFError.swift
***REMOVED***
***REMOVED***  Copyright (c) 2014 Alamofire Software Foundation (http:***REMOVED***alamofire.org/)
***REMOVED***
***REMOVED***  Permission is hereby granted, free of charge, to any person obtaining a copy
***REMOVED***  of this software and associated documentation files (the "Software"), to deal
***REMOVED***  in the Software without restriction, including without limitation the rights
***REMOVED***  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
***REMOVED***  copies of the Software, and to permit persons to whom the Software is
***REMOVED***  furnished to do so, subject to the following conditions:
***REMOVED***
***REMOVED***  The above copyright notice and this permission notice shall be included in
***REMOVED***  all copies or substantial portions of the Software.
***REMOVED***
***REMOVED***  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
***REMOVED***  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
***REMOVED***  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
***REMOVED***  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
***REMOVED***  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
***REMOVED***  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
***REMOVED***  THE SOFTWARE.
***REMOVED***

import Foundation

***REMOVED***/ `AFError` is the error type returned by Alamofire. It encompasses a few different types of errors, each with
***REMOVED***/ their own associated reasons.
***REMOVED***/
***REMOVED***/ - invalidURL:                  Returned when a `URLConvertible` type fails to create a valid `URL`.
***REMOVED***/ - parameterEncodingFailed:     Returned when a parameter encoding object throws an error during the encoding process.
***REMOVED***/ - multipartEncodingFailed:     Returned when some step in the multipart encoding process fails.
***REMOVED***/ - responseValidationFailed:    Returned when a `validate()` call fails.
***REMOVED***/ - responseSerializationFailed: Returned when a response serializer encounters an error in the serialization process.
public enum AFError: Error {
    ***REMOVED***/ The underlying reason the parameter encoding error occurred.
    ***REMOVED***/
    ***REMOVED***/ - missingURL:                 The URL request did not have a URL to encode.
    ***REMOVED***/ - jsonEncodingFailed:         JSON serialization failed with an underlying system error during the
    ***REMOVED***/                               encoding process.
    ***REMOVED***/ - propertyListEncodingFailed: Property list serialization failed with an underlying system error during
    ***REMOVED***/                               encoding process.
    public enum ParameterEncodingFailureReason {
        case missingURL
        case jsonEncodingFailed(error: Error)
        case propertyListEncodingFailed(error: Error)
    }

    ***REMOVED***/ The underlying reason the multipart encoding error occurred.
    ***REMOVED***/
    ***REMOVED***/ - bodyPartURLInvalid:                   The `fileURL` provided for reading an encodable body part isn't a
    ***REMOVED***/                                         file URL.
    ***REMOVED***/ - bodyPartFilenameInvalid:              The filename of the `fileURL` provided has either an empty
    ***REMOVED***/                                         `lastPathComponent` or `pathExtension.
    ***REMOVED***/ - bodyPartFileNotReachable:             The file at the `fileURL` provided was not reachable.
    ***REMOVED***/ - bodyPartFileNotReachableWithError:    Attempting to check the reachability of the `fileURL` provided threw
    ***REMOVED***/                                         an error.
    ***REMOVED***/ - bodyPartFileIsDirectory:              The file at the `fileURL` provided is actually a directory.
    ***REMOVED***/ - bodyPartFileSizeNotAvailable:         The size of the file at the `fileURL` provided was not returned by
    ***REMOVED***/                                         the system.
    ***REMOVED***/ - bodyPartFileSizeQueryFailedWithError: The attempt to find the size of the file at the `fileURL` provided
    ***REMOVED***/                                         threw an error.
    ***REMOVED***/ - bodyPartInputStreamCreationFailed:    An `InputStream` could not be created for the provided `fileURL`.
    ***REMOVED***/ - outputStreamCreationFailed:           An `OutputStream` could not be created when attempting to write the
    ***REMOVED***/                                         encoded data to disk.
    ***REMOVED***/ - outputStreamFileAlreadyExists:        The encoded body data could not be writtent disk because a file
    ***REMOVED***/                                         already exists at the provided `fileURL`.
    ***REMOVED***/ - outputStreamURLInvalid:               The `fileURL` provided for writing the encoded body data to disk is
    ***REMOVED***/                                         not a file URL.
    ***REMOVED***/ - outputStreamWriteFailed:              The attempt to write the encoded body data to disk failed with an
    ***REMOVED***/                                         underlying error.
    ***REMOVED***/ - inputStreamReadFailed:                The attempt to read an encoded body part `InputStream` failed with
    ***REMOVED***/                                         underlying system error.
    public enum MultipartEncodingFailureReason {
        case bodyPartURLInvalid(url: URL)
        case bodyPartFilenameInvalid(in: URL)
        case bodyPartFileNotReachable(at: URL)
        case bodyPartFileNotReachableWithError(atURL: URL, error: Error)
        case bodyPartFileIsDirectory(at: URL)
        case bodyPartFileSizeNotAvailable(at: URL)
        case bodyPartFileSizeQueryFailedWithError(forURL: URL, error: Error)
        case bodyPartInputStreamCreationFailed(for: URL)

        case outputStreamCreationFailed(for: URL)
        case outputStreamFileAlreadyExists(at: URL)
        case outputStreamURLInvalid(url: URL)
        case outputStreamWriteFailed(error: Error)

        case inputStreamReadFailed(error: Error)
    }

    ***REMOVED***/ The underlying reason the response validation error occurred.
    ***REMOVED***/
    ***REMOVED***/ - dataFileNil:             The data file containing the server response did not exist.
    ***REMOVED***/ - dataFileReadFailed:      The data file containing the server response could not be read.
    ***REMOVED***/ - missingContentType:      The response did not contain a `Content-Type` and the `acceptableContentTypes`
    ***REMOVED***/                            provided did not contain wildcard type.
    ***REMOVED***/ - unacceptableContentType: The response `Content-Type` did not match any type in the provided
    ***REMOVED***/                            `acceptableContentTypes`.
    ***REMOVED***/ - unacceptableStatusCode:  The response status code was not acceptable.
    public enum ResponseValidationFailureReason {
        case dataFileNil
        case dataFileReadFailed(at: URL)
        case missingContentType(acceptableContentTypes: [String])
        case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
        case unacceptableStatusCode(code: Int)
    }

    ***REMOVED***/ The underlying reason the response serialization error occurred.
    ***REMOVED***/
    ***REMOVED***/ - inputDataNil:                    The server response contained no data.
    ***REMOVED***/ - inputDataNilOrZeroLength:        The server response contained no data or the data was zero length.
    ***REMOVED***/ - inputFileNil:                    The file containing the server response did not exist.
    ***REMOVED***/ - inputFileReadFailed:             The file containing the server response could not be read.
    ***REMOVED***/ - stringSerializationFailed:       String serialization failed using the provided `String.Encoding`.
    ***REMOVED***/ - jsonSerializationFailed:         JSON serialization failed with an underlying system error.
    ***REMOVED***/ - propertyListSerializationFailed: Property list serialization failed with an underlying system error.
    public enum ResponseSerializationFailureReason {
        case inputDataNil
        case inputDataNilOrZeroLength
        case inputFileNil
        case inputFileReadFailed(at: URL)
        case stringSerializationFailed(encoding: String.Encoding)
        case jsonSerializationFailed(error: Error)
        case propertyListSerializationFailed(error: Error)
    }

    case invalidURL(url: URLConvertible)
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
    case multipartEncodingFailed(reason: MultipartEncodingFailureReason)
    case responseValidationFailed(reason: ResponseValidationFailureReason)
    case responseSerializationFailed(reason: ResponseSerializationFailureReason)
}

***REMOVED*** MARK: - Adapt Error

struct AdaptError: Error {
    let error: Error
}

extension Error {
    var underlyingAdaptError: Error? { return (self as? AdaptError)?.error }
}

***REMOVED*** MARK: - Error Booleans

extension AFError {
    ***REMOVED***/ Returns whether the AFError is an invalid URL error.
    public var isInvalidURLError: Bool {
        if case .invalidURL = self { return true }
        return false
    }

    ***REMOVED***/ Returns whether the AFError is a parameter encoding error. When `true`, the `underlyingError` property will
    ***REMOVED***/ contain the associated value.
    public var isParameterEncodingError: Bool {
        if case .parameterEncodingFailed = self { return true }
        return false
    }

    ***REMOVED***/ Returns whether the AFError is a multipart encoding error. When `true`, the `url` and `underlyingError` properties
    ***REMOVED***/ will contain the associated values.
    public var isMultipartEncodingError: Bool {
        if case .multipartEncodingFailed = self { return true }
        return false
    }

    ***REMOVED***/ Returns whether the `AFError` is a response validation error. When `true`, the `acceptableContentTypes`,
    ***REMOVED***/ `responseContentType`, and `responseCode` properties will contain the associated values.
    public var isResponseValidationError: Bool {
        if case .responseValidationFailed = self { return true }
        return false
    }

    ***REMOVED***/ Returns whether the `AFError` is a response serialization error. When `true`, the `failedStringEncoding` and
    ***REMOVED***/ `underlyingError` properties will contain the associated values.
    public var isResponseSerializationError: Bool {
        if case .responseSerializationFailed = self { return true }
        return false
    }
}

***REMOVED*** MARK: - Convenience Properties

extension AFError {
    ***REMOVED***/ The `URLConvertible` associated with the error.
    public var urlConvertible: URLConvertible? {
        switch self {
        case .invalidURL(let url):
            return url
        default:
            return nil
        }
    }

    ***REMOVED***/ The `URL` associated with the error.
    public var url: URL? {
        switch self {
        case .multipartEncodingFailed(let reason):
            return reason.url
        default:
            return nil
        }
    }

    ***REMOVED***/ The `Error` returned by a system framework associated with a `.parameterEncodingFailed`,
    ***REMOVED***/ `.multipartEncodingFailed` or `.responseSerializationFailed` error.
    public var underlyingError: Error? {
        switch self {
        case .parameterEncodingFailed(let reason):
            return reason.underlyingError
        case .multipartEncodingFailed(let reason):
            return reason.underlyingError
        case .responseSerializationFailed(let reason):
            return reason.underlyingError
        default:
            return nil
        }
    }

    ***REMOVED***/ The acceptable `Content-Type`s of a `.responseValidationFailed` error.
    public var acceptableContentTypes: [String]? {
        switch self {
        case .responseValidationFailed(let reason):
            return reason.acceptableContentTypes
        default:
            return nil
        }
    }

    ***REMOVED***/ The response `Content-Type` of a `.responseValidationFailed` error.
    public var responseContentType: String? {
        switch self {
        case .responseValidationFailed(let reason):
            return reason.responseContentType
        default:
            return nil
        }
    }

    ***REMOVED***/ The response code of a `.responseValidationFailed` error.
    public var responseCode: Int? {
        switch self {
        case .responseValidationFailed(let reason):
            return reason.responseCode
        default:
            return nil
        }
    }

    ***REMOVED***/ The `String.Encoding` associated with a failed `.stringResponse()` call.
    public var failedStringEncoding: String.Encoding? {
        switch self {
        case .responseSerializationFailed(let reason):
            return reason.failedStringEncoding
        default:
            return nil
        }
    }
}

extension AFError.ParameterEncodingFailureReason {
    var underlyingError: Error? {
        switch self {
        case .jsonEncodingFailed(let error), .propertyListEncodingFailed(let error):
            return error
        default:
            return nil
        }
    }
}

extension AFError.MultipartEncodingFailureReason {
    var url: URL? {
        switch self {
        case .bodyPartURLInvalid(let url), .bodyPartFilenameInvalid(let url), .bodyPartFileNotReachable(let url),
             .bodyPartFileIsDirectory(let url), .bodyPartFileSizeNotAvailable(let url),
             .bodyPartInputStreamCreationFailed(let url), .outputStreamCreationFailed(let url),
             .outputStreamFileAlreadyExists(let url), .outputStreamURLInvalid(let url),
             .bodyPartFileNotReachableWithError(let url, _), .bodyPartFileSizeQueryFailedWithError(let url, _):
            return url
        default:
            return nil
        }
    }

    var underlyingError: Error? {
        switch self {
        case .bodyPartFileNotReachableWithError(_, let error), .bodyPartFileSizeQueryFailedWithError(_, let error),
             .outputStreamWriteFailed(let error), .inputStreamReadFailed(let error):
            return error
        default:
            return nil
        }
    }
}

extension AFError.ResponseValidationFailureReason {
    var acceptableContentTypes: [String]? {
        switch self {
        case .missingContentType(let types), .unacceptableContentType(let types, _):
            return types
        default:
            return nil
        }
    }

    var responseContentType: String? {
        switch self {
        case .unacceptableContentType(_, let responseType):
            return responseType
        default:
            return nil
        }
    }

    var responseCode: Int? {
        switch self {
        case .unacceptableStatusCode(let code):
            return code
        default:
            return nil
        }
    }
}

extension AFError.ResponseSerializationFailureReason {
    var failedStringEncoding: String.Encoding? {
        switch self {
        case .stringSerializationFailed(let encoding):
            return encoding
        default:
            return nil
        }
    }

    var underlyingError: Error? {
        switch self {
        case .jsonSerializationFailed(let error), .propertyListSerializationFailed(let error):
            return error
        default:
            return nil
        }
    }
}

***REMOVED*** MARK: - Error Descriptions

extension AFError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "URL is not valid: \(url)"
        case .parameterEncodingFailed(let reason):
            return reason.localizedDescription
        case .multipartEncodingFailed(let reason):
            return reason.localizedDescription
        case .responseValidationFailed(let reason):
            return reason.localizedDescription
        case .responseSerializationFailed(let reason):
            return reason.localizedDescription
        }
    }
}

extension AFError.ParameterEncodingFailureReason {
    var localizedDescription: String {
        switch self {
        case .missingURL:
            return "URL request to encode was missing a URL"
        case .jsonEncodingFailed(let error):
            return "JSON could not be encoded because of error:\n\(error.localizedDescription)"
        case .propertyListEncodingFailed(let error):
            return "PropertyList could not be encoded because of error:\n\(error.localizedDescription)"
        }
    }
}

extension AFError.MultipartEncodingFailureReason {
    var localizedDescription: String {
        switch self {
        case .bodyPartURLInvalid(let url):
            return "The URL provided is not a file URL: \(url)"
        case .bodyPartFilenameInvalid(let url):
            return "The URL provided does not have a valid filename: \(url)"
        case .bodyPartFileNotReachable(let url):
            return "The URL provided is not reachable: \(url)"
        case .bodyPartFileNotReachableWithError(let url, let error):
            return (
                "The system returned an error while checking the provided URL for " +
                "reachability.\nURL: \(url)\nError: \(error)"
            )
        case .bodyPartFileIsDirectory(let url):
            return "The URL provided is a directory: \(url)"
        case .bodyPartFileSizeNotAvailable(let url):
            return "Could not fetch the file size from the provided URL: \(url)"
        case .bodyPartFileSizeQueryFailedWithError(let url, let error):
            return (
                "The system returned an error while attempting to fetch the file size from the " +
                "provided URL.\nURL: \(url)\nError: \(error)"
            )
        case .bodyPartInputStreamCreationFailed(let url):
            return "Failed to create an InputStream for the provided URL: \(url)"
        case .outputStreamCreationFailed(let url):
            return "Failed to create an OutputStream for URL: \(url)"
        case .outputStreamFileAlreadyExists(let url):
            return "A file already exists at the provided URL: \(url)"
        case .outputStreamURLInvalid(let url):
            return "The provided OutputStream URL is invalid: \(url)"
        case .outputStreamWriteFailed(let error):
            return "OutputStream write failed with error: \(error)"
        case .inputStreamReadFailed(let error):
            return "InputStream read failed with error: \(error)"
        }
    }
}

extension AFError.ResponseSerializationFailureReason {
    var localizedDescription: String {
        switch self {
        case .inputDataNil:
            return "Response could not be serialized, input data was nil."
        case .inputDataNilOrZeroLength:
            return "Response could not be serialized, input data was nil or zero length."
        case .inputFileNil:
            return "Response could not be serialized, input file was nil."
        case .inputFileReadFailed(let url):
            return "Response could not be serialized, input file could not be read: \(url)."
        case .stringSerializationFailed(let encoding):
            return "String could not be serialized with encoding: \(encoding)."
        case .jsonSerializationFailed(let error):
            return "JSON could not be serialized because of error:\n\(error.localizedDescription)"
        case .propertyListSerializationFailed(let error):
            return "PropertyList could not be serialized because of error:\n\(error.localizedDescription)"
        }
    }
}

extension AFError.ResponseValidationFailureReason {
    var localizedDescription: String {
        switch self {
        case .dataFileNil:
            return "Response could not be validated, data file was nil."
        case .dataFileReadFailed(let url):
            return "Response could not be validated, data file could not be read: \(url)."
        case .missingContentType(let types):
            return (
                "Response Content-Type was missing and acceptable content types " +
                "(\(types.joined(separator: ","))) do not match \"*/*\"."
            )
        case .unacceptableContentType(let acceptableTypes, let responseType):
            return (
                "Response Content-Type \"\(responseType)\" does not match any acceptable types: " +
                "\(acceptableTypes.joined(separator: ","))."
            )
        case .unacceptableStatusCode(let code):
            return "Response status code was unacceptable: \(code)."
        }
    }
}
