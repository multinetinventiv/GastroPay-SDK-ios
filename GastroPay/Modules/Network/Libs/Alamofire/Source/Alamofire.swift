***REMOVED***
***REMOVED***  Alamofire.swift
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

***REMOVED***/ Types adopting the `URLConvertible` protocol can be used to construct URLs, which are then used to construct
***REMOVED***/ URL requests.
public protocol URLConvertible {
    ***REMOVED***/ Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `Error` if the type cannot be converted to a `URL`.
    ***REMOVED***/
    ***REMOVED***/ - returns: A URL or throws an `Error`.
    func asURL() throws -> URL
}

extension String: URLConvertible {
    ***REMOVED***/ Returns a URL if `self` represents a valid URL string that conforms to RFC 2396 or throws an `AFError`.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `AFError.invalidURL` if `self` is not a valid URL string.
    ***REMOVED***/
    ***REMOVED***/ - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw AFError.invalidURL(url: self) }
        return url
    }
}

extension URL: URLConvertible {
    ***REMOVED***/ Returns self.
    public func asURL() throws -> URL { return self }
}

extension URLComponents: URLConvertible {
    ***REMOVED***/ Returns a URL if `url` is not nil, otherwise throws an `Error`.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `AFError.invalidURL` if `url` is `nil`.
    ***REMOVED***/
    ***REMOVED***/ - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = url else { throw AFError.invalidURL(url: self) }
        return url
    }
}

***REMOVED*** MARK: -

***REMOVED***/ Types adopting the `URLRequestConvertible` protocol can be used to construct URL requests.
public protocol URLRequestConvertible {
    ***REMOVED***/ Returns a URL request or throws if an `Error` was encountered.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ***REMOVED***/
    ***REMOVED***/ - returns: A URL request.
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    ***REMOVED***/ The URL request.
    public var urlRequest: URLRequest? { return try? asURLRequest() }
}

extension URLRequest: URLRequestConvertible {
    ***REMOVED***/ Returns a URL request or throws if an `Error` was encountered.
    public func asURLRequest() throws -> URLRequest { return self }
}

***REMOVED*** MARK: -

extension URLRequest {
    ***REMOVED***/ Creates an instance with the specified `method`, `urlString` and `headers`.
    ***REMOVED***/
    ***REMOVED***/ - parameter url:     The URL.
    ***REMOVED***/ - parameter method:  The HTTP method.
    ***REMOVED***/ - parameter headers: The HTTP headers. `nil` by default.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `URLRequest` instance.
    public init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil) throws {
        let url = try url.asURL()

        self.init(url: url)

        httpMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }

    func adapt(using adapter: RequestAdapter?) throws -> URLRequest {
        guard let adapter = adapter else { return self }
        return try adapter.adapt(self)
    }
}

***REMOVED*** MARK: - Data Request

***REMOVED***/ Creates a `DataRequest` using the default `SessionManager` to retrieve the contents of the specified `url`,
***REMOVED***/ `method`, `parameters`, `encoding` and `headers`.
***REMOVED***/
***REMOVED***/ - parameter url:        The URL.
***REMOVED***/ - parameter method:     The HTTP method. `.get` by default.
***REMOVED***/ - parameter parameters: The parameters. `nil` by default.
***REMOVED***/ - parameter encoding:   The parameter encoding. `URLEncoding.default` by default.
***REMOVED***/ - parameter headers:    The HTTP headers. `nil` by default.
***REMOVED***/
***REMOVED***/ - returns: The created `DataRequest`.
@discardableResult
public func request(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil)
    -> DataRequest
{
    return SessionManager.default.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

***REMOVED***/ Creates a `DataRequest` using the default `SessionManager` to retrieve the contents of a URL based on the
***REMOVED***/ specified `urlRequest`.
***REMOVED***/
***REMOVED***/ - parameter urlRequest: The URL request
***REMOVED***/
***REMOVED***/ - returns: The created `DataRequest`.
@discardableResult
public func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
    return SessionManager.default.request(urlRequest)
}

***REMOVED*** MARK: - Download Request

***REMOVED*** MARK: URL Request

