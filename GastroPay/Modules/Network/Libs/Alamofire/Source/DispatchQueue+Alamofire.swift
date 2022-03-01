***REMOVED***
***REMOVED***  DispatchQueue+Alamofire.swift
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

import Dispatch
import Foundation

extension DispatchQueue {
    static var userInteractive: DispatchQueue { return DispatchQueue.global(qos: .userInteractive) }
    static var userInitiated: DispatchQueue { return DispatchQueue.global(qos: .userInitiated) }
    static var utility: DispatchQueue { return DispatchQueue.global(qos: .utility) }
    static var background: DispatchQueue { return DispatchQueue.global(qos: .background) }

    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }
}
