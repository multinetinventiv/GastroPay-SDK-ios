***REMOVED***
***REMOVED***  MultipartFormData.swift
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

#if os(iOS) || os(watchOS) || os(tvOS)
import MobileCoreServices
#elseif os(macOS)
import CoreServices
#endif

***REMOVED***/ Constructs `multipart/form-data` for uploads within an HTTP or HTTPS body. There are currently two ways to encode
***REMOVED***/ multipart form data. The first way is to encode the data directly in memory. This is very efficient, but can lead
***REMOVED***/ to memory issues if the dataset is too large. The second way is designed for larger datasets and will write all the
***REMOVED***/ data to a single file on disk with all the proper boundary segmentation. The second approach MUST be used for
***REMOVED***/ larger datasets such as video content, otherwise your app may run out of memory when trying to encode the dataset.
***REMOVED***/
***REMOVED***/ For more information on `multipart/form-data` in general, please refer to the RFC-2388 and RFC-2045 specs as well
***REMOVED***/ and the w3 form documentation.
***REMOVED***/
***REMOVED***/ - https:***REMOVED***www.ietf.org/rfc/rfc2388.txt
***REMOVED***/ - https:***REMOVED***www.ietf.org/rfc/rfc2045.txt
***REMOVED***/ - https:***REMOVED***www.w3.org/TR/html401/interact/forms.html#h-17.13
open class MultipartFormData {

    ***REMOVED*** MARK: - Helper Types

    struct EncodingCharacters {
        static let crlf = "\r\n"
    }

    struct BoundaryGenerator {
        enum BoundaryType {
            case initial, encapsulated, final
        }

        static func randomBoundary() -> String {
            return String(format: "alamofire.boundary.%08x%08x", arc4random(), arc4random())
        }

        static func boundaryData(forBoundaryType boundaryType: BoundaryType, boundary: String) -> Data {
            let boundaryText: String

            switch boundaryType {
            case .initial:
                boundaryText = "--\(boundary)\(EncodingCharacters.crlf)"
            case .encapsulated:
                boundaryText = "\(EncodingCharacters.crlf)--\(boundary)\(EncodingCharacters.crlf)"
            case .final:
                boundaryText = "\(EncodingCharacters.crlf)--\(boundary)--\(EncodingCharacters.crlf)"
            }

            return boundaryText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        }
    }

    class BodyPart {
        let headers: HTTPHeaders
        let bodyStream: InputStream
        let bodyContentLength: UInt64
        var hasInitialBoundary = false
        var hasFinalBoundary = false

        init(headers: HTTPHeaders, bodyStream: InputStream, bodyContentLength: UInt64) {
            self.headers = headers
            self.bodyStream = bodyStream
            self.bodyContentLength = bodyContentLength
        }
    }

    ***REMOVED*** MARK: - Properties

    ***REMOVED***/ The `Content-Type` header value containing the boundary used to generate the `multipart/form-data`.
    open lazy var contentType: String = "multipart/form-data; boundary=\(self.boundary)"

    ***REMOVED***/ The content length of all body parts used to generate the `multipart/form-data` not including the boundaries.
    public var contentLength: UInt64 { return bodyParts.reduce(0) { $0 + $1.bodyContentLength } }

    ***REMOVED***/ The boundary used to separate the body parts in the encoded form data.
    public var boundary: String

    private var bodyParts: [BodyPart]
    private var bodyPartError: AFError?
    private let streamBufferSize: Int

    ***REMOVED*** MARK: - Lifecycle

    ***REMOVED***/ Creates a multipart form data object.
    ***REMOVED***/
    ***REMOVED***/ - returns: The multipart form data object.
    public init() {
        self.boundary = BoundaryGenerator.randomBoundary()
        self.bodyParts = []

        ***REMOVED***/
        ***REMOVED***/ The optimal read/write buffer size in bytes for input and output streams is 1024 (1KB). For more
        ***REMOVED***/ information, please refer to the following article:
        ***REMOVED***/   - https:***REMOVED***developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Streams/Articles/ReadingInputStreams.html
        ***REMOVED***/

        self.streamBufferSize = 1024
    }

    ***REMOVED*** MARK: - Body Parts

