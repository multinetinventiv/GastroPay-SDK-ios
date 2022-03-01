***REMOVED***
***REMOVED***  SessionManager.swift
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

***REMOVED***/ Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
open class SessionManager {

    ***REMOVED*** MARK: - Helper Types

    ***REMOVED***/ Defines whether the `MultipartFormData` encoding was successful and contains result of the encoding as
    ***REMOVED***/ associated values.
    ***REMOVED***/
    ***REMOVED***/ - Success: Represents a successful `MultipartFormData` encoding and contains the new `UploadRequest` along with
    ***REMOVED***/            streaming information.
    ***REMOVED***/ - Failure: Used to represent a failure in the `MultipartFormData` encoding and also contains the encoding
    ***REMOVED***/            error.
    public enum MultipartFormDataEncodingResult {
        case success(request: UploadRequest, streamingFromDisk: Bool, streamFileURL: URL?)
        case failure(Error)
    }

    ***REMOVED*** MARK: - Properties

    ***REMOVED***/ A default instance of `SessionManager`, used by top-level Alamofire request methods, and suitable for use
    ***REMOVED***/ directly for any ad hoc requests.
    public static let `default`: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        return SessionManager(configuration: configuration)
    }()

    ***REMOVED***/ Creates default values for the "Accept-Encoding", "Accept-Language" and "User-Agent" headers.
    public static let defaultHTTPHeaders: HTTPHeaders = {
        ***REMOVED*** Accept-Encoding HTTP Header; see https:***REMOVED***tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"

        ***REMOVED*** Accept-Language HTTP Header; see https:***REMOVED***tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
        }.joined(separator: ", ")

        ***REMOVED*** User-Agent Header; see https:***REMOVED***tools.ietf.org/html/rfc7231#section-5.5.3
        ***REMOVED*** Example: `iOS Example/1.0 (org.alamofire.iOS-Example; build:1; iOS 10.0.0) Alamofire/4.0.0`
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(macOS)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()

                    return "\(osName) \(versionString)"
                }()

                let alamofireVersion: String = {
                    guard
                        let afInfo = Bundle(for: SessionManager.self).infoDictionary,
                        let build = afInfo["CFBundleShortVersionString"]
                    else { return "Unknown" }

                    return "Alamofire/\(build)"
                }()

                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(alamofireVersion)"
            }

            return "Alamofire"
        }()

        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()

    ***REMOVED***/ Default memory threshold used when encoding `MultipartFormData` in bytes.
    public static let multipartFormDataEncodingMemoryThreshold: UInt64 = 10_000_000

    ***REMOVED***/ The underlying session.
    public let session: URLSession

    ***REMOVED***/ The session delegate handling all the task and session delegate callbacks.
    public let delegate: SessionDelegate

    ***REMOVED***/ Whether to start requests immediately after being constructed. `true` by default.
    open var startRequestsImmediately: Bool = true

    ***REMOVED***/ The request adapter called each time a new request is created.
    open var adapter: RequestAdapter?

    ***REMOVED***/ The request retrier called each time a request encounters an error to determine whether to retry the request.
    open var retrier: RequestRetrier? {
        get { return delegate.retrier }
        set { delegate.retrier = newValue }
    }

    ***REMOVED***/ The background completion handler closure provided by the UIApplicationDelegate
    ***REMOVED***/ `application:handleEventsForBackgroundURLSession:completionHandler:` method. By setting the background
    ***REMOVED***/ completion handler, the SessionDelegate `sessionDidFinishEventsForBackgroundURLSession` closure implementation
    ***REMOVED***/ will automatically call the handler.
    ***REMOVED***/
    ***REMOVED***/ If you need to handle your own events before the handler is called, then you need to override the
    ***REMOVED***/ SessionDelegate `sessionDidFinishEventsForBackgroundURLSession` and manually call the handler when finished.
    ***REMOVED***/
    ***REMOVED***/ `nil` by default.
    open var backgroundCompletionHandler: (() -> Void)?

    let queue = DispatchQueue(label: "org.alamofire.session-manager." + UUID().uuidString)

    ***REMOVED*** MARK: - Lifecycle

    ***REMOVED***/ Creates an instance with the specified `configuration`, `delegate` and `serverTrustPolicyManager`.
    ***REMOVED***/
    ***REMOVED***/ - parameter configuration:            The configuration used to construct the managed session.
    ***REMOVED***/                                       `URLSessionConfiguration.default` by default.
    ***REMOVED***/ - parameter delegate:                 The delegate used when initializing the session. `SessionDelegate()` by
    ***REMOVED***/                                       default.
    ***REMOVED***/ - parameter serverTrustPolicyManager: The server trust policy manager to use for evaluating all server trust
    ***REMOVED***/                                       challenges. `nil` by default.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `SessionManager` instance.
    public init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default,
        delegate: SessionDelegate = SessionDelegate(),
        serverTrustPolicyManager: ServerTrustPolicyManager? = nil)
    {
        self.delegate = delegate
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)

        commonInit(serverTrustPolicyManager: serverTrustPolicyManager)
    }

    ***REMOVED***/ Creates an instance with the specified `session`, `delegate` and `serverTrustPolicyManager`.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:                  The URL session.
    ***REMOVED***/ - parameter delegate:                 The delegate of the URL session. Must equal the URL session's delegate.
    ***REMOVED***/ - parameter serverTrustPolicyManager: The server trust policy manager to use for evaluating all server trust
    ***REMOVED***/                                       challenges. `nil` by default.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `SessionManager` instance if the URL session's delegate matches; `nil` otherwise.
    public init?(
        session: URLSession,
        delegate: SessionDelegate,
        serverTrustPolicyManager: ServerTrustPolicyManager? = nil)
    {
        guard delegate === session.delegate else { return nil }

        self.delegate = delegate
        self.session = session

        commonInit(serverTrustPolicyManager: serverTrustPolicyManager)
    }

    private func commonInit(serverTrustPolicyManager: ServerTrustPolicyManager?) {
        session.serverTrustPolicyManager = serverTrustPolicyManager

        delegate.sessionManager = self

        delegate.sessionDidFinishEventsForBackgroundURLSession = { [weak self] session in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async { strongSelf.backgroundCompletionHandler?() }
        }
    }

    deinit {
        session.invalidateAndCancel()
    }

    ***REMOVED*** MARK: - Data Request

    ***REMOVED***/ Creates a `DataRequest` to retrieve the contents of the specified `url`, `method`, `parameters`, `encoding`
    ***REMOVED***/ and `headers`.
    ***REMOVED***/
    ***REMOVED***/ - parameter url:        The URL.
    ***REMOVED***/ - parameter method:     The HTTP method. `.get` by default.
    ***REMOVED***/ - parameter parameters: The parameters. `nil` by default.
    ***REMOVED***/ - parameter encoding:   The parameter encoding. `URLEncoding.default` by default.
    ***REMOVED***/ - parameter headers:    The HTTP headers. `nil` by default.
    ***REMOVED***/
    ***REMOVED***/ - returns: The created `DataRequest`.
    @discardableResult
    open func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        var originalRequest: URLRequest?

        do {
            originalRequest = try URLRequest(url: url, method: method, headers: headers)
            let encodedURLRequest = try encoding.encode(originalRequest!, with: parameters)
            return request(encodedURLRequest)
        } catch {
            return request(originalRequest, failedWith: error)
        }
    }

    ***REMOVED***/ Creates a `DataRequest` to retrieve the contents of a URL based on the specified `urlRequest`.
    ***REMOVED***/
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ***REMOVED***/
    ***REMOVED***/ - parameter urlRequest: The URL request.
    ***REMOVED***/
    ***REMOVED***/ - returns: The created `DataRequest`.
    @discardableResult
    open func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        var originalRequest: URLRequest?

        do {
            originalRequest = try urlRequest.asURLRequest()
            let originalTask = DataRequest.Requestable(urlRequest: originalRequest!)

            let task = try originalTask.task(session: session, adapter: adapter, queue: queue)
            let request = DataRequest(session: session, requestTask: .data(originalTask, task))

            delegate[task] = request

            if startRequestsImmediately { request.resume() }

            return request
        } catch {
            return request(originalRequest, failedWith: error)
        }
    }

    ***REMOVED*** MARK: Private - Request Implementation

    private func request(_ urlRequest: URLRequest?, failedWith error: Error) -> DataRequest {
        var requestTask: Request.RequestTask = .data(nil, nil)

        if let urlRequest = urlRequest {
            let originalTask = DataRequest.Requestable(urlRequest: urlRequest)
            requestTask = .data(originalTask, nil)
        }

        let underlyingError = error.underlyingAdaptError ?? error
        let request = DataRequest(session: session, requestTask: requestTask, error: underlyingError)

        if let retrier = retrier, error is AdaptError {
            allowRetrier(retrier, toRetry: request, with: underlyingError)
        } else {
            if startRequestsImmediately { request.resume() }
        }

        return request
    }

    ***REMOVED*** MARK: - Download Request

    ***REMOVED*** MARK: URL Request

    ***REMOVED***/ Creates a `DownloadRequest` to retrieve the contents the specified `url`, `method`, `parameters`, `encoding`,
    ***REMOVED***/ `headers` and save them to the `destination`.
    ***REMOVED***/
    ***REMOVED***/ If `destination` is not specified, the contents will remain in the temporary location determined by the
    ***REMOVED***/ underlying URL session.
    ***REMOVED***/
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
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
    open func download(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        to destination: DownloadRequest.DownloadFileDestination? = nil)
        -> DownloadRequest
    {
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return download(encodedURLRequest, to: destination)
        } catch {
            return download(nil, to: destination, failedWith: error)
        }
    }

    ***REMOVED***/ Creates a `DownloadRequest` to retrieve the contents of a URL based on the specified `urlRequest` and save
    ***REMOVED***/ them to the `destination`.
    ***REMOVED***/
    ***REMOVED***/ If `destination` is not specified, the contents will remain in the temporary location determined by the
    ***REMOVED***/ underlying URL session.
    ***REMOVED***/
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ***REMOVED***/
    ***REMOVED***/ - parameter urlRequest:  The URL request
    ***REMOVED***/ - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ***REMOVED***/
    ***REMOVED***/ - returns: The created `DownloadRequest`.
    @discardableResult
    open func download(
        _ urlRequest: URLRequestConvertible,
        to destination: DownloadRequest.DownloadFileDestination? = nil)
        -> DownloadRequest
    {
        do {
            let urlRequest = try urlRequest.asURLRequest()
            return download(.request(urlRequest), to: destination)
        } catch {
            return download(nil, to: destination, failedWith: error)
        }
    }

    ***REMOVED*** MARK: Resume Data

    ***REMOVED***/ Creates a `DownloadRequest` from the `resumeData` produced from a previous request cancellation to retrieve
    ***REMOVED***/ the contents of the original request and save them to the `destination`.
    ***REMOVED***/
    ***REMOVED***/ If `destination` is not specified, the contents will remain in the temporary location determined by the
    ***REMOVED***/ underlying URL session.
    ***REMOVED***/
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ***REMOVED***/
    ***REMOVED***/ On the latest release of all the Apple platforms (iOS 10, macOS 10.12, tvOS 10, watchOS 3), `resumeData` is broken
    ***REMOVED***/ on background URL session configurations. There's an underlying bug in the `resumeData` generation logic where the
    ***REMOVED***/ data is written incorrectly and will always fail to resume the download. For more information about the bug and
    ***REMOVED***/ possible workarounds, please refer to the following Stack Overflow post:
    ***REMOVED***/
    ***REMOVED***/    - http:***REMOVED***stackoverflow.com/a/39347461/1342462
    ***REMOVED***/
    ***REMOVED***/ - parameter resumeData:  The resume data. This is an opaque data blob produced by `URLSessionDownloadTask`
    ***REMOVED***/                          when a task is cancelled. See `URLSession -downloadTask(withResumeData:)` for
    ***REMOVED***/                          additional information.
    ***REMOVED***/ - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ***REMOVED***/
    ***REMOVED***/ - returns: The created `DownloadRequest`.
    @discardableResult
    open func download(
        resumingWith resumeData: Data,
        to destination: DownloadRequest.DownloadFileDestination? = nil)
        -> DownloadRequest
    {
        return download(.resumeData(resumeData), to: destination)
    }

    ***REMOVED*** MARK: Private - Download Implementation

    private func download(
        _ downloadable: DownloadRequest.Downloadable,
        to destination: DownloadRequest.DownloadFileDestination?)
        -> DownloadRequest
    {
        do {
            let task = try downloadable.task(session: session, adapter: adapter, queue: queue)
            let download = DownloadRequest(session: session, requestTask: .download(downloadable, task))

            download.downloadDelegate.destination = destination

            delegate[task] = download

            if startRequestsImmediately { download.resume() }

            return download
        } catch {
            return download(downloadable, to: destination, failedWith: error)
        }
    }

    private func download(
        _ downloadable: DownloadRequest.Downloadable?,
        to destination: DownloadRequest.DownloadFileDestination?,
        failedWith error: Error)
        -> DownloadRequest
    {
        var downloadTask: Request.RequestTask = .download(nil, nil)

        if let downloadable = downloadable {
            downloadTask = .download(downloadable, nil)
        }

        let underlyingError = error.underlyingAdaptError ?? error

        let download = DownloadRequest(session: session, requestTask: downloadTask, error: underlyingError)
        download.downloadDelegate.destination = destination

        if let retrier = retrier, error is AdaptError {
            allowRetrier(retrier, toRetry: download, with: underlyingError)
        } else {
            if startRequestsImmediately { download.resume() }
        }

        return download
    }

    ***REMOVED*** MARK: - Upload Request

    ***REMOVED*** MARK: File

    ***REMOVED***/ Creates an `UploadRequest` from the specified `url`, `method` and `headers` for uploading the `file`.
    ***REMOVED***/
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ***REMOVED***/
    ***REMOVED***/ - parameter file:    The file to upload.
    ***REMOVED***/ - parameter url:     The URL.
    ***REMOVED***/ - parameter method:  The HTTP method. `.post` by default.
    ***REMOVED***/ - parameter headers: The HTTP headers. `nil` by default.
    ***REMOVED***/
    ***REMOVED***/ - returns: The created `UploadRequest`.
    /*
    @discardableResult
    open func upload(
        _ fileURL: URL,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil)
        -> UploadRequest
    {
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
            return upload(fileURL, with: urlRequest)
        } catch {
            return upload(nil, failedWith: error)
        }
    }
    */

    ***REMOVED***/ Creates a `UploadRequest` from the specified `urlRequest` for uploading the `file`.
    ***REMOVED***/
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ***REMOVED***/
    ***REMOVED***/ - parameter file:       The file to upload.
    ***REMOVED***/ - parameter urlRequest: The URL request.
    ***REMOVED***/
    ***REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***    @discardableResult
