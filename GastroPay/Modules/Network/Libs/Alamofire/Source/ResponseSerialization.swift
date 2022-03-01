***REMOVED***
***REMOVED***  ResponseSerialization.swift
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

***REMOVED***/ The type in which all data response serializers must conform to in order to serialize a response.
public protocol DataResponseSerializerProtocol {
    ***REMOVED***/ The type of serialized object to be created by this `DataResponseSerializerType`.
    associatedtype SerializedObject

    ***REMOVED***/ A closure used by response handlers that takes a request, response, data and error and returns a result.
    var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> AFResult<SerializedObject> { get }
}

***REMOVED*** MARK: -

***REMOVED***/ A generic `DataResponseSerializerType` used to serialize a request, response, and data into a serialized object.
public struct DataResponseSerializer<Value>: DataResponseSerializerProtocol {
    ***REMOVED***/ The type of serialized object to be created by this `DataResponseSerializer`.
    public typealias SerializedObject = Value

    ***REMOVED***/ A closure used by response handlers that takes a request, response, data and error and returns a result.
    public var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> AFResult<Value>

    ***REMOVED***/ Initializes the `ResponseSerializer` instance with the given serialize response closure.
    ***REMOVED***/
    ***REMOVED***/ - parameter serializeResponse: The closure used to serialize the response.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new generic response serializer instance.
    public init(serializeResponse: @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?) -> AFResult<Value>) {
        self.serializeResponse = serializeResponse
    }
}

***REMOVED*** MARK: -

***REMOVED***/ The type in which all download response serializers must conform to in order to serialize a response.
public protocol DownloadResponseSerializerProtocol {
    ***REMOVED***/ The type of serialized object to be created by this `DownloadResponseSerializerType`.
    associatedtype SerializedObject

    ***REMOVED***/ A closure used by response handlers that takes a request, response, url and error and returns a result.
    var serializeResponse: (URLRequest?, HTTPURLResponse?, URL?, Error?) -> AFResult<SerializedObject> { get }
}

***REMOVED*** MARK: -

***REMOVED***/ A generic `DownloadResponseSerializerType` used to serialize a request, response, and data into a serialized object.
public struct DownloadResponseSerializer<Value>: DownloadResponseSerializerProtocol {
    ***REMOVED***/ The type of serialized object to be created by this `DownloadResponseSerializer`.
    public typealias SerializedObject = Value

    ***REMOVED***/ A closure used by response handlers that takes a request, response, url and error and returns a result.
    public var serializeResponse: (URLRequest?, HTTPURLResponse?, URL?, Error?) -> AFResult<Value>

    ***REMOVED***/ Initializes the `ResponseSerializer` instance with the given serialize response closure.
    ***REMOVED***/
    ***REMOVED***/ - parameter serializeResponse: The closure used to serialize the response.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new generic response serializer instance.
    public init(serializeResponse: @escaping (URLRequest?, HTTPURLResponse?, URL?, Error?) -> AFResult<Value>) {
        self.serializeResponse = serializeResponse
    }
}

***REMOVED*** MARK: - Timeline

extension Request {
    var timeline: Timeline {
        let requestStartTime = self.startTime ?? CFAbsoluteTimeGetCurrent()
        let requestCompletedTime = self.endTime ?? CFAbsoluteTimeGetCurrent()
        let initialResponseTime = self.delegate.initialResponseTime ?? requestCompletedTime

        return Timeline(
            requestStartTime: requestStartTime,
            initialResponseTime: initialResponseTime,
            requestCompletedTime: requestCompletedTime,
            serializationCompletedTime: CFAbsoluteTimeGetCurrent()
        )
    }
}

***REMOVED*** MARK: - Default

