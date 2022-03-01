***REMOVED***
***REMOVED***  Response.swift
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

***REMOVED***/ Used to store all data associated with an non-serialized response of a data or upload request.
public struct DefaultDataResponse {
    ***REMOVED***/ The URL request sent to the server.
    public let request: URLRequest?

    ***REMOVED***/ The server's response to the URL request.
    public let response: HTTPURLResponse?

    ***REMOVED***/ The data returned by the server.
    public let data: Data?

    ***REMOVED***/ The error encountered while executing or validating the request.
    public let error: Error?

    ***REMOVED***/ The timeline of the complete lifecycle of the request.
    public let timeline: Timeline

    var _metrics: AnyObject?

    ***REMOVED***/ Creates a `DefaultDataResponse` instance from the specified parameters.
    ***REMOVED***/
    ***REMOVED***/ - Parameters:
    ***REMOVED***/   - request:  The URL request sent to the server.
    ***REMOVED***/   - response: The server's response to the URL request.
    ***REMOVED***/   - data:     The data returned by the server.
    ***REMOVED***/   - error:    The error encountered while executing or validating the request.
    ***REMOVED***/   - timeline: The timeline of the complete lifecycle of the request. `Timeline()` by default.
    ***REMOVED***/   - metrics:  The task metrics containing the request / response statistics. `nil` by default.
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?,
        timeline: Timeline = Timeline(),
        metrics: AnyObject? = nil)
    {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
        self.timeline = timeline
    }
}

***REMOVED*** MARK: -

***REMOVED***/ Used to store all data associated with a serialized response of a data or upload request.
public struct DataResponse<Value> {
    ***REMOVED***/ The URL request sent to the server.
    public let request: URLRequest?

    ***REMOVED***/ The server's response to the URL request.
    public let response: HTTPURLResponse?

    ***REMOVED***/ The data returned by the server.
    public let data: Data?

    ***REMOVED***/ The result of response serialization.
    public let result: AFResult<Value>

    ***REMOVED***/ The timeline of the complete lifecycle of the request.
    public let timeline: Timeline

    ***REMOVED***/ Returns the associated value of the result if it is a success, `nil` otherwise.
    public var value: Value? { return result.value }

    ***REMOVED***/ Returns the associated error value if the result if it is a failure, `nil` otherwise.
    public var error: Error? { return result.error }

    var _metrics: AnyObject?

    ***REMOVED***/ Creates a `DataResponse` instance with the specified parameters derived from response serialization.
    ***REMOVED***/
    ***REMOVED***/ - parameter request:  The URL request sent to the server.
    ***REMOVED***/ - parameter response: The server's response to the URL request.
    ***REMOVED***/ - parameter data:     The data returned by the server.
    ***REMOVED***/ - parameter result:   The result of response serialization.
    ***REMOVED***/ - parameter timeline: The timeline of the complete lifecycle of the `Request`. Defaults to `Timeline()`.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `DataResponse` instance.
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        result: AFResult<Value>,
        timeline: Timeline = Timeline())
    {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
        self.timeline = timeline
    }
}

***REMOVED*** MARK: -

extension DataResponse: CustomStringConvertible, CustomDebugStringConvertible {
    ***REMOVED***/ The textual representation used when written to an output stream, which includes whether the result was a
    ***REMOVED***/ success or failure.
    public var description: String {
        return result.debugDescription
    }

    ***REMOVED***/ The debug textual representation used when written to an output stream, which includes the URL request, the URL
    ***REMOVED***/ response, the server data, the response serialization result and the timeline.
    public var debugDescription: String {
        let requestDescription = request.map { "\($0.httpMethod ?? "GET") \($0)"} ?? "nil"
        let requestBody = request?.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "None"
        let responseDescription = response.map { "\($0)" } ?? "nil"
        let responseBody = data.map { String(decoding: $0, as: UTF8.self) } ?? "None"

        return """
        [Request]: \(requestDescription)
        [Request Body]: \n\(requestBody)
        [Response]: \(responseDescription)
        [Response Body]: \n\(responseBody)
        [Result]: \(result)
        [Timeline]: \(timeline.debugDescription)
        """
    }
}

***REMOVED*** MARK: -