***REMOVED***    open func upload(_ fileURL: URL, with urlRequest: URLRequestConvertible) -> UploadRequest {
***REMOVED***        do {
***REMOVED***            let urlRequest = try urlRequest.asURLRequest()
***REMOVED***            return upload(.file(fileURL, urlRequest))
***REMOVED***        } catch {
***REMOVED***            return upload(nil, failedWith: error)
***REMOVED***        }
***REMOVED***    }
***REMOVED***
***REMOVED***    ***REMOVED*** MARK: Data
***REMOVED***
***REMOVED***    ***REMOVED***/ Creates an `UploadRequest` from the specified `url`, `method` and `headers` for uploading the `data`.
***REMOVED***    ***REMOVED***/
***REMOVED***    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
***REMOVED***    ***REMOVED***/
***REMOVED***    ***REMOVED***/ - parameter data:    The data to upload.
***REMOVED***    ***REMOVED***/ - parameter url:     The URL.
***REMOVED***    ***REMOVED***/ - parameter method:  The HTTP method. `.post` by default.
***REMOVED***    ***REMOVED***/ - parameter headers: The HTTP headers. `nil` by default.
***REMOVED***    ***REMOVED***/
***REMOVED***    ***REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***    @discardableResult
***REMOVED***    open func upload(
***REMOVED***        _ data: Data,
***REMOVED***        to url: URLConvertible,
***REMOVED***        method: HTTPMethod = .post,
***REMOVED***        headers: HTTPHeaders? = nil)
***REMOVED***        -> UploadRequest
***REMOVED***    {
***REMOVED***        do {
***REMOVED***            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
***REMOVED***            return upload(data, with: urlRequest)
***REMOVED***        } catch {
***REMOVED***            return upload(nil, failedWith: error)
***REMOVED***        }
***REMOVED***    }

    ***REMOVED***/ Creates an `UploadRequest` from the specified `urlRequest` for uploading the `data`.
    ***REMOVED***/
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ***REMOVED***/
    ***REMOVED***/ - parameter data:       The data to upload.
    ***REMOVED***/ - parameter urlRequest: The URL request.
    ***REMOVED***/
    ***REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***    @discardableResult