extension DataRequest {
    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter queue:             The queue on which the completion handler is dispatched.
    ***REMOVED***/ - parameter completionHandler: The code to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func response(queue: DispatchQueue? = nil, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Self {
        delegate.queue.addOperation {
            (queue ?? DispatchQueue.main).async {
                var dataResponse = DefaultDataResponse(
                    request: self.request,
                    response: self.response,
                    data: self.delegate.data,
                    error: self.delegate.error,
                    timeline: self.timeline
                )

                dataResponse.add(self.delegate.metrics)

                completionHandler(dataResponse)
            }
        }

        return self
    }

    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter queue:              The queue on which the completion handler is dispatched.
    ***REMOVED***/ - parameter responseSerializer: The response serializer responsible for serializing the request, response,
    ***REMOVED***/                                 and data.
    ***REMOVED***/ - parameter completionHandler:  The code to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func response<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T,
        completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void)
        -> Self
    {
        delegate.queue.addOperation {
            let result = responseSerializer.serializeResponse(
                self.request,
                self.response,
                self.delegate.data,
                self.delegate.error
            )

            var dataResponse = DataResponse<T.SerializedObject>(
                request: self.request,
                response: self.response,
                data: self.delegate.data,
                result: result,
                timeline: self.timeline
            )

            dataResponse.add(self.delegate.metrics)

            (queue ?? DispatchQueue.main).async { completionHandler(dataResponse) }
        }

        return self
    }
}

extension DownloadRequest {
    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter queue:             The queue on which the completion handler is dispatched.
    ***REMOVED***/ - parameter completionHandler: The code to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func response(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DefaultDownloadResponse) -> Void)
        -> Self
    {
        delegate.queue.addOperation {
            (queue ?? DispatchQueue.main).async {
                var downloadResponse = DefaultDownloadResponse(
                    request: self.request,
                    response: self.response,
                    temporaryURL: self.downloadDelegate.temporaryURL,
                    destinationURL: self.downloadDelegate.destinationURL,
                    resumeData: self.downloadDelegate.resumeData,
                    error: self.downloadDelegate.error,
                    timeline: self.timeline
                )

                downloadResponse.add(self.delegate.metrics)

                completionHandler(downloadResponse)
            }
        }

        return self
    }

    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter queue:              The queue on which the completion handler is dispatched.
    ***REMOVED***/ - parameter responseSerializer: The response serializer responsible for serializing the request, response,
    ***REMOVED***/                                 and data contained in the destination url.
    ***REMOVED***/ - parameter completionHandler:  The code to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func response<T: DownloadResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T,
        completionHandler: @escaping (DownloadResponse<T.SerializedObject>) -> Void)
        -> Self
    {
        delegate.queue.addOperation {
            let result = responseSerializer.serializeResponse(
                self.request,
                self.response,
                self.downloadDelegate.fileURL,
                self.downloadDelegate.error
            )

            var downloadResponse = DownloadResponse<T.SerializedObject>(
                request: self.request,
                response: self.response,
                temporaryURL: self.downloadDelegate.temporaryURL,
                destinationURL: self.downloadDelegate.destinationURL,
                resumeData: self.downloadDelegate.resumeData,
                result: result,
                timeline: self.timeline
            )

            downloadResponse.add(self.delegate.metrics)

            (queue ?? DispatchQueue.main).async { completionHandler(downloadResponse) }
        }

        return self
    }
}

***REMOVED*** MARK: - Data

extension Request {
    ***REMOVED***/ Returns a result data type that contains the response data as-is.
    ***REMOVED***/
    ***REMOVED***/ - parameter response: The response from the server.
    ***REMOVED***/ - parameter data:     The data returned from the server.
    ***REMOVED***/ - parameter error:    The error already encountered if it exists.
    ***REMOVED***/
    ***REMOVED***/ - returns: The result data type.
    public static func serializeResponseData(response: HTTPURLResponse?, data: Data?, error: Error?) -> AFResult<Data> {
        guard error == nil else { return .failure(error!) }

        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(Data()) }

        guard let validData = data else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
        }

        return .success(validData)
    }
}