extension DataResponse {
    ***REMOVED***/ Evaluates the specified closure when the result of this `DataResponse` is a success, passing the unwrapped
    ***REMOVED***/ result value as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `map` method with a closure that does not throw. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: DataResponse<Data> = ...
    ***REMOVED***/     let possibleInt = possibleData.map { $0.count }
    ***REMOVED***/
    ***REMOVED***/ - parameter transform: A closure that takes the success value of the instance's result.
    ***REMOVED***/
    ***REMOVED***/ - returns: A `DataResponse` whose result wraps the value returned by the given closure. If this instance's
    ***REMOVED***/            result is a failure, returns a response wrapping the same failure.
    public func map<T>(_ transform: (Value) -> T) -> DataResponse<T> {
        var response = DataResponse<T>(
            request: request,
            response: self.response,
            data: data,
            result: result.map(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }

    ***REMOVED***/ Evaluates the given closure when the result of this `DataResponse` is a success, passing the unwrapped result
    ***REMOVED***/ value as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `flatMap` method with a closure that may throw an error. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: DataResponse<Data> = ...
    ***REMOVED***/     let possibleObject = possibleData.flatMap {
    ***REMOVED***/         try JSONSerialization.jsonObject(with: $0)
    ***REMOVED***/     }
    ***REMOVED***/
    ***REMOVED***/ - parameter transform: A closure that takes the success value of the instance's result.
    ***REMOVED***/
    ***REMOVED***/ - returns: A success or failure `DataResponse` depending on the result of the given closure. If this instance's
    ***REMOVED***/            result is a failure, returns the same failure.
    public func flatMap<T>(_ transform: (Value) throws -> T) -> DataResponse<T> {
        var response = DataResponse<T>(
            request: request,
            response: self.response,
            data: data,
            result: result.flatMap(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }

    ***REMOVED***/ Evaluates the specified closure when the `DataResponse` is a failure, passing the unwrapped error as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `mapError` function with a closure that does not throw. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: DataResponse<Data> = ...
    ***REMOVED***/     let withMyError = possibleData.mapError { MyError.error($0) }
    ***REMOVED***/
    ***REMOVED***/ - Parameter transform: A closure that takes the error of the instance.
    ***REMOVED***/ - Returns: A `DataResponse` instance containing the result of the transform.
    public func mapError<E: Error>(_ transform: (Error) -> E) -> DataResponse {
        var response = DataResponse(
            request: request,
            response: self.response,
            data: data,
            result: result.mapError(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }

    ***REMOVED***/ Evaluates the specified closure when the `DataResponse` is a failure, passing the unwrapped error as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `flatMapError` function with a closure that may throw an error. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: DataResponse<Data> = ...
    ***REMOVED***/     let possibleObject = possibleData.flatMapError {
    ***REMOVED***/         try someFailableFunction(taking: $0)
    ***REMOVED***/     }
    ***REMOVED***/
    ***REMOVED***/ - Parameter transform: A throwing closure that takes the error of the instance.
    ***REMOVED***/
    ***REMOVED***/ - Returns: A `DataResponse` instance containing the result of the transform.
    public func flatMapError<E: Error>(_ transform: (Error) throws -> E) -> DataResponse {
        var response = DataResponse(
            request: request,
            response: self.response,
            data: data,
            result: result.flatMapError(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }
}

***REMOVED*** MARK: -

***REMOVED***/ Used to store all data associated with an non-serialized response of a download request.
public struct DefaultDownloadResponse {
    ***REMOVED***/ The URL request sent to the server.
    public let request: URLRequest?

    ***REMOVED***/ The server's response to the URL request.
    public let response: HTTPURLResponse?

    ***REMOVED***/ The temporary destination URL of the data returned from the server.
    public let temporaryURL: URL?

    ***REMOVED***/ The final destination URL of the data returned from the server if it was moved.
    public let destinationURL: URL?

    ***REMOVED***/ The resume data generated if the request was cancelled.
    public let resumeData: Data?

    ***REMOVED***/ The error encountered while executing or validating the request.
    public let error: Error?

    ***REMOVED***/ The timeline of the complete lifecycle of the request.
    public let timeline: Timeline

    var _metrics: AnyObject?

    ***REMOVED***/ Creates a `DefaultDownloadResponse` instance from the specified parameters.
    ***REMOVED***/
    ***REMOVED***/ - Parameters:
    ***REMOVED***/   - request:        The URL request sent to the server.
    ***REMOVED***/   - response:       The server's response to the URL request.
    ***REMOVED***/   - temporaryURL:   The temporary destination URL of the data returned from the server.
    ***REMOVED***/   - destinationURL: The final destination URL of the data returned from the server if it was moved.
    ***REMOVED***/   - resumeData:     The resume data generated if the request was cancelled.
    ***REMOVED***/   - error:          The error encountered while executing or validating the request.
    ***REMOVED***/   - timeline:       The timeline of the complete lifecycle of the request. `Timeline()` by default.
    ***REMOVED***/   - metrics:        The task metrics containing the request / response statistics. `nil` by default.
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        temporaryURL: URL?,
        destinationURL: URL?,
        resumeData: Data?,
        error: Error?,
        timeline: Timeline = Timeline(),
        metrics: AnyObject? = nil)
    {
        self.request = request
        self.response = response
        self.temporaryURL = temporaryURL
        self.destinationURL = destinationURL
        self.resumeData = resumeData
        self.error = error
        self.timeline = timeline
    }
}

***REMOVED*** MARK: -

***REMOVED***/ Used to store all data associated with a serialized response of a download request.
public struct DownloadResponse<Value> {
    ***REMOVED***/ The URL request sent to the server.
    public let request: URLRequest?

    ***REMOVED***/ The server's response to the URL request.
    public let response: HTTPURLResponse?

    ***REMOVED***/ The temporary destination URL of the data returned from the server.
    public let temporaryURL: URL?

    ***REMOVED***/ The final destination URL of the data returned from the server if it was moved.
    public let destinationURL: URL?

    ***REMOVED***/ The resume data generated if the request was cancelled.
    public let resumeData: Data?

    ***REMOVED***/ The result of response serialization.
    public let result: AFResult<Value>

    ***REMOVED***/ The timeline of the complete lifecycle of the request.
    public let timeline: Timeline

    ***REMOVED***/ Returns the associated value of the result if it is a success, `nil` otherwise.
    public var value: Value? { return result.value }

    ***REMOVED***/ Returns the associated error value if the result if it is a failure, `nil` otherwise.
    public var error: Error? { return result.error }

    var _metrics: AnyObject?

    ***REMOVED***/ Creates a `DownloadResponse` instance with the specified parameters derived from response serialization.
    ***REMOVED***/
    ***REMOVED***/ - parameter request:        The URL request sent to the server.
    ***REMOVED***/ - parameter response:       The server's response to the URL request.
    ***REMOVED***/ - parameter temporaryURL:   The temporary destination URL of the data returned from the server.
    ***REMOVED***/ - parameter destinationURL: The final destination URL of the data returned from the server if it was moved.
    ***REMOVED***/ - parameter resumeData:     The resume data generated if the request was cancelled.
    ***REMOVED***/ - parameter result:         The result of response serialization.
    ***REMOVED***/ - parameter timeline:       The timeline of the complete lifecycle of the `Request`. Defaults to `Timeline()`.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `DownloadResponse` instance.
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        temporaryURL: URL?,
        destinationURL: URL?,
        resumeData: Data?,
        result: AFResult<Value>,
        timeline: Timeline = Timeline())
    {
        self.request = request
        self.response = response
        self.temporaryURL = temporaryURL
        self.destinationURL = destinationURL
        self.resumeData = resumeData
        self.result = result
        self.timeline = timeline
    }
}

***REMOVED*** MARK: -

extension DownloadResponse: CustomStringConvertible, CustomDebugStringConvertible {
    ***REMOVED***/ The textual representation used when written to an output stream, which includes whether the result was a
    ***REMOVED***/ success or failure.
    public var description: String {
        return result.debugDescription
    }

    ***REMOVED***/ The debug textual representation used when written to an output stream, which includes the URL request, the URL
    ***REMOVED***/ response, the temporary and destination URLs, the resume data, the response serialization result and the
    ***REMOVED***/ timeline.
    public var debugDescription: String {
        let requestDescription = request.map { "\($0.httpMethod ?? "GET") \($0)"} ?? "nil"
        let requestBody = request?.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "None"
        let responseDescription = response.map { "\($0)" } ?? "nil"

        return """
        [Request]: \(requestDescription)
        [Request Body]: \n\(requestBody)
        [Response]: \(responseDescription)
        [TemporaryURL]: \(temporaryURL?.path ?? "nil")
        [DestinationURL]: \(destinationURL?.path ?? "nil")
        [ResumeData]: \(resumeData?.count ?? 0) bytes
        [Result]: \(result)
        [Timeline]: \(timeline.debugDescription)
        """
    }
}

***REMOVED*** MARK: -

extension DownloadResponse {
    ***REMOVED***/ Evaluates the given closure when the result of this `DownloadResponse` is a success, passing the unwrapped
    ***REMOVED***/ result value as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `map` method with a closure that does not throw. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: DownloadResponse<Data> = ...
    ***REMOVED***/     let possibleInt = possibleData.map { $0.count }
    ***REMOVED***/
    ***REMOVED***/ - parameter transform: A closure that takes the success value of the instance's result.
    ***REMOVED***/
    ***REMOVED***/ - returns: A `DownloadResponse` whose result wraps the value returned by the given closure. If this instance's
    ***REMOVED***/            result is a failure, returns a response wrapping the same failure.
    public func map<T>(_ transform: (Value) -> T) -> DownloadResponse<T> {
        var response = DownloadResponse<T>(
            request: request,
            response: self.response,
            temporaryURL: temporaryURL,
            destinationURL: destinationURL,
            resumeData: resumeData,
            result: result.map(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }

    ***REMOVED***/ Evaluates the given closure when the result of this `DownloadResponse` is a success, passing the unwrapped
    ***REMOVED***/ result value as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `flatMap` method with a closure that may throw an error. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: DownloadResponse<Data> = ...
    ***REMOVED***/     let possibleObject = possibleData.flatMap {
    ***REMOVED***/         try JSONSerialization.jsonObject(with: $0)
    ***REMOVED***/     }
    ***REMOVED***/
    ***REMOVED***/ - parameter transform: A closure that takes the success value of the instance's result.
    ***REMOVED***/
    ***REMOVED***/ - returns: A success or failure `DownloadResponse` depending on the result of the given closure. If this
    ***REMOVED***/ instance's result is a failure, returns the same failure.
    public func flatMap<T>(_ transform: (Value) throws -> T) -> DownloadResponse<T> {
        var response = DownloadResponse<T>(
            request: request,
            response: self.response,
            temporaryURL: temporaryURL,
            destinationURL: destinationURL,
            resumeData: resumeData,
            result: result.flatMap(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }

    ***REMOVED***/ Evaluates the specified closure when the `DownloadResponse` is a failure, passing the unwrapped error as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `mapError` function with a closure that does not throw. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: DownloadResponse<Data> = ...
    ***REMOVED***/     let withMyError = possibleData.mapError { MyError.error($0) }
    ***REMOVED***/
    ***REMOVED***/ - Parameter transform: A closure that takes the error of the instance.
    ***REMOVED***/ - Returns: A `DownloadResponse` instance containing the result of the transform.
    public func mapError<E: Error>(_ transform: (Error) -> E) -> DownloadResponse {
        var response = DownloadResponse(
            request: request,
            response: self.response,
            temporaryURL: temporaryURL,
            destinationURL: destinationURL,
            resumeData: resumeData,
            result: result.mapError(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }

    ***REMOVED***/ Evaluates the specified closure when the `DownloadResponse` is a failure, passing the unwrapped error as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `flatMapError` function with a closure that may throw an error. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: DownloadResponse<Data> = ...
    ***REMOVED***/     let possibleObject = possibleData.flatMapError {
    ***REMOVED***/         try someFailableFunction(taking: $0)
    ***REMOVED***/     }
    ***REMOVED***/
    ***REMOVED***/ - Parameter transform: A throwing closure that takes the error of the instance.
    ***REMOVED***/
    ***REMOVED***/ - Returns: A `DownloadResponse` instance containing the result of the transform.
    public func flatMapError<E: Error>(_ transform: (Error) throws -> E) -> DownloadResponse {
        var response = DownloadResponse(
            request: request,
            response: self.response,
            temporaryURL: temporaryURL,
            destinationURL: destinationURL,
            resumeData: resumeData,
            result: result.flatMapError(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }
}

***REMOVED*** MARK: -

protocol Response {
    ***REMOVED***/ The task metrics containing the request / response statistics.
    var _metrics: AnyObject? { get set }
    mutating func add(_ metrics: AnyObject?)
}

extension Response {
    mutating func add(_ metrics: AnyObject?) {
        #if !os(watchOS)
            guard #available(iOS 10.0, macOS 10.12, tvOS 10.0, *) else { return }
            guard let metrics = metrics as? URLSessionTaskMetrics else { return }

            _metrics = metrics
        #endif
    }
}

***REMOVED*** MARK: -

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DefaultDataResponse: Response {
#if !os(watchOS)
    ***REMOVED***/ The task metrics containing the request / response statistics.
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DataResponse: Response {
#if !os(watchOS)
    ***REMOVED***/ The task metrics containing the request / response statistics.
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DefaultDownloadResponse: Response {
#if !os(watchOS)
    ***REMOVED***/ The task metrics containing the request / response statistics.
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DownloadResponse: Response {
#if !os(watchOS)
    ***REMOVED***/ The task metrics containing the request / response statistics.
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}