***REMOVED***    open func upload(_ data: Data, with urlRequest: URLRequestConvertible) -> UploadRequest {
***REMOVED***        do {
***REMOVED***            let urlRequest = try urlRequest.asURLRequest()
***REMOVED***            return upload(.data(data, urlRequest))
***REMOVED***        } catch {
***REMOVED***            return upload(nil, failedWith: error)
***REMOVED***        }
***REMOVED***    }
***REMOVED***
***REMOVED***    ***REMOVED*** MARK: InputStream
***REMOVED***
***REMOVED***    ***REMOVED***/ Creates an `UploadRequest` from the specified `url`, `method` and `headers` for uploading the `stream`.
***REMOVED***    ***REMOVED***/
***REMOVED***    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
***REMOVED***    ***REMOVED***/
***REMOVED***    ***REMOVED***/ - parameter stream:  The stream to upload.
***REMOVED***    ***REMOVED***/ - parameter url:     The URL.
***REMOVED***    ***REMOVED***/ - parameter method:  The HTTP method. `.post` by default.
***REMOVED***    ***REMOVED***/ - parameter headers: The HTTP headers. `nil` by default.
***REMOVED***    ***REMOVED***/
***REMOVED***    ***REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***    @discardableResult
***REMOVED***    open func upload(
***REMOVED***        _ stream: InputStream,
***REMOVED***        to url: URLConvertible,
***REMOVED***        method: HTTPMethod = .post,
***REMOVED***        headers: HTTPHeaders? = nil)
***REMOVED***        -> UploadRequest
***REMOVED***    {
***REMOVED***        do {
***REMOVED***            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
***REMOVED***            return upload(stream, with: urlRequest)
***REMOVED***        } catch {
***REMOVED***            return upload(nil, failedWith: error)
***REMOVED***        }
***REMOVED***    }
***REMOVED***
***REMOVED***    ***REMOVED***/ Creates an `UploadRequest` from the specified `urlRequest` for uploading the `stream`.
***REMOVED***    ***REMOVED***/
***REMOVED***    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
***REMOVED***    ***REMOVED***/
***REMOVED***    ***REMOVED***/ - parameter stream:     The stream to upload.
***REMOVED***    ***REMOVED***/ - parameter urlRequest: The URL request.
***REMOVED***    ***REMOVED***/
***REMOVED***    ***REMOVED***/ - returns: The created `UploadRequest`.
***REMOVED***    @discardableResult
***REMOVED***    open func upload(_ stream: InputStream, with urlRequest: URLRequestConvertible) -> UploadRequest {
***REMOVED***        do {
***REMOVED***            let urlRequest = try urlRequest.asURLRequest()
***REMOVED***            return upload(.stream(stream, urlRequest))
***REMOVED***        } catch {
***REMOVED***            return upload(nil, failedWith: error)
***REMOVED***        }
***REMOVED***    }

    ***REMOVED*** MARK: MultipartFormData

    ***REMOVED***/ Encodes `multipartFormData` using `encodingMemoryThreshold` and calls `encodingCompletion` with new
    ***REMOVED***/ `UploadRequest` using the `url`, `method` and `headers`.
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
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ***REMOVED***/
    ***REMOVED***/ - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
    ***REMOVED***/ - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
    ***REMOVED***/                                      `multipartFormDataEncodingMemoryThreshold` by default.
    ***REMOVED***/ - parameter url:                     The URL.
    ***REMOVED***/ - parameter method:                  The HTTP method. `.post` by default.
    ***REMOVED***/ - parameter headers:                 The HTTP headers. `nil` by default.
    ***REMOVED***/ - parameter encodingCompletion:      The closure called when the `MultipartFormData` encoding is complete.
