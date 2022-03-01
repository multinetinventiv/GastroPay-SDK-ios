***REMOVED***
***REMOVED***  SessionDelegate.swift
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

***REMOVED***/ Responsible for handling all delegate callbacks for the underlying session.
open class SessionDelegate: NSObject {

    ***REMOVED*** MARK: URLSessionDelegate Overrides

    ***REMOVED***/ Overrides default behavior for URLSessionDelegate method `urlSession(_:didBecomeInvalidWithError:)`.
    open var sessionDidBecomeInvalidWithError: ((URLSession, Error?) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionDelegate method `urlSession(_:didReceive:completionHandler:)`.
    open var sessionDidReceiveChallenge: ((URLSession, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?

    ***REMOVED***/ Overrides all behavior for URLSessionDelegate method `urlSession(_:didReceive:completionHandler:)` and requires the caller to call the `completionHandler`.
    open var sessionDidReceiveChallengeWithCompletion: ((URLSession, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionDelegate method `urlSessionDidFinishEvents(forBackgroundURLSession:)`.
    open var sessionDidFinishEventsForBackgroundURLSession: ((URLSession) -> Void)?

    ***REMOVED*** MARK: URLSessionTaskDelegate Overrides

    ***REMOVED***/ Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)`.
    open var taskWillPerformHTTPRedirection: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest) -> URLRequest?)?

    ***REMOVED***/ Overrides all behavior for URLSessionTaskDelegate method `urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)` and
    ***REMOVED***/ requires the caller to call the `completionHandler`.
    open var taskWillPerformHTTPRedirectionWithCompletion: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest, @escaping (URLRequest?) -> Void) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didReceive:completionHandler:)`.
    open var taskDidReceiveChallenge: ((URLSession, URLSessionTask, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?

    ***REMOVED***/ Overrides all behavior for URLSessionTaskDelegate method `urlSession(_:task:didReceive:completionHandler:)` and
    ***REMOVED***/ requires the caller to call the `completionHandler`.
    open var taskDidReceiveChallengeWithCompletion: ((URLSession, URLSessionTask, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:needNewBodyStream:)`.
    open var taskNeedNewBodyStream: ((URLSession, URLSessionTask) -> InputStream?)?

    ***REMOVED***/ Overrides all behavior for URLSessionTaskDelegate method `urlSession(_:task:needNewBodyStream:)` and
    ***REMOVED***/ requires the caller to call the `completionHandler`.
    open var taskNeedNewBodyStreamWithCompletion: ((URLSession, URLSessionTask, @escaping (InputStream?) -> Void) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)`.
    open var taskDidSendBodyData: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didCompleteWithError:)`.
    open var taskDidComplete: ((URLSession, URLSessionTask, Error?) -> Void)?

    ***REMOVED*** MARK: URLSessionDataDelegate Overrides

    ***REMOVED***/ Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:completionHandler:)`.
    open var dataTaskDidReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?

    ***REMOVED***/ Overrides all behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:completionHandler:)` and
    ***REMOVED***/ requires caller to call the `completionHandler`.
    open var dataTaskDidReceiveResponseWithCompletion: ((URLSession, URLSessionDataTask, URLResponse, @escaping (URLSession.ResponseDisposition) -> Void) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didBecome:)`.
    open var dataTaskDidBecomeDownloadTask: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:)`.
    open var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:willCacheResponse:completionHandler:)`.
    open var dataTaskWillCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse?)?

    ***REMOVED***/ Overrides all behavior for URLSessionDataDelegate method `urlSession(_:dataTask:willCacheResponse:completionHandler:)` and
    ***REMOVED***/ requires caller to call the `completionHandler`.
    open var dataTaskWillCacheResponseWithCompletion: ((URLSession, URLSessionDataTask, CachedURLResponse, @escaping (CachedURLResponse?) -> Void) -> Void)?

    ***REMOVED*** MARK: URLSessionDownloadDelegate Overrides

    ***REMOVED***/ Overrides default behavior for URLSessionDownloadDelegate method `urlSession(_:downloadTask:didFinishDownloadingTo:)`.
    open var downloadTaskDidFinishDownloadingToURL: ((URLSession, URLSessionDownloadTask, URL) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionDownloadDelegate method `urlSession(_:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)`.
    open var downloadTaskDidWriteData: ((URLSession, URLSessionDownloadTask, Int64, Int64, Int64) -> Void)?

    ***REMOVED***/ Overrides default behavior for URLSessionDownloadDelegate method `urlSession(_:downloadTask:didResumeAtOffset:expectedTotalBytes:)`.
    open var downloadTaskDidResumeAtOffset: ((URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?

    ***REMOVED*** MARK: URLSessionStreamDelegate Overrides

#if !os(watchOS)

    ***REMOVED***/ Overrides default behavior for URLSessionStreamDelegate method `urlSession(_:readClosedFor:)`.
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskReadClosed: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskReadClosed as? (URLSession, URLSessionStreamTask) -> Void
        }
        set {
            _streamTaskReadClosed = newValue
        }
    }

    ***REMOVED***/ Overrides default behavior for URLSessionStreamDelegate method `urlSession(_:writeClosedFor:)`.
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskWriteClosed: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskWriteClosed as? (URLSession, URLSessionStreamTask) -> Void
        }
        set {
            _streamTaskWriteClosed = newValue
        }
    }

    ***REMOVED***/ Overrides default behavior for URLSessionStreamDelegate method `urlSession(_:betterRouteDiscoveredFor:)`.
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskBetterRouteDiscovered: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskBetterRouteDiscovered as? (URLSession, URLSessionStreamTask) -> Void
        }
        set {
            _streamTaskBetterRouteDiscovered = newValue
        }
    }

    ***REMOVED***/ Overrides default behavior for URLSessionStreamDelegate method `urlSession(_:streamTask:didBecome:outputStream:)`.
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskDidBecomeInputAndOutputStreams: ((URLSession, URLSessionStreamTask, InputStream, OutputStream) -> Void)? {
        get {
            return _streamTaskDidBecomeInputStream as? (URLSession, URLSessionStreamTask, InputStream, OutputStream) -> Void
        }
        set {
            _streamTaskDidBecomeInputStream = newValue
        }
    }

    var _streamTaskReadClosed: Any?
    var _streamTaskWriteClosed: Any?
    var _streamTaskBetterRouteDiscovered: Any?
    var _streamTaskDidBecomeInputStream: Any?