extension DataRequest {
    ***REMOVED***/ Creates a response serializer that returns the associated data as-is.
    ***REMOVED***/
    ***REMOVED***/ - returns: A data response serializer.
    public static func dataResponseSerializer() -> DataResponseSerializer<Data> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseData(response: response, data: data, error: error)
        }
    }

    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter completionHandler: The code to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func responseData(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<Data>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.dataResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    ***REMOVED***/ Creates a response serializer that returns the associated data as-is.
    ***REMOVED***/
    ***REMOVED***/ - returns: A data response serializer.
    public static func dataResponseSerializer() -> DownloadResponseSerializer<Data> {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }

            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseData(response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }

    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter completionHandler: The code to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func responseData(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DownloadResponse<Data>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.dataResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}

***REMOVED*** MARK: - String

extension Request {
    ***REMOVED***/ Returns a result string type initialized from the response data with the specified string encoding.
    ***REMOVED***/
    ***REMOVED***/ - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server
    ***REMOVED***/                       response, falling back to the default HTTP default character set, ISO-8859-1.
    ***REMOVED***/ - parameter response: The response from the server.
    ***REMOVED***/ - parameter data:     The data returned from the server.
    ***REMOVED***/ - parameter error:    The error already encountered if it exists.
    ***REMOVED***/
    ***REMOVED***/ - returns: The result data type.
    public static func serializeResponseString(
        encoding: String.Encoding?,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> AFResult<String>
    {
        guard error == nil else { return .failure(error!) }

        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success("") }

        guard let validData = data else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
        }

        var convertedEncoding = encoding

        if let encodingName = response?.textEncodingName as CFString?, convertedEncoding == nil {
            convertedEncoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(
                CFStringConvertIANACharSetNameToEncoding(encodingName))
            )
        }

        let actualEncoding = convertedEncoding ?? .isoLatin1

        if let string = String(data: validData, encoding: actualEncoding) {
            return .success(string)
        } else {
            return .failure(AFError.responseSerializationFailed(reason: .stringSerializationFailed(encoding: actualEncoding)))
        }
    }
}