***REMOVED***    open func upload(
***REMOVED***        multipartFormData: @escaping (MultipartFormData) -> Void,
***REMOVED***        usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
***REMOVED***        to url: URLConvertible,
***REMOVED***        method: HTTPMethod = .post,
***REMOVED***        headers: HTTPHeaders? = nil,
***REMOVED***        queue: DispatchQueue? = nil,
***REMOVED***        encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)?)
***REMOVED***    {
***REMOVED***        do {
***REMOVED***            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
***REMOVED***
***REMOVED***            return upload(
***REMOVED***                multipartFormData: multipartFormData,
***REMOVED***                usingThreshold: encodingMemoryThreshold,
***REMOVED***                with: urlRequest,
***REMOVED***                queue: queue,
***REMOVED***                encodingCompletion: encodingCompletion
***REMOVED***            )
***REMOVED***        } catch {
***REMOVED***            (queue ?? DispatchQueue.main).async { encodingCompletion?(.failure(error)) }
***REMOVED***        }
***REMOVED***    }

    ***REMOVED***/ Encodes `multipartFormData` using `encodingMemoryThreshold` and calls `encodingCompletion` with new
    ***REMOVED***/ `UploadRequest` using the `urlRequest`.
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
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ***REMOVED***/
    ***REMOVED***/ - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
    ***REMOVED***/ - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
    ***REMOVED***/                                      `multipartFormDataEncodingMemoryThreshold` by default.
    ***REMOVED***/ - parameter urlRequest:              The URL request.
    ***REMOVED***/ - parameter encodingCompletion:      The closure called when the `MultipartFormData` encoding is complete.
    
    
    