#endif

    ***REMOVED*** MARK: Properties

    var retrier: RequestRetrier?
    weak var sessionManager: SessionManager?

    var requests: [Int: Request] = [:]
    private let lock = NSLock()

    ***REMOVED***/ Access the task delegate for the specified task in a thread-safe manner.
    open subscript(task: URLSessionTask) -> Request? {
        get {
            lock.lock() ; defer { lock.unlock() }
            return requests[task.taskIdentifier]
        }
        set {
            lock.lock() ; defer { lock.unlock() }
            requests[task.taskIdentifier] = newValue
        }
    }

    ***REMOVED*** MARK: Lifecycle

    ***REMOVED***/ Initializes the `SessionDelegate` instance.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `SessionDelegate` instance.
    public override init() {
        super.init()
    }

    ***REMOVED*** MARK: NSObject Overrides

    ***REMOVED***/ Returns a `Bool` indicating whether the `SessionDelegate` implements or inherits a method that can respond
    ***REMOVED***/ to a specified message.
    ***REMOVED***/
    ***REMOVED***/ - parameter selector: A selector that identifies a message.
    ***REMOVED***/
    ***REMOVED***/ - returns: `true` if the receiver implements or inherits a method that can respond to selector, otherwise `false`.
    open override func responds(to selector: Selector) -> Bool {
        #if !os(macOS)
            if selector == #selector(URLSessionDelegate.urlSessionDidFinishEvents(forBackgroundURLSession:)) {
                return sessionDidFinishEventsForBackgroundURLSession != nil
            }
        #endif

        #if !os(watchOS)
            if #available(iOS 9.0, macOS 10.11, tvOS 9.0, *) {
                switch selector {
                case #selector(URLSessionStreamDelegate.urlSession(_:readClosedFor:)):
                    return streamTaskReadClosed != nil
                case #selector(URLSessionStreamDelegate.urlSession(_:writeClosedFor:)):
                    return streamTaskWriteClosed != nil
                case #selector(URLSessionStreamDelegate.urlSession(_:betterRouteDiscoveredFor:)):
                    return streamTaskBetterRouteDiscovered != nil
                case #selector(URLSessionStreamDelegate.urlSession(_:streamTask:didBecome:outputStream:)):
                    return streamTaskDidBecomeInputAndOutputStreams != nil
                default:
                    break
                }
            }
        #endif

        switch selector {
        case #selector(URLSessionDelegate.urlSession(_:didBecomeInvalidWithError:)):
            return sessionDidBecomeInvalidWithError != nil
        case #selector(URLSessionDelegate.urlSession(_:didReceive:completionHandler:)):
            return (sessionDidReceiveChallenge != nil  || sessionDidReceiveChallengeWithCompletion != nil)
        case #selector(URLSessionTaskDelegate.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)):
            return (taskWillPerformHTTPRedirection != nil || taskWillPerformHTTPRedirectionWithCompletion != nil)
        case #selector(URLSessionDataDelegate.urlSession(_:dataTask:didReceive:completionHandler:)):
            return (dataTaskDidReceiveResponse != nil || dataTaskDidReceiveResponseWithCompletion != nil)
        default:
            return type(of: self).instancesRespond(to: selector)
        }
    }
}