***REMOVED***/ Creates a `DownloadRequest` using the default `SessionManager` to retrieve the contents of the specified `url`,
***REMOVED***/ `method`, `parameters`, `encoding`, `headers` and save them to the `destination`.
***REMOVED***/
***REMOVED***/ If `destination` is not specified, the contents will remain in the temporary location determined by the
***REMOVED***/ underlying URL session.
***REMOVED***/
***REMOVED***/ - parameter url:         The URL.
***REMOVED***/ - parameter method:      The HTTP method. `.get` by default.
***REMOVED***/ - parameter parameters:  The parameters. `nil` by default.
***REMOVED***/ - parameter encoding:    The parameter encoding. `URLEncoding.default` by default.
***REMOVED***/ - parameter headers:     The HTTP headers. `nil` by default.
***REMOVED***/ - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
***REMOVED***/
***REMOVED***/ - returns: The created `DownloadRequest`.
@discardableResult
public func download(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    to destination: DownloadRequest.DownloadFileDestination? = nil)
    -> DownloadRequest
{
    return SessionManager.default.download(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers,
        to: destination
    )
}

***REMOVED***/ Creates a `DownloadRequest` using the default `SessionManager` to retrieve the contents of a URL based on the
***REMOVED***/ specified `urlRequest` and save them to the `destination`.
***REMOVED***/
***REMOVED***/ If `destination` is not specified, the contents will remain in the temporary location determined by the
***REMOVED***/ underlying URL session.
***REMOVED***/
***REMOVED***/ - parameter urlRequest:  The URL request.
***REMOVED***/ - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
***REMOVED***/
***REMOVED***/ - returns: The created `DownloadRequest`.
@discardableResult
public func download(
    _ urlRequest: URLRequestConvertible,
    to destination: DownloadRequest.DownloadFileDestination? = nil)
    -> DownloadRequest
{
    return SessionManager.default.download(urlRequest, to: destination)
}

***REMOVED*** MARK: Resume Data

***REMOVED***/ Creates a `DownloadRequest` using the default `SessionManager` from the `resumeData` produced from a
***REMOVED***/ previous request cancellation to retrieve the contents of the original request and save them to the `destination`.
***REMOVED***/
***REMOVED***/ If `destination` is not specified, the contents will remain in the temporary location determined by the
***REMOVED***/ underlying URL session.
***REMOVED***/
***REMOVED***/ On the latest release of all the Apple platforms (iOS 10, macOS 10.12, tvOS 10, watchOS 3), `resumeData` is broken
***REMOVED***/ on background URL session configurations. There's an underlying bug in the `resumeData` generation logic where the
***REMOVED***/ data is written incorrectly and will always fail to resume the download. For more information about the bug and
***REMOVED***/ possible workarounds, please refer to the following Stack Overflow post:
***REMOVED***/
***REMOVED***/    - http:***REMOVED***stackoverflow.com/a/39347461/1342462
***REMOVED***/
***REMOVED***/ - parameter resumeData:  The resume data. This is an opaque data blob produced by `URLSessionDownloadTask`
***REMOVED***/                          when a task is cancelled. See `URLSession -downloadTask(withResumeData:)` for additional
***REMOVED***/                          information.
***REMOVED***/ - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
***REMOVED***/
***REMOVED***/ - returns: The created `DownloadRequest`.
@discardableResult
public func download(
    resumingWith resumeData: Data,
    to destination: DownloadRequest.DownloadFileDestination? = nil)
    -> DownloadRequest
{
    return SessionManager.default.download(resumingWith: resumeData, to: destination)
}

***REMOVED*** MARK: - Upload Request

***REMOVED*** MARK: File

