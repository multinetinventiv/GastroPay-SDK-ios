***REMOVED***
***REMOVED***  Timeline.swift
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

***REMOVED***/ Responsible for computing the timing metrics for the complete lifecycle of a `Request`.
public struct Timeline {
    ***REMOVED***/ The time the request was initialized.
    public let requestStartTime: CFAbsoluteTime

    ***REMOVED***/ The time the first bytes were received from or sent to the server.
    public let initialResponseTime: CFAbsoluteTime

    ***REMOVED***/ The time when the request was completed.
    public let requestCompletedTime: CFAbsoluteTime

    ***REMOVED***/ The time when the response serialization was completed.
    public let serializationCompletedTime: CFAbsoluteTime

    ***REMOVED***/ The time interval in seconds from the time the request started to the initial response from the server.
    public let latency: TimeInterval

    ***REMOVED***/ The time interval in seconds from the time the request started to the time the request completed.
    public let requestDuration: TimeInterval

    ***REMOVED***/ The time interval in seconds from the time the request completed to the time response serialization completed.
    public let serializationDuration: TimeInterval

    ***REMOVED***/ The time interval in seconds from the time the request started to the time response serialization completed.
    public let totalDuration: TimeInterval

    ***REMOVED***/ Creates a new `Timeline` instance with the specified request times.
    ***REMOVED***/
    ***REMOVED***/ - parameter requestStartTime:           The time the request was initialized. Defaults to `0.0`.
    ***REMOVED***/ - parameter initialResponseTime:        The time the first bytes were received from or sent to the server.
    ***REMOVED***/                                         Defaults to `0.0`.
    ***REMOVED***/ - parameter requestCompletedTime:       The time when the request was completed. Defaults to `0.0`.
    ***REMOVED***/ - parameter serializationCompletedTime: The time when the response serialization was completed. Defaults
    ***REMOVED***/                                         to `0.0`.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `Timeline` instance.
    public init(
        requestStartTime: CFAbsoluteTime = 0.0,
        initialResponseTime: CFAbsoluteTime = 0.0,
        requestCompletedTime: CFAbsoluteTime = 0.0,
        serializationCompletedTime: CFAbsoluteTime = 0.0)
    {
        self.requestStartTime = requestStartTime
        self.initialResponseTime = initialResponseTime
        self.requestCompletedTime = requestCompletedTime
        self.serializationCompletedTime = serializationCompletedTime

        self.latency = initialResponseTime - requestStartTime
        self.requestDuration = requestCompletedTime - requestStartTime
        self.serializationDuration = serializationCompletedTime - requestCompletedTime
        self.totalDuration = serializationCompletedTime - requestStartTime
    }
}

***REMOVED*** MARK: - CustomStringConvertible

extension Timeline: CustomStringConvertible {
    ***REMOVED***/ The textual representation used when written to an output stream, which includes the latency, the request
    ***REMOVED***/ duration and the total duration.
    public var description: String {
        let latency = String(format: "%.3f", self.latency)
        let requestDuration = String(format: "%.3f", self.requestDuration)
        let serializationDuration = String(format: "%.3f", self.serializationDuration)
        let totalDuration = String(format: "%.3f", self.totalDuration)

        ***REMOVED*** NOTE: Had to move to string concatenation due to memory leak filed as rdar:***REMOVED***26761490. Once memory leak is
        ***REMOVED*** fixed, we should move back to string interpolation by reverting commit 7d4a43b1.
        let timings = [
            "\"Latency\": " + latency + " secs",
            "\"Request Duration\": " + requestDuration + " secs",
            "\"Serialization Duration\": " + serializationDuration + " secs",
            "\"Total Duration\": " + totalDuration + " secs"
        ]

        return "Timeline: { " + timings.joined(separator: ", ") + " }"
    }
}

***REMOVED*** MARK: - CustomDebugStringConvertible

extension Timeline: CustomDebugStringConvertible {
    ***REMOVED***/ The textual representation used when written to an output stream, which includes the request start time, the
    ***REMOVED***/ initial response time, the request completed time, the serialization completed time, the latency, the request
    ***REMOVED***/ duration and the total duration.
    public var debugDescription: String {
        let requestStartTime = String(format: "%.3f", self.requestStartTime)
        let initialResponseTime = String(format: "%.3f", self.initialResponseTime)
        let requestCompletedTime = String(format: "%.3f", self.requestCompletedTime)
        let serializationCompletedTime = String(format: "%.3f", self.serializationCompletedTime)
        let latency = String(format: "%.3f", self.latency)
        let requestDuration = String(format: "%.3f", self.requestDuration)
        let serializationDuration = String(format: "%.3f", self.serializationDuration)
        let totalDuration = String(format: "%.3f", self.totalDuration)

        ***REMOVED*** NOTE: Had to move to string concatenation due to memory leak filed as rdar:***REMOVED***26761490. Once memory leak is
        ***REMOVED*** fixed, we should move back to string interpolation by reverting commit 7d4a43b1.
        let timings = [
            "\"Request Start Time\": " + requestStartTime,
            "\"Initial Response Time\": " + initialResponseTime,
            "\"Request Completed Time\": " + requestCompletedTime,
            "\"Serialization Completed Time\": " + serializationCompletedTime,
            "\"Latency\": " + latency + " secs",
            "\"Request Duration\": " + requestDuration + " secs",
            "\"Serialization Duration\": " + serializationDuration + " secs",
            "\"Total Duration\": " + totalDuration + " secs"
        ]

        return "Timeline: { " + timings.joined(separator: ", ") + " }"
    }
}