***REMOVED*** MARK: - URLSessionDelegate

extension SessionDelegate: URLSessionDelegate {
    ***REMOVED***/ Tells the delegate that the session has been invalidated.
    ***REMOVED***/
    ***REMOVED***/ - parameter session: The session object that was invalidated.
    ***REMOVED***/ - parameter error:   The error that caused invalidation, or nil if the invalidation was explicit.
    open func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        sessionDidBecomeInvalidWithError?(session, error)
    }

    ***REMOVED***/ Requests credentials from the delegate in response to a session-level authentication request from the
    ***REMOVED***/ remote server.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:           The session containing the task that requested authentication.
    ***REMOVED***/ - parameter challenge:         An object that contains the request for authentication.
    ***REMOVED***/ - parameter completionHandler: A handler that your delegate method must call providing the disposition
    ***REMOVED***/                                and credential.
    open func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard sessionDidReceiveChallengeWithCompletion == nil else {
            sessionDidReceiveChallengeWithCompletion?(session, challenge, completionHandler)
            return
        }

        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?

        if let sessionDidReceiveChallenge = sessionDidReceiveChallenge {
            (disposition, credential) = sessionDidReceiveChallenge(session, challenge)
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let host = challenge.protectionSpace.host

            if
                let serverTrustPolicy = session.serverTrustPolicyManager?.serverTrustPolicy(forHost: host),
                let serverTrust = challenge.protectionSpace.serverTrust
            {
                if serverTrustPolicy.evaluate(serverTrust, forHost: host) {
                    disposition = .useCredential
                    credential = URLCredential(trust: serverTrust)
                } else {
                    disposition = .cancelAuthenticationChallenge
                }
            }
        }

        completionHandler(disposition, credential)
    }

#if !os(macOS)

    ***REMOVED***/ Tells the delegate that all messages enqueued for a session have been delivered.
    ***REMOVED***/
    ***REMOVED***/ - parameter session: The session that no longer has any outstanding requests.
    open func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        sessionDidFinishEventsForBackgroundURLSession?(session)
    }

#endif
}