***REMOVED***/ Creates an `UploadRequest` using the default `SessionManager` from the specified `url`, `method` and `headers`
***REMOVED***/ for uploading the `file`.
***REMOVED***/
***REMOVED***/ - parameter file:    The file to upload.
***REMOVED***/ - parameter url:     The URL.
***REMOVED***/ - parameter method:  The HTTP method. `.post` by default.
***REMOVED***/ - parameter headers: The HTTP headers. `nil` by default.
***REMOVED***/
***REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***@discardableResult
***REMOVED***public func upload(
***REMOVED***    _ fileURL: URL,
***REMOVED***    to url: URLConvertible,
***REMOVED***    method: HTTPMethod = .post,
***REMOVED***    headers: HTTPHeaders? = nil)
***REMOVED***    -> UploadRequest
***REMOVED***{
***REMOVED***    return SessionManager.default.upload(fileURL, to: url, method: method, headers: headers)
***REMOVED***}
***REMOVED***
***REMOVED******REMOVED***/ Creates a `UploadRequest` using the default `SessionManager` from the specified `urlRequest` for
***REMOVED******REMOVED***/ uploading the `file`.
***REMOVED******REMOVED***/
***REMOVED******REMOVED***/ - parameter file:       The file to upload.
***REMOVED******REMOVED***/ - parameter urlRequest: The URL request.
***REMOVED******REMOVED***/
***REMOVED******REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***@discardableResult
***REMOVED***public func upload(_ fileURL: URL, with urlRequest: URLRequestConvertible) -> UploadRequest {
***REMOVED***    return SessionManager.default.upload(fileURL, with: urlRequest)
***REMOVED***}
***REMOVED***
***REMOVED******REMOVED*** MARK: Data
***REMOVED***
***REMOVED******REMOVED***/ Creates an `UploadRequest` using the default `SessionManager` from the specified `url`, `method` and `headers`
***REMOVED******REMOVED***/ for uploading the `data`.
***REMOVED******REMOVED***/
***REMOVED******REMOVED***/ - parameter data:    The data to upload.
***REMOVED******REMOVED***/ - parameter url:     The URL.
***REMOVED******REMOVED***/ - parameter method:  The HTTP method. `.post` by default.
***REMOVED******REMOVED***/ - parameter headers: The HTTP headers. `nil` by default.
***REMOVED******REMOVED***/
***REMOVED******REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***@discardableResult
***REMOVED***public func upload(
***REMOVED***    _ data: Data,
***REMOVED***    to url: URLConvertible,
***REMOVED***    method: HTTPMethod = .post,
***REMOVED***    headers: HTTPHeaders? = nil)
***REMOVED***    -> UploadRequest
***REMOVED***{
***REMOVED***    return SessionManager.default.upload(data, to: url, method: method, headers: headers)
***REMOVED***}
***REMOVED***
***REMOVED******REMOVED***/ Creates an `UploadRequest` using the default `SessionManager` from the specified `urlRequest` for
***REMOVED******REMOVED***/ uploading the `data`.
***REMOVED******REMOVED***/
***REMOVED******REMOVED***/ - parameter data:       The data to upload.
***REMOVED******REMOVED***/ - parameter urlRequest: The URL request.
***REMOVED******REMOVED***/
***REMOVED******REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***@discardableResult
***REMOVED***public func upload(_ data: Data, with urlRequest: URLRequestConvertible) -> UploadRequest {
***REMOVED***    return SessionManager.default.upload(data, with: urlRequest)
***REMOVED***}
***REMOVED***
***REMOVED******REMOVED*** MARK: InputStream
***REMOVED***
***REMOVED******REMOVED***/ Creates an `UploadRequest` using the default `SessionManager` from the specified `url`, `method` and `headers`
***REMOVED******REMOVED***/ for uploading the `stream`.
***REMOVED******REMOVED***/
***REMOVED******REMOVED***/ - parameter stream:  The stream to upload.
***REMOVED******REMOVED***/ - parameter url:     The URL.
***REMOVED******REMOVED***/ - parameter method:  The HTTP method. `.post` by default.
***REMOVED******REMOVED***/ - parameter headers: The HTTP headers. `nil` by default.
***REMOVED******REMOVED***/
***REMOVED******REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***@discardableResult
***REMOVED***public func upload(
***REMOVED***    _ stream: InputStream,
***REMOVED***    to url: URLConvertible,
***REMOVED***    method: HTTPMethod = .post,
***REMOVED***    headers: HTTPHeaders? = nil)
***REMOVED***    -> UploadRequest
***REMOVED***{
***REMOVED***    return SessionManager.default.upload(stream, to: url, method: method, headers: headers)
***REMOVED***}
***REMOVED***
***REMOVED******REMOVED***/ Creates an `UploadRequest` using the default `SessionManager` from the specified `urlRequest` for
***REMOVED******REMOVED***/ uploading the `stream`.
***REMOVED******REMOVED***/
***REMOVED******REMOVED***/ - parameter urlRequest: The URL request.
***REMOVED******REMOVED***/ - parameter stream:     The stream to upload.
***REMOVED******REMOVED***/
***REMOVED******REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***@discardableResult
***REMOVED***public func upload(_ stream: InputStream, with urlRequest: URLRequestConvertible) -> UploadRequest {
***REMOVED***    return SessionManager.default.upload(stream, with: urlRequest)
***REMOVED***}

***REMOVED*** MARK: MultipartFormData