extension DataRequest {
    ***REMOVED***/ Creates a response serializer that returns a result string type initialized from the response data with
    ***REMOVED***/ the specified string encoding.
    ***REMOVED***/
    ***REMOVED***/ - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server
    ***REMOVED***/                       response, falling back to the default HTTP default character set, ISO-8859-1.
    ***REMOVED***/
    ***REMOVED***/ - returns: A string response serializer.
    public static func stringResponseSerializer(encoding: String.Encoding? = nil) -> DataResponseSerializer<String> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseString(encoding: encoding, response: response, data: data, error: error)
        }
    }

    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter encoding:          The string encoding. If `nil`, the string encoding will be determined from the
    ***REMOVED***/                                server response, falling back to the default HTTP default character set,
    ***REMOVED***/                                ISO-8859-1.
    ***REMOVED***/ - parameter completionHandler: A closure to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func responseString(
        queue: DispatchQueue? = nil,
        encoding: String.Encoding? = nil,
        completionHandler: @escaping (DataResponse<String>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.stringResponseSerializer(encoding: encoding),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    ***REMOVED***/ Creates a response serializer that returns a result string type initialized from the response data with
    ***REMOVED***/ the specified string encoding.
    ***REMOVED***/
    ***REMOVED***/ - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server
    ***REMOVED***/                       response, falling back to the default HTTP default character set, ISO-8859-1.
    ***REMOVED***/
    ***REMOVED***/ - returns: A string response serializer.
    public static func stringResponseSerializer(encoding: String.Encoding? = nil) -> DownloadResponseSerializer<String> {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }

            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseString(encoding: encoding, response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }

    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter encoding:          The string encoding. If `nil`, the string encoding will be determined from the
    ***REMOVED***/                                server response, falling back to the default HTTP default character set,
    ***REMOVED***/                                ISO-8859-1.
    ***REMOVED***/ - parameter completionHandler: A closure to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func responseString(
        queue: DispatchQueue? = nil,
        encoding: String.Encoding? = nil,
        completionHandler: @escaping (DownloadResponse<String>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.stringResponseSerializer(encoding: encoding),
            completionHandler: completionHandler
        )
    }
}

***REMOVED*** MARK: - JSON

extension Request {
    ***REMOVED***/ Returns a JSON object contained in a result type constructed from the response data using `JSONSerialization`
    ***REMOVED***/ with the specified reading options.
    ***REMOVED***/
    ***REMOVED***/ - parameter options:  The JSON serialization reading options. Defaults to `.allowFragments`.
    ***REMOVED***/ - parameter response: The response from the server.
    ***REMOVED***/ - parameter data:     The data returned from the server.
    ***REMOVED***/ - parameter error:    The error already encountered if it exists.
    ***REMOVED***/
    ***REMOVED***/ - returns: The result data type.
    public static func serializeResponseJSON(
        options: JSONSerialization.ReadingOptions,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> AFResult<Any>
    {
        guard error == nil else { return .failure(error!) }

        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(NSNull()) }

        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }

        do {
            let json = try JSONSerialization.jsonObject(with: validData, options: options)
            return .success(json)
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    ***REMOVED***/ Creates a response serializer that returns a JSON object result type constructed from the response data using
    ***REMOVED***/ `JSONSerialization` with the specified reading options.
    ***REMOVED***/
    ***REMOVED***/ - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    ***REMOVED***/
    ***REMOVED***/ - returns: A JSON object response serializer.
    public static func jsonResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DataResponseSerializer<Any>
    {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseJSON(options: options, response: response, data: data, error: error)
        }
    }

    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    ***REMOVED***/ - parameter completionHandler: A closure to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func responseJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.jsonResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    ***REMOVED***/ Creates a response serializer that returns a JSON object result type constructed from the response data using
    ***REMOVED***/ `JSONSerialization` with the specified reading options.
    ***REMOVED***/
    ***REMOVED***/ - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    ***REMOVED***/
    ***REMOVED***/ - returns: A JSON object response serializer.
    public static func jsonResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DownloadResponseSerializer<Any>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }

            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseJSON(options: options, response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }

    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    ***REMOVED***/ - parameter completionHandler: A closure to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func responseJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DownloadResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.jsonResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

***REMOVED*** MARK: - Property List

extension Request {
    ***REMOVED***/ Returns a plist object contained in a result type constructed from the response data using
    ***REMOVED***/ `PropertyListSerialization` with the specified reading options.
    ***REMOVED***/
    ***REMOVED***/ - parameter options:  The property list reading options. Defaults to `[]`.
    ***REMOVED***/ - parameter response: The response from the server.
    ***REMOVED***/ - parameter data:     The data returned from the server.
    ***REMOVED***/ - parameter error:    The error already encountered if it exists.
    ***REMOVED***/
    ***REMOVED***/ - returns: The result data type.
    public static func serializeResponsePropertyList(
        options: PropertyListSerialization.ReadOptions,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> AFResult<Any>
    {
        guard error == nil else { return .failure(error!) }

        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(NSNull()) }

        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }

        do {
            let plist = try PropertyListSerialization.propertyList(from: validData, options: options, format: nil)
            return .success(plist)
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .propertyListSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    ***REMOVED***/ Creates a response serializer that returns an object constructed from the response data using
    ***REMOVED***/ `PropertyListSerialization` with the specified reading options.
    ***REMOVED***/
    ***REMOVED***/ - parameter options: The property list reading options. Defaults to `[]`.
    ***REMOVED***/
    ***REMOVED***/ - returns: A property list object response serializer.
    public static func propertyListResponseSerializer(
        options: PropertyListSerialization.ReadOptions = [])
        -> DataResponseSerializer<Any>
    {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponsePropertyList(options: options, response: response, data: data, error: error)
        }
    }

    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter options:           The property list reading options. Defaults to `[]`.
    ***REMOVED***/ - parameter completionHandler: A closure to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func responsePropertyList(
        queue: DispatchQueue? = nil,
        options: PropertyListSerialization.ReadOptions = [],
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.propertyListResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    ***REMOVED***/ Creates a response serializer that returns an object constructed from the response data using
    ***REMOVED***/ `PropertyListSerialization` with the specified reading options.
    ***REMOVED***/
    ***REMOVED***/ - parameter options: The property list reading options. Defaults to `[]`.
    ***REMOVED***/
    ***REMOVED***/ - returns: A property list object response serializer.
    public static func propertyListResponseSerializer(
        options: PropertyListSerialization.ReadOptions = [])
        -> DownloadResponseSerializer<Any>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }

            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponsePropertyList(options: options, response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }

    ***REMOVED***/ Adds a handler to be called once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - parameter options:           The property list reading options. Defaults to `[]`.
    ***REMOVED***/ - parameter completionHandler: A closure to be executed once the request has finished.
    ***REMOVED***/
    ***REMOVED***/ - returns: The request.
    @discardableResult
    public func responsePropertyList(
        queue: DispatchQueue? = nil,
        options: PropertyListSerialization.ReadOptions = [],
        completionHandler: @escaping (DownloadResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.propertyListResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

***REMOVED***/ A set of HTTP response status code that do not contain response data.
private let emptyDataStatusCodes: Set<Int> = [204, 205]