***REMOVED***    open func upload(
***REMOVED***        multipartFormData: @escaping (MultipartFormData) -> Void,
***REMOVED***        usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
***REMOVED***        with urlRequest: URLRequestConvertible,
***REMOVED***        queue: DispatchQueue? = nil,
***REMOVED***        encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)?)
***REMOVED***    {
***REMOVED***        DispatchQueue.global(qos: .utility).async {
***REMOVED***            let formData = MultipartFormData()
***REMOVED***            multipartFormData(formData)
***REMOVED***
***REMOVED***            var tempFileURL: URL?
***REMOVED***
***REMOVED***            do {
***REMOVED***                var urlRequestWithContentType = try urlRequest.asURLRequest()
***REMOVED***                urlRequestWithContentType.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
***REMOVED***
***REMOVED***                let isBackgroundSession = self.session.configuration.identifier != nil
***REMOVED***
***REMOVED***                if formData.contentLength < encodingMemoryThreshold && !isBackgroundSession {
***REMOVED***                    let data = try formData.encode()
***REMOVED***
***REMOVED***                    let encodingResult = MultipartFormDataEncodingResult.success(
***REMOVED***                        request: self.upload(data, with: urlRequestWithContentType),
***REMOVED***                        streamingFromDisk: false,
***REMOVED***                        streamFileURL: nil
***REMOVED***                    )
***REMOVED***
***REMOVED***                    (queue ?? DispatchQueue.main).async { encodingCompletion?(encodingResult) }
***REMOVED***                } else {
***REMOVED***                    let fileManager = FileManager.default
***REMOVED***                    let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
***REMOVED***                    let directoryURL = tempDirectoryURL.appendingPathComponent("org.alamofire.manager/multipart.form.data")
***REMOVED***                    let fileName = UUID().uuidString
***REMOVED***                    let fileURL = directoryURL.appendingPathComponent(fileName)
***REMOVED***
***REMOVED***                    tempFileURL = fileURL
***REMOVED***
***REMOVED***                    var directoryError: Error?
***REMOVED***
***REMOVED***                    ***REMOVED*** Create directory inside serial queue to ensure two threads don't do this in parallel
***REMOVED***                    self.queue.sync {
***REMOVED***                        do {
***REMOVED***                            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
***REMOVED***                        } catch {
***REMOVED***                            directoryError = error
***REMOVED***                        }
***REMOVED***                    }
***REMOVED***
***REMOVED***                    if let directoryError = directoryError { throw directoryError }
***REMOVED***
***REMOVED***                    try formData.writeEncodedData(to: fileURL)
***REMOVED***
***REMOVED***                    let upload = self.upload(fileURL, with: urlRequestWithContentType)
***REMOVED***
***REMOVED***                    ***REMOVED*** Cleanup the temp file once the upload is complete
***REMOVED***                    upload.delegate.queue.addOperation {
***REMOVED***                        do {
***REMOVED***                            try FileManager.default.removeItem(at: fileURL)
***REMOVED***                        } catch {
***REMOVED***                            ***REMOVED*** No-op
***REMOVED***                        }
***REMOVED***                    }
***REMOVED***
***REMOVED***                    (queue ?? DispatchQueue.main).async {
***REMOVED***                        let encodingResult = MultipartFormDataEncodingResult.success(
***REMOVED***                            request: upload,
***REMOVED***                            streamingFromDisk: true,
***REMOVED***                            streamFileURL: fileURL
***REMOVED***                        )
***REMOVED***
***REMOVED***                        encodingCompletion?(encodingResult)
***REMOVED***                    }
***REMOVED***                }
***REMOVED***            } catch {
***REMOVED***                ***REMOVED*** Cleanup the temp file in the event that the multipart form data encoding failed
***REMOVED***                if let tempFileURL = tempFileURL {
***REMOVED***                    do {
***REMOVED***                        try FileManager.default.removeItem(at: tempFileURL)
***REMOVED***                    } catch {
***REMOVED***                        ***REMOVED*** No-op
***REMOVED***                    }
***REMOVED***                }
***REMOVED***
***REMOVED***                (queue ?? DispatchQueue.main).async { encodingCompletion?(.failure(error)) }
***REMOVED***            }
***REMOVED***        }
***REMOVED***    }

    ***REMOVED*** MARK: Private - Upload Implementation