***REMOVED***/ Encodes `multipartFormData` using `encodingMemoryThreshold` with the default `SessionManager` and calls
***REMOVED***/ `encodingCompletion` with new `UploadRequest` using the `url`, `method` and `headers`.
***REMOVED***/
***REMOVED***/ It is important to understand the memory implications of uploading `MultipartFormData`. If the cummulative
***REMOVED***/ payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
***REMOVED***/ efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
***REMOVED***/ be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
***REMOVED***/ footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
***REMOVED***/ used for larger payloads such as video content.
***REMOVED***/
***REMOVED***/ The `encodingMemoryThreshold` parameter allows Alamofire to automatically determine whether to encode in-memory
***REMOVED***/ or stream from disk. If the content length of the `MultipartFormData` is below the `encodingMemoryThreshold`,
***REMOVED***/ encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
***REMOVED***/ during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
***REMOVED***/ technique was used.
***REMOVED***/
***REMOVED***/ - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
***REMOVED***/ - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
***REMOVED***/                                      `multipartFormDataEncodingMemoryThreshold` by default.
***REMOVED***/ - parameter url:                     The URL.
***REMOVED***/ - parameter method:                  The HTTP method. `.post` by default.
***REMOVED***/ - parameter headers:                 The HTTP headers. `nil` by default.
***REMOVED***/ - parameter encodingCompletion:      The closure called when the `MultipartFormData` encoding is complete.
***REMOVED***public func upload(
***REMOVED***    multipartFormData: @escaping (MultipartFormData) -> Void,
***REMOVED***    usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
***REMOVED***    to url: URLConvertible,
***REMOVED***    method: HTTPMethod = .post,
***REMOVED***    headers: HTTPHeaders? = nil,
***REMOVED***    encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?)
***REMOVED***{
***REMOVED***    return SessionManager.default.upload(
***REMOVED***        multipartFormData: multipartFormData,
***REMOVED***        usingThreshold: encodingMemoryThreshold,
***REMOVED***        to: url,
***REMOVED***        method: method,
***REMOVED***        headers: headers,
***REMOVED***        encodingCompletion: encodingCompletion
***REMOVED***    )
***REMOVED***}

***REMOVED***/ Encodes `multipartFormData` using `encodingMemoryThreshold` and the default `SessionManager` and
***REMOVED***/ calls `encodingCompletion` with new `UploadRequest` using the `urlRequest`.
***REMOVED***/
***REMOVED***/ It is important to understand the memory implications of uploading `MultipartFormData`. If the cummulative
***REMOVED***/ payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
***REMOVED***/ efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
***REMOVED***/ be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
***REMOVED***/ footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
***REMOVED***/ used for larger payloads such as video content.
***REMOVED***/
***REMOVED***/ The `encodingMemoryThreshold` parameter allows Alamofire to automatically determine whether to encode in-memory
***REMOVED***/ or stream from disk. If the content length of the `MultipartFormData` is below the `encodingMemoryThreshold`,
***REMOVED***/ encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
***REMOVED***/ during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
***REMOVED***/ technique was used.
***REMOVED***/
***REMOVED***/ - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
***REMOVED***/ - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
***REMOVED***/                                      `multipartFormDataEncodingMemoryThreshold` by default.
***REMOVED***/ - parameter urlRequest:              The URL request.
***REMOVED***/ - parameter encodingCompletion:      The closure called when the `MultipartFormData` encoding is complete.
***REMOVED***public func upload(
***REMOVED***    multipartFormData: @escaping (MultipartFormData) -> Void,
***REMOVED***    usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
***REMOVED***    with urlRequest: URLRequestConvertible,
***REMOVED***    encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?)
***REMOVED***{
***REMOVED***    return SessionManager.default.upload(
***REMOVED***        multipartFormData: multipartFormData,
***REMOVED***        usingThreshold: encodingMemoryThreshold,
***REMOVED***        with: urlRequest,
***REMOVED***        encodingCompletion: encodingCompletion
***REMOVED***    )
***REMOVED***}

#if !os(watchOS)

***REMOVED*** MARK: - Stream Request

***REMOVED*** MARK: Hostname and Port

***REMOVED***/ Creates a `StreamRequest` using the default `SessionManager` for bidirectional streaming with the `hostname`
***REMOVED***/ and `port`.
***REMOVED***/
***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
***REMOVED***/
***REMOVED***/ - parameter hostName: The hostname of the server to connect to.
***REMOVED***/ - parameter port:     The port of the server to connect to.
***REMOVED***/
***REMOVED***/ - returns: The created `StreamRequest`.
@discardableResult
@available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
public func stream(withHostName hostName: String, port: Int) -> StreamRequest {
    return SessionManager.default.stream(withHostName: hostName, port: port)
}

***REMOVED*** MARK: NetService

***REMOVED***/ Creates a `StreamRequest` using the default `SessionManager` for bidirectional streaming with the `netService`.
***REMOVED***/
***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
***REMOVED***/
***REMOVED***/ - parameter netService: The net service used to identify the endpoint.
***REMOVED***/
***REMOVED***/ - returns: The created `StreamRequest`.
@discardableResult
@available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
public func stream(with netService: NetService) -> StreamRequest {
    return SessionManager.default.stream(with: netService)
}

#endif