***REMOVED*** MARK: - URLSessionTaskDelegate

extension SessionDelegate: URLSessionTaskDelegate {
    ***REMOVED***/ Tells the delegate that the remote server requested an HTTP redirect.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:           The session containing the task whose request resulted in a redirect.
    ***REMOVED***/ - parameter task:              The task whose request resulted in a redirect.
    ***REMOVED***/ - parameter response:          An object containing the server’s response to the original request.
    ***REMOVED***/ - parameter request:           A URL request object filled out with the new location.
    ***REMOVED***/ - parameter completionHandler: A closure that your handler should call with either the value of the request
    ***REMOVED***/                                parameter, a modified URL request object, or NULL to refuse the redirect and
    ***REMOVED***/                                return the body of the redirect response.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
    {
        guard taskWillPerformHTTPRedirectionWithCompletion == nil else {
            taskWillPerformHTTPRedirectionWithCompletion?(session, task, response, request, completionHandler)
            return
        }

        var redirectRequest: URLRequest? = request

        if let taskWillPerformHTTPRedirection = taskWillPerformHTTPRedirection {
            redirectRequest = taskWillPerformHTTPRedirection(session, task, response, request)
        }

        completionHandler(redirectRequest)
    }

    ***REMOVED***/ Requests credentials from the delegate in response to an authentication request from the remote server.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:           The session containing the task whose request requires authentication.
    ***REMOVED***/ - parameter task:              The task whose request requires authentication.
    ***REMOVED***/ - parameter challenge:         An object that contains the request for authentication.
    ***REMOVED***/ - parameter completionHandler: A handler that your delegate method must call providing the disposition
    ***REMOVED***/                                and credential.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard taskDidReceiveChallengeWithCompletion == nil else {
            taskDidReceiveChallengeWithCompletion?(session, task, challenge, completionHandler)
            return
        }

        if let taskDidReceiveChallenge = taskDidReceiveChallenge {
            let result = taskDidReceiveChallenge(session, task, challenge)
            completionHandler(result.0, result.1)
        } else if let delegate = self[task]?.delegate {
            delegate.urlSession(
                session,
                task: task,
                didReceive: challenge,
                completionHandler: completionHandler
            )
        } else {
            urlSession(session, didReceive: challenge, completionHandler: completionHandler)
        }
    }

    ***REMOVED***/ Tells the delegate when a task requires a new request body stream to send to the remote server.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:           The session containing the task that needs a new body stream.
    ***REMOVED***/ - parameter task:              The task that needs a new body stream.
    ***REMOVED***/ - parameter completionHandler: A completion handler that your delegate method should call with the new body stream.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        needNewBodyStream completionHandler: @escaping (InputStream?) -> Void)
    {
        guard taskNeedNewBodyStreamWithCompletion == nil else {
            taskNeedNewBodyStreamWithCompletion?(session, task, completionHandler)
            return
        }

        if let taskNeedNewBodyStream = taskNeedNewBodyStream {
            completionHandler(taskNeedNewBodyStream(session, task))
        } else if let delegate = self[task]?.delegate {
            delegate.urlSession(session, task: task, needNewBodyStream: completionHandler)
        }
    }

    ***REMOVED***/ Periodically informs the delegate of the progress of sending body content to the server.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:                  The session containing the data task.
    ***REMOVED***/ - parameter task:                     The data task.
    ***REMOVED***/ - parameter bytesSent:                The number of bytes sent since the last time this delegate method was called.
    ***REMOVED***/ - parameter totalBytesSent:           The total number of bytes sent so far.
    ***REMOVED***/ - parameter totalBytesExpectedToSend: The expected length of the body data.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64)
    {
        if let taskDidSendBodyData = taskDidSendBodyData {
            taskDidSendBodyData(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
        } else if let delegate = self[task]?.delegate as? UploadTaskDelegate {
            delegate.URLSession(
                session,
                task: task,
                didSendBodyData: bytesSent,
                totalBytesSent: totalBytesSent,
                totalBytesExpectedToSend: totalBytesExpectedToSend
            )
        }
    }

#if !os(watchOS)

    ***REMOVED***/ Tells the delegate that the session finished collecting metrics for the task.
    ***REMOVED***/
    ***REMOVED***/ - parameter session: The session collecting the metrics.
    ***REMOVED***/ - parameter task:    The task whose metrics have been collected.
    ***REMOVED***/ - parameter metrics: The collected metrics.
    @available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
    @objc(URLSession:task:didFinishCollectingMetrics:)
    open func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        self[task]?.delegate.metrics = metrics
    }