***REMOVED***    private func upload(_ uploadable: UploadRequest.Uploadable) -> UploadRequest {
***REMOVED***        do {
***REMOVED***            let task = try uploadable.task(session: session, adapter: adapter, queue: queue)
***REMOVED***            let upload = UploadRequest(session: session, requestTask: .upload(uploadable, task))
***REMOVED***
***REMOVED***            if case let .stream(inputStream, _) = uploadable {
***REMOVED***                upload.delegate.taskNeedNewBodyStream = { _, _ in inputStream }
***REMOVED***            }
***REMOVED***
***REMOVED***            delegate[task] = upload
***REMOVED***
***REMOVED***            if startRequestsImmediately { upload.resume() }
***REMOVED***
***REMOVED***            return upload
***REMOVED***        } catch {
***REMOVED***            return upload(uploadable, failedWith: error)
***REMOVED***        }
***REMOVED***    }

***REMOVED***    private func upload(_ uploadable: UploadRequest.Uploadable?, failedWith error: Error) -> UploadRequest {
***REMOVED***        var uploadTask: Request.RequestTask = .upload(nil, nil)
***REMOVED***
***REMOVED***        if let uploadable = uploadable {
***REMOVED***            uploadTask = .upload(uploadable, nil)
***REMOVED***        }
***REMOVED***
***REMOVED***        let underlyingError = error.underlyingAdaptError ?? error
***REMOVED***        let upload = UploadRequest(session: session, requestTask: uploadTask, error: underlyingError)
***REMOVED***
***REMOVED***        if let retrier = retrier, error is AdaptError {
***REMOVED***            allowRetrier(retrier, toRetry: upload, with: underlyingError)
***REMOVED***        } else {
***REMOVED***            if startRequestsImmediately { upload.resume() }
***REMOVED***        }
***REMOVED***
***REMOVED***        return upload
***REMOVED***    }