    ***REMOVED***/ Creates a body part from the data and appends it to the multipart form data object.
    ***REMOVED***/
    ***REMOVED***/ The body part data will be encoded using the following format:
    ***REMOVED***/
    ***REMOVED***/ - `Content-Disposition: form-data; name=#{name}` (HTTP Header)
    ***REMOVED***/ - Encoded data
    ***REMOVED***/ - Multipart form boundary
    ***REMOVED***/
    ***REMOVED***/ - parameter data: The data to encode into the multipart form data.
    ***REMOVED***/ - parameter name: The name to associate with the data in the `Content-Disposition` HTTP header.
    public func append(_ data: Data, withName name: String) {
        let headers = contentHeaders(withName: name)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)

        append(stream, withLength: length, headers: headers)
    }

    ***REMOVED***/ Creates a body part from the data and appends it to the multipart form data object.
    ***REMOVED***/
    ***REMOVED***/ The body part data will be encoded using the following format:
    ***REMOVED***/
    ***REMOVED***/ - `Content-Disposition: form-data; name=#{name}` (HTTP Header)
    ***REMOVED***/ - `Content-Type: #{generated mimeType}` (HTTP Header)
    ***REMOVED***/ - Encoded data
    ***REMOVED***/ - Multipart form boundary
    ***REMOVED***/
    ***REMOVED***/ - parameter data:     The data to encode into the multipart form data.
    ***REMOVED***/ - parameter name:     The name to associate with the data in the `Content-Disposition` HTTP header.
    ***REMOVED***/ - parameter mimeType: The MIME type to associate with the data content type in the `Content-Type` HTTP header.
    public func append(_ data: Data, withName name: String, mimeType: String) {
        let headers = contentHeaders(withName: name, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)

        append(stream, withLength: length, headers: headers)
    }

    ***REMOVED***/ Creates a body part from the data and appends it to the multipart form data object.
    ***REMOVED***/
    ***REMOVED***/ The body part data will be encoded using the following format:
    ***REMOVED***/
    ***REMOVED***/ - `Content-Disposition: form-data; name=#{name}; filename=#{filename}` (HTTP Header)
    ***REMOVED***/ - `Content-Type: #{mimeType}` (HTTP Header)
    ***REMOVED***/ - Encoded file data
    ***REMOVED***/ - Multipart form boundary
    ***REMOVED***/
    ***REMOVED***/ - parameter data:     The data to encode into the multipart form data.
    ***REMOVED***/ - parameter name:     The name to associate with the data in the `Content-Disposition` HTTP header.
    ***REMOVED***/ - parameter fileName: The filename to associate with the data in the `Content-Disposition` HTTP header.
    ***REMOVED***/ - parameter mimeType: The MIME type to associate with the data in the `Content-Type` HTTP header.
    public func append(_ data: Data, withName name: String, fileName: String, mimeType: String) {
        let headers = contentHeaders(withName: name, fileName: fileName, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)

        append(stream, withLength: length, headers: headers)
    }

    ***REMOVED***/ Creates a body part from the file and appends it to the multipart form data object.
    ***REMOVED***/
    ***REMOVED***/ The body part data will be encoded using the following format:
    ***REMOVED***/
    ***REMOVED***/ - `Content-Disposition: form-data; name=#{name}; filename=#{generated filename}` (HTTP Header)
    ***REMOVED***/ - `Content-Type: #{generated mimeType}` (HTTP Header)
    ***REMOVED***/ - Encoded file data
    ***REMOVED***/ - Multipart form boundary
    ***REMOVED***/
    ***REMOVED***/ The filename in the `Content-Disposition` HTTP header is generated from the last path component of the
    ***REMOVED***/ `fileURL`. The `Content-Type` HTTP header MIME type is generated by mapping the `fileURL` extension to the
    ***REMOVED***/ system associated MIME type.
    ***REMOVED***/
    ***REMOVED***/ - parameter fileURL: The URL of the file whose content will be encoded into the multipart form data.
    ***REMOVED***/ - parameter name:    The name to associate with the file content in the `Content-Disposition` HTTP header.
    public func append(_ fileURL: URL, withName name: String) {
        let fileName = fileURL.lastPathComponent
        let pathExtension = fileURL.pathExtension

        if !fileName.isEmpty && !pathExtension.isEmpty {
            let mime = mimeType(forPathExtension: pathExtension)
            append(fileURL, withName: name, fileName: fileName, mimeType: mime)
        } else {
            setBodyPartError(withReason: .bodyPartFilenameInvalid(in: fileURL))
        }
    }

    ***REMOVED***/ Creates a body part from the file and appends it to the multipart form data object.
    ***REMOVED***/
    ***REMOVED***/ The body part data will be encoded using the following format:
    ***REMOVED***/
    ***REMOVED***/ - Content-Disposition: form-data; name=#{name}; filename=#{filename} (HTTP Header)
    ***REMOVED***/ - Content-Type: #{mimeType} (HTTP Header)
    ***REMOVED***/ - Encoded file data
    ***REMOVED***/ - Multipart form boundary
    ***REMOVED***/
    ***REMOVED***/ - parameter fileURL:  The URL of the file whose content will be encoded into the multipart form data.
    ***REMOVED***/ - parameter name:     The name to associate with the file content in the `Content-Disposition` HTTP header.
    ***REMOVED***/ - parameter fileName: The filename to associate with the file content in the `Content-Disposition` HTTP header.
    ***REMOVED***/ - parameter mimeType: The MIME type to associate with the file content in the `Content-Type` HTTP header.
    public func append(_ fileURL: URL, withName name: String, fileName: String, mimeType: String) {
        let headers = contentHeaders(withName: name, fileName: fileName, mimeType: mimeType)

        ***REMOVED***============================================================
        ***REMOVED***                 Check 1 - is file URL?
        ***REMOVED***============================================================

        guard fileURL.isFileURL else {
            setBodyPartError(withReason: .bodyPartURLInvalid(url: fileURL))
            return
        }

        ***REMOVED***============================================================
        ***REMOVED***              Check 2 - is file URL reachable?
        ***REMOVED***============================================================

        do {
            let isReachable = try fileURL.checkPromisedItemIsReachable()
            guard isReachable else {
                setBodyPartError(withReason: .bodyPartFileNotReachable(at: fileURL))
                return
            }
        } catch {
            setBodyPartError(withReason: .bodyPartFileNotReachableWithError(atURL: fileURL, error: error))
            return
        }

        ***REMOVED***============================================================
        ***REMOVED***            Check 3 - is file URL a directory?
        ***REMOVED***============================================================

        var isDirectory: ObjCBool = false
        let path = fileURL.path

        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) && !isDirectory.boolValue else {
            setBodyPartError(withReason: .bodyPartFileIsDirectory(at: fileURL))
            return
        }

        ***REMOVED***============================================================
        ***REMOVED***          Check 4 - can the file size be extracted?
        ***REMOVED***============================================================

        let bodyContentLength: UInt64

        do {
            guard let fileSize = try FileManager.default.attributesOfItem(atPath: path)[.size] as? NSNumber else {
                setBodyPartError(withReason: .bodyPartFileSizeNotAvailable(at: fileURL))
                return
            }

            bodyContentLength = fileSize.uint64Value
        }
        catch {
            setBodyPartError(withReason: .bodyPartFileSizeQueryFailedWithError(forURL: fileURL, error: error))
            return
        }

        ***REMOVED***============================================================
        ***REMOVED***       Check 5 - can a stream be created from file URL?
        ***REMOVED***============================================================

        guard let stream = InputStream(url: fileURL) else {
            setBodyPartError(withReason: .bodyPartInputStreamCreationFailed(for: fileURL))
            return
        }

        append(stream, withLength: bodyContentLength, headers: headers)
    }

    ***REMOVED***/ Creates a body part from the stream and appends it to the multipart form data object.
    ***REMOVED***/
    ***REMOVED***/ The body part data will be encoded using the following format:
    ***REMOVED***/
    ***REMOVED***/ - `Content-Disposition: form-data; name=#{name}; filename=#{filename}` (HTTP Header)
    ***REMOVED***/ - `Content-Type: #{mimeType}` (HTTP Header)
    ***REMOVED***/ - Encoded stream data
    ***REMOVED***/ - Multipart form boundary
    ***REMOVED***/
    ***REMOVED***/ - parameter stream:   The input stream to encode in the multipart form data.
    ***REMOVED***/ - parameter length:   The content length of the stream.
    ***REMOVED***/ - parameter name:     The name to associate with the stream content in the `Content-Disposition` HTTP header.
    ***REMOVED***/ - parameter fileName: The filename to associate with the stream content in the `Content-Disposition` HTTP header.
    ***REMOVED***/ - parameter mimeType: The MIME type to associate with the stream content in the `Content-Type` HTTP header.
    public func append(
        _ stream: InputStream,
        withLength length: UInt64,
        name: String,
        fileName: String,
        mimeType: String)
    {
        let headers = contentHeaders(withName: name, fileName: fileName, mimeType: mimeType)
        append(stream, withLength: length, headers: headers)
    }

    ***REMOVED***/ Creates a body part with the headers, stream and length and appends it to the multipart form data object.
    ***REMOVED***/
    ***REMOVED***/ The body part data will be encoded using the following format:
    ***REMOVED***/
    ***REMOVED***/ - HTTP headers
    ***REMOVED***/ - Encoded stream data
    ***REMOVED***/ - Multipart form boundary
    ***REMOVED***/
    ***REMOVED***/ - parameter stream:  The input stream to encode in the multipart form data.
    ***REMOVED***/ - parameter length:  The content length of the stream.
    ***REMOVED***/ - parameter headers: The HTTP headers for the body part.
    public func append(_ stream: InputStream, withLength length: UInt64, headers: HTTPHeaders) {
        let bodyPart = BodyPart(headers: headers, bodyStream: stream, bodyContentLength: length)
        bodyParts.append(bodyPart)
    }

    ***REMOVED*** MARK: - Data Encoding

    ***REMOVED***/ Encodes all the appended body parts into a single `Data` value.
    ***REMOVED***/
    ***REMOVED***/ It is important to note that this method will load all the appended body parts into memory all at the same
    ***REMOVED***/ time. This method should only be used when the encoded data will have a small memory footprint. For large data
    ***REMOVED***/ cases, please use the `writeEncodedDataToDisk(fileURL:completionHandler:)` method.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `AFError` if encoding encounters an error.
    ***REMOVED***/
    ***REMOVED***/ - returns: The encoded `Data` if encoding is successful.
    public func encode() throws -> Data {
        if let bodyPartError = bodyPartError {
            throw bodyPartError
        }

        var encoded = Data()

        bodyParts.first?.hasInitialBoundary = true
        bodyParts.last?.hasFinalBoundary = true

        for bodyPart in bodyParts {
            let encodedData = try encode(bodyPart)
            encoded.append(encodedData)
        }

        return encoded
    }

    ***REMOVED***/ Writes the appended body parts into the given file URL.
    ***REMOVED***/
    ***REMOVED***/ This process is facilitated by reading and writing with input and output streams, respectively. Thus,
    ***REMOVED***/ this approach is very memory efficient and should be used for large body part data.
    ***REMOVED***/
    ***REMOVED***/ - parameter fileURL: The file URL to write the multipart form data into.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `AFError` if encoding encounters an error.
    public func writeEncodedData(to fileURL: URL) throws {
        if let bodyPartError = bodyPartError {
            throw bodyPartError
        }

        if FileManager.default.fileExists(atPath: fileURL.path) {
            throw AFError.multipartEncodingFailed(reason: .outputStreamFileAlreadyExists(at: fileURL))
        } else if !fileURL.isFileURL {
            throw AFError.multipartEncodingFailed(reason: .outputStreamURLInvalid(url: fileURL))
        }

        guard let outputStream = OutputStream(url: fileURL, append: false) else {
            throw AFError.multipartEncodingFailed(reason: .outputStreamCreationFailed(for: fileURL))
        }

        outputStream.open()
        defer { outputStream.close() }

        self.bodyParts.first?.hasInitialBoundary = true
        self.bodyParts.last?.hasFinalBoundary = true

        for bodyPart in self.bodyParts {
            try write(bodyPart, to: outputStream)
        }
    }

    ***REMOVED*** MARK: - Private - Body Part Encoding

    private func encode(_ bodyPart: BodyPart) throws -> Data {
        var encoded = Data()

        let initialData = bodyPart.hasInitialBoundary ? initialBoundaryData() : encapsulatedBoundaryData()
        encoded.append(initialData)

        let headerData = encodeHeaders(for: bodyPart)
        encoded.append(headerData)

        let bodyStreamData = try encodeBodyStream(for: bodyPart)
        encoded.append(bodyStreamData)

        if bodyPart.hasFinalBoundary {
            encoded.append(finalBoundaryData())
        }

        return encoded
    }

    private func encodeHeaders(for bodyPart: BodyPart) -> Data {
        var headerText = ""

        for (key, value) in bodyPart.headers {
            headerText += "\(key): \(value)\(EncodingCharacters.crlf)"
        }
        headerText += EncodingCharacters.crlf

        return headerText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }

    private func encodeBodyStream(for bodyPart: BodyPart) throws -> Data {
        let inputStream = bodyPart.bodyStream
        inputStream.open()
        defer { inputStream.close() }

        var encoded = Data()

        while inputStream.hasBytesAvailable {
            var buffer = [UInt8](repeating: 0, count: streamBufferSize)
            let bytesRead = inputStream.read(&buffer, maxLength: streamBufferSize)

            if let error = inputStream.streamError {
                throw AFError.multipartEncodingFailed(reason: .inputStreamReadFailed(error: error))
            }

            if bytesRead > 0 {
                encoded.append(buffer, count: bytesRead)
            } else {
                break
            }
        }

        return encoded
    }

    ***REMOVED*** MARK: - Private - Writing Body Part to Output Stream

    private func write(_ bodyPart: BodyPart, to outputStream: OutputStream) throws {
        try writeInitialBoundaryData(for: bodyPart, to: outputStream)
        try writeHeaderData(for: bodyPart, to: outputStream)
        try writeBodyStream(for: bodyPart, to: outputStream)
        try writeFinalBoundaryData(for: bodyPart, to: outputStream)
    }

    private func writeInitialBoundaryData(for bodyPart: BodyPart, to outputStream: OutputStream) throws {
        let initialData = bodyPart.hasInitialBoundary ? initialBoundaryData() : encapsulatedBoundaryData()
        return try write(initialData, to: outputStream)
    }

    private func writeHeaderData(for bodyPart: BodyPart, to outputStream: OutputStream) throws {
        let headerData = encodeHeaders(for: bodyPart)
        return try write(headerData, to: outputStream)
    }

    private func writeBodyStream(for bodyPart: BodyPart, to outputStream: OutputStream) throws {
        let inputStream = bodyPart.bodyStream

        inputStream.open()
        defer { inputStream.close() }

        while inputStream.hasBytesAvailable {
            var buffer = [UInt8](repeating: 0, count: streamBufferSize)
            let bytesRead = inputStream.read(&buffer, maxLength: streamBufferSize)

            if let streamError = inputStream.streamError {
                throw AFError.multipartEncodingFailed(reason: .inputStreamReadFailed(error: streamError))
            }

            if bytesRead > 0 {
                if buffer.count != bytesRead {
                    buffer = Array(buffer[0..<bytesRead])
                }

                try write(&buffer, to: outputStream)
            } else {
                break
            }
        }
    }

    private func writeFinalBoundaryData(for bodyPart: BodyPart, to outputStream: OutputStream) throws {
        if bodyPart.hasFinalBoundary {
            return try write(finalBoundaryData(), to: outputStream)
        }
    }

    ***REMOVED*** MARK: - Private - Writing Buffered Data to Output Stream

    private func write(_ data: Data, to outputStream: OutputStream) throws {
        var buffer = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &buffer, count: data.count)

        return try write(&buffer, to: outputStream)
    }

    private func write(_ buffer: inout [UInt8], to outputStream: OutputStream) throws {
        var bytesToWrite = buffer.count

        while bytesToWrite > 0, outputStream.hasSpaceAvailable {
            let bytesWritten = outputStream.write(buffer, maxLength: bytesToWrite)

            if let error = outputStream.streamError {
                throw AFError.multipartEncodingFailed(reason: .outputStreamWriteFailed(error: error))
            }

            bytesToWrite -= bytesWritten

            if bytesToWrite > 0 {
                buffer = Array(buffer[bytesWritten..<buffer.count])
            }
        }
    }

    ***REMOVED*** MARK: - Private - Mime Type

    private func mimeType(forPathExtension pathExtension: String) -> String {
        if
            let id = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
            let contentType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue()
        {
            return contentType as String
        }

        return "application/octet-stream"
    }

    ***REMOVED*** MARK: - Private - Content Headers

    private func contentHeaders(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> [String: String] {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName { disposition += "; filename=\"\(fileName)\"" }

        var headers = ["Content-Disposition": disposition]
        if let mimeType = mimeType { headers["Content-Type"] = mimeType }

        return headers
    }

    ***REMOVED*** MARK: - Private - Boundary Encoding

    private func initialBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .initial, boundary: boundary)
    }

    private func encapsulatedBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .encapsulated, boundary: boundary)
    }

    private func finalBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .final, boundary: boundary)
    }

    ***REMOVED*** MARK: - Private - Errors

    private func setBodyPartError(withReason reason: AFError.MultipartEncodingFailureReason) {
        guard bodyPartError == nil else { return }
        bodyPartError = AFError.multipartEncodingFailed(reason: reason)
    }
}