#endif

    ***REMOVED***/ Tells the delegate that the task finished transferring data.
    ***REMOVED***/
    ***REMOVED***/ - parameter session: The session containing the task whose request finished transferring data.
    ***REMOVED***/ - parameter task:    The task whose request finished transferring data.
    ***REMOVED***/ - parameter error:   If an error occurred, an error object indicating how the transfer failed, otherwise nil.
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        ***REMOVED***/ Executed after it is determined that the request is not going to be retried
        let completeTask: (URLSession, URLSessionTask, Error?) -> Void = { [weak self] session, task, error in
            guard let strongSelf = self else { return }

            strongSelf.taskDidComplete?(session, task, error)

            strongSelf[task]?.delegate.urlSession(session, task: task, didCompleteWithError: error)

            var userInfo: [String: Any] = [Notification.Key.Task: task]

            if let data = (strongSelf[task]?.delegate as? DataTaskDelegate)?.data {
                userInfo[Notification.Key.ResponseData] = data
            }

            NotificationCenter.default.post(
                name: Notification.Name.Task.DidComplete,
                object: strongSelf,
                userInfo: userInfo
            )

            strongSelf[task] = nil
        }

        guard let request = self[task], let sessionManager = sessionManager else {
            completeTask(session, task, error)
            return
        }

        ***REMOVED*** Run all validations on the request before checking if an error occurred
        request.validations.forEach { $0() }

        ***REMOVED*** Determine whether an error has occurred
        var error: Error? = error

        if request.delegate.error != nil {
            error = request.delegate.error
        }

        ***REMOVED***/ If an error occurred and the retrier is set, asynchronously ask the retrier if the request
        ***REMOVED***/ should be retried. Otherwise, complete the task by notifying the task delegate.
        if let retrier = retrier, let error = error {
            retrier.should(sessionManager, retry: request, with: error) { [weak self] shouldRetry, timeDelay in
                guard shouldRetry else { completeTask(session, task, error) ; return }

                DispatchQueue.utility.after(timeDelay) { [weak self] in
                    guard let strongSelf = self else { return }

                    let retrySucceeded = strongSelf.sessionManager?.retry(request) ?? false

                    if retrySucceeded, let task = request.task {
                        strongSelf[task] = request
                        return
                    } else {
                        completeTask(session, task, error)
                    }
                }
            }
        } else {
            completeTask(session, task, error)
        }
    }
}

***REMOVED*** MARK: - URLSessionDataDelegate

extension SessionDelegate: URLSessionDataDelegate {
    ***REMOVED***/ Tells the delegate that the data task received the initial reply (headers) from the server.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:           The session containing the data task that received an initial reply.
    ***REMOVED***/ - parameter dataTask:          The data task that received an initial reply.
    ***REMOVED***/ - parameter response:          A URL response object populated with headers.
    ***REMOVED***/ - parameter completionHandler: A completion handler that your code calls to continue the transfer, passing a
    ***REMOVED***/                                constant to indicate whether the transfer should continue as a data task or
    ***REMOVED***/                                should become a download task.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        guard dataTaskDidReceiveResponseWithCompletion == nil else {
            dataTaskDidReceiveResponseWithCompletion?(session, dataTask, response, completionHandler)
            return
        }

        var disposition: URLSession.ResponseDisposition = .allow