#if !os(watchOS)

    ***REMOVED*** MARK: - Stream Request

    ***REMOVED*** MARK: Hostname and Port

    ***REMOVED***/ Creates a `StreamRequest` for bidirectional streaming using the `hostname` and `port`.
    ***REMOVED***/
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ***REMOVED***/
    ***REMOVED***/ - parameter hostName: The hostname of the server to connect to.
    ***REMOVED***/ - parameter port:     The port of the server to connect to.
    ***REMOVED***/
    ***REMOVED***/ - returns: The created `StreamRequest`.
    @discardableResult
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open func stream(withHostName hostName: String, port: Int) -> StreamRequest {
        return stream(.stream(hostName: hostName, port: port))
    }

    ***REMOVED*** MARK: NetService

    ***REMOVED***/ Creates a `StreamRequest` for bidirectional streaming using the `netService`.
    ***REMOVED***/
    ***REMOVED***/ If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ***REMOVED***/
    ***REMOVED***/ - parameter netService: The net service used to identify the endpoint.
    ***REMOVED***/
    ***REMOVED***/ - returns: The created `StreamRequest`.
    @discardableResult
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open func stream(with netService: NetService) -> StreamRequest {
        return stream(.netService(netService))
    }

    ***REMOVED*** MARK: Private - Stream Implementation

    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    private func stream(_ streamable: StreamRequest.Streamable) -> StreamRequest {
        do {
            let task = try streamable.task(session: session, adapter: adapter, queue: queue)
            let request = StreamRequest(session: session, requestTask: .stream(streamable, task))

            delegate[task] = request

            if startRequestsImmediately { request.resume() }

            return request
        } catch {
            return stream(failedWith: error)
        }
    }

    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    private func stream(failedWith error: Error) -> StreamRequest {
        let stream = StreamRequest(session: session, requestTask: .stream(nil, nil), error: error)
        if startRequestsImmediately { stream.resume() }
        return stream
    }

