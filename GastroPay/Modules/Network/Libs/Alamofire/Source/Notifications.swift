***REMOVED***
***REMOVED***  Notifications.swift
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

extension Notification.Name {
    ***REMOVED***/ Used as a namespace for all `URLSessionTask` related notifications.
    public struct Task {
        ***REMOVED***/ Posted when a `URLSessionTask` is resumed. The notification `object` contains the resumed `URLSessionTask`.
        public static let DidResume = Notification.Name(rawValue: "org.alamofire.notification.name.task.didResume")

        ***REMOVED***/ Posted when a `URLSessionTask` is suspended. The notification `object` contains the suspended `URLSessionTask`.
        public static let DidSuspend = Notification.Name(rawValue: "org.alamofire.notification.name.task.didSuspend")

        ***REMOVED***/ Posted when a `URLSessionTask` is cancelled. The notification `object` contains the cancelled `URLSessionTask`.
        public static let DidCancel = Notification.Name(rawValue: "org.alamofire.notification.name.task.didCancel")

        ***REMOVED***/ Posted when a `URLSessionTask` is completed. The notification `object` contains the completed `URLSessionTask`.
        public static let DidComplete = Notification.Name(rawValue: "org.alamofire.notification.name.task.didComplete")
    }
}

***REMOVED*** MARK: -

extension Notification {
    ***REMOVED***/ Used as a namespace for all `Notification` user info dictionary keys.
    public struct Key {
        ***REMOVED***/ User info dictionary key representing the `URLSessionTask` associated with the notification.
        public static let Task = "org.alamofire.notification.key.task"

        ***REMOVED***/ User info dictionary key representing the responseData associated with the notification.
        public static let ResponseData = "org.alamofire.notification.key.responseData"
    }
}