        if let dataTaskDidReceiveResponse = dataTaskDidReceiveResponse {
            disposition = dataTaskDidReceiveResponse(session, dataTask, response)
        }

        completionHandler(disposition)
    }

    ***REMOVED***/ Tells the delegate that the data task was changed to a download task.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:      The session containing the task that was replaced by a download task.
    ***REMOVED***/ - parameter dataTask:     The data task that was replaced by a download task.
    ***REMOVED***/ - parameter downloadTask: The new download task that replaced the data task.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask)
    {
        if let dataTaskDidBecomeDownloadTask = dataTaskDidBecomeDownloadTask {
            dataTaskDidBecomeDownloadTask(session, dataTask, downloadTask)
        } else {
            self[downloadTask]?.delegate = DownloadTaskDelegate(task: downloadTask)
        }
    }

    ***REMOVED***/ Tells the delegate that the data task has received some of the expected data.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:  The session containing the data task that provided data.
    ***REMOVED***/ - parameter dataTask: The data task that provided data.
    ***REMOVED***/ - parameter data:     A data object containing the transferred data.
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let dataTaskDidReceiveData = dataTaskDidReceiveData {
            dataTaskDidReceiveData(session, dataTask, data)
        } else if let delegate = self[dataTask]?.delegate as? DataTaskDelegate {
            delegate.urlSession(session, dataTask: dataTask, didReceive: data)
        }
    }

    ***REMOVED***/ Asks the delegate whether the data (or upload) task should store the response in the cache.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:           The session containing the data (or upload) task.
    ***REMOVED***/ - parameter dataTask:          The data (or upload) task.
    ***REMOVED***/ - parameter proposedResponse:  The default caching behavior. This behavior is determined based on the current
    ***REMOVED***/                                caching policy and the values of certain received headers, such as the Pragma
    ***REMOVED***/                                and Cache-Control headers.
    ***REMOVED***/ - parameter completionHandler: A block that your handler must call, providing either the original proposed
    ***REMOVED***/                                response, a modified version of that response, or NULL to prevent caching the
    ***REMOVED***/                                response. If your delegate implements this method, it must call this completion
    ***REMOVED***/                                handler; otherwise, your app leaks memory.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        guard dataTaskWillCacheResponseWithCompletion == nil else {
            dataTaskWillCacheResponseWithCompletion?(session, dataTask, proposedResponse, completionHandler)
            return
        }

        if let dataTaskWillCacheResponse = dataTaskWillCacheResponse {
            completionHandler(dataTaskWillCacheResponse(session, dataTask, proposedResponse))
        } else if let delegate = self[dataTask]?.delegate as? DataTaskDelegate {
            delegate.urlSession(
                session,
                dataTask: dataTask,
                willCacheResponse: proposedResponse,
                completionHandler: completionHandler
            )
        } else {
            completionHandler(proposedResponse)
        }
    }
}

***REMOVED*** MARK: - URLSessionDownloadDelegate