#endif

    ***REMOVED*** MARK: - Internal - Retry Request

    func retry(_ request: Request) -> Bool {
        guard let originalTask = request.originalTask else { return false }

        do {
            let task = try originalTask.task(session: session, adapter: adapter, queue: queue)

            if let originalTask = request.task {
                delegate[originalTask] = nil ***REMOVED*** removes the old request to avoid endless growth
            }

            request.delegate.task = task ***REMOVED*** resets all task delegate data

            request.retryCount += 1
            request.startTime = CFAbsoluteTimeGetCurrent()
            request.endTime = nil

            task.resume()

            return true
        } catch {
            request.delegate.error = error.underlyingAdaptError ?? error
            return false
        }
    }

    private func allowRetrier(_ retrier: RequestRetrier, toRetry request: Request, with error: Error) {
        DispatchQueue.utility.async { [weak self] in
            guard let strongSelf = self else { return }

            retrier.should(strongSelf, retry: request, with: error) { shouldRetry, timeDelay in
                guard let strongSelf = self else { return }

                guard shouldRetry else {
                    if strongSelf.startRequestsImmediately { request.resume() }
                    return
                }

                DispatchQueue.utility.after(timeDelay) {
                    guard let strongSelf = self else { return }

                    let retrySucceeded = strongSelf.retry(request)

                    if retrySucceeded, let task = request.task {
                        strongSelf.delegate[task] = request
                    } else {
                        if strongSelf.startRequestsImmediately { request.resume() }
                    }
                }
            }
        }
    }
}