extension SessionDelegate: URLSessionDownloadDelegate {
    ***REMOVED***/ Tells the delegate that a download task has finished downloading.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:      The session containing the download task that finished.
    ***REMOVED***/ - parameter downloadTask: The download task that finished.
    ***REMOVED***/ - parameter location:     A file URL for the temporary file. Because the file is temporary, you must either
    ***REMOVED***/                           open the file for reading or move it to a permanent location in your app’s sandbox
    ***REMOVED***/                           container directory before returning from this delegate method.
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL)
    {
        if let downloadTaskDidFinishDownloadingToURL = downloadTaskDidFinishDownloadingToURL {
            downloadTaskDidFinishDownloadingToURL(session, downloadTask, location)
        } else if let delegate = self[downloadTask]?.delegate as? DownloadTaskDelegate {
            delegate.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
        }
    }

    ***REMOVED***/ Periodically informs the delegate about the download’s progress.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:                   The session containing the download task.
    ***REMOVED***/ - parameter downloadTask:              The download task.
    ***REMOVED***/ - parameter bytesWritten:              The number of bytes transferred since the last time this delegate
    ***REMOVED***/                                        method was called.
    ***REMOVED***/ - parameter totalBytesWritten:         The total number of bytes transferred so far.
    ***REMOVED***/ - parameter totalBytesExpectedToWrite: The expected length of the file, as provided by the Content-Length
    ***REMOVED***/                                        header. If this header was not provided, the value is
    ***REMOVED***/                                        `NSURLSessionTransferSizeUnknown`.
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64)
    {
        if let downloadTaskDidWriteData = downloadTaskDidWriteData {
            downloadTaskDidWriteData(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
        } else if let delegate = self[downloadTask]?.delegate as? DownloadTaskDelegate {
            delegate.urlSession(
                session,
                downloadTask: downloadTask,
                didWriteData: bytesWritten,
                totalBytesWritten: totalBytesWritten,
                totalBytesExpectedToWrite: totalBytesExpectedToWrite
            )
        }
    }

    ***REMOVED***/ Tells the delegate that the download task has resumed downloading.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:            The session containing the download task that finished.
    ***REMOVED***/ - parameter downloadTask:       The download task that resumed. See explanation in the discussion.
    ***REMOVED***/ - parameter fileOffset:         If the file's cache policy or last modified date prevents reuse of the
    ***REMOVED***/                                 existing content, then this value is zero. Otherwise, this value is an
    ***REMOVED***/                                 integer representing the number of bytes on disk that do not need to be
    ***REMOVED***/                                 retrieved again.
    ***REMOVED***/ - parameter expectedTotalBytes: The expected length of the file, as provided by the Content-Length header.
    ***REMOVED***/                                 If this header was not provided, the value is NSURLSessionTransferSizeUnknown.
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64)
    {
        if let downloadTaskDidResumeAtOffset = downloadTaskDidResumeAtOffset {
            downloadTaskDidResumeAtOffset(session, downloadTask, fileOffset, expectedTotalBytes)
        } else if let delegate = self[downloadTask]?.delegate as? DownloadTaskDelegate {
            delegate.urlSession(
                session,
                downloadTask: downloadTask,
                didResumeAtOffset: fileOffset,
                expectedTotalBytes: expectedTotalBytes
            )
        }
    }
}

***REMOVED*** MARK: - URLSessionStreamDelegate

#if !os(watchOS)

@available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
extension SessionDelegate: URLSessionStreamDelegate {
    ***REMOVED***/ Tells the delegate that the read side of the connection has been closed.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:    The session.
    ***REMOVED***/ - parameter streamTask: The stream task.
    open func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        streamTaskReadClosed?(session, streamTask)
    }

    ***REMOVED***/ Tells the delegate that the write side of the connection has been closed.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:    The session.
    ***REMOVED***/ - parameter streamTask: The stream task.
    open func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        streamTaskWriteClosed?(session, streamTask)
    }

    ***REMOVED***/ Tells the delegate that the system has determined that a better route to the host is available.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:    The session.
    ***REMOVED***/ - parameter streamTask: The stream task.
    open func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        streamTaskBetterRouteDiscovered?(session, streamTask)
    }

    ***REMOVED***/ Tells the delegate that the stream task has been completed and provides the unopened stream objects.
    ***REMOVED***/
    ***REMOVED***/ - parameter session:      The session.
    ***REMOVED***/ - parameter streamTask:   The stream task.
    ***REMOVED***/ - parameter inputStream:  The new input stream.
    ***REMOVED***/ - parameter outputStream: The new output stream.
    open func urlSession(
        _ session: URLSession,
        streamTask: URLSessionStreamTask,
        didBecome inputStream: InputStream,
        outputStream: OutputStream)
    {
        streamTaskDidBecomeInputAndOutputStreams?(session, streamTask, inputStream, outputStream)
    }
}

#endif
