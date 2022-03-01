***REMOVED***
***REMOVED***  Result.swift
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

***REMOVED***/ Used to represent whether a request was successful or encountered an error.
***REMOVED***/
***REMOVED***/ - success: The request and all post processing operations were successful resulting in the serialization of the
***REMOVED***/            provided associated value.
***REMOVED***/
***REMOVED***/ - failure: The request encountered an error resulting in a failure. The associated values are the original data
***REMOVED***/            provided by the server as well as the error that caused the failure.
public enum AFResult<Value> {
    case success(Value)
    case failure(Error)

    ***REMOVED***/ Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    ***REMOVED***/ Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }

    ***REMOVED***/ Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    ***REMOVED***/ Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

***REMOVED*** MARK: - CustomStringConvertible

extension AFResult: CustomStringConvertible {
    ***REMOVED***/ The textual representation used when written to an output stream, which includes whether the result was a
    ***REMOVED***/ success or failure.
    public var description: String {
        switch self {
        case .success:
            return "SUCCESS"
        case .failure:
            return "FAILURE"
        }
    }
}

***REMOVED*** MARK: - CustomDebugStringConvertible

extension AFResult: CustomDebugStringConvertible {
    ***REMOVED***/ The debug textual representation used when written to an output stream, which includes whether the result was a
    ***REMOVED***/ success or failure in addition to the value or error.
    public var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}

***REMOVED*** MARK: - Functional APIs

extension AFResult {
    ***REMOVED***/ Creates a `AFResult` instance from the result of a closure.
    ***REMOVED***/
    ***REMOVED***/ A failure result is created when the closure throws, and a success result is created when the closure
    ***REMOVED***/ succeeds without throwing an error.
    ***REMOVED***/
    ***REMOVED***/     func someString() throws -> String { ... }
    ***REMOVED***/
    ***REMOVED***/     let result = AFResult(value: {
    ***REMOVED***/         return try someString()
    ***REMOVED***/     })
    ***REMOVED***/
    ***REMOVED***/     ***REMOVED*** The type of result is AFResult<String>
    ***REMOVED***/
    ***REMOVED***/ The trailing closure syntax is also supported:
    ***REMOVED***/
    ***REMOVED***/     let result = AFResult { try someString() }
    ***REMOVED***/
    ***REMOVED***/ - parameter value: The closure to execute and create the result for.
    public init(value: () throws -> Value) {
        do {
            self = try .success(value())
        } catch {
            self = .failure(error)
        }
    }

    ***REMOVED***/ Returns the success value, or throws the failure error.
    ***REMOVED***/
    ***REMOVED***/     let possibleString: AFResult<String> = .success("success")
    ***REMOVED***/     try print(possibleString.unwrap())
    ***REMOVED***/     ***REMOVED*** Prints "success"
    ***REMOVED***/
    ***REMOVED***/     let noString: AFResult<String> = .failure(error)
    ***REMOVED***/     try print(noString.unwrap())
    ***REMOVED***/     ***REMOVED*** Throws error
    public func unwrap() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    ***REMOVED***/ Evaluates the specified closure when the `Result` is a success, passing the unwrapped value as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `map` method with a closure that does not throw. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: Result<Data> = .success(Data())
    ***REMOVED***/     let possibleInt = possibleData.map { $0.count }
    ***REMOVED***/     try print(possibleInt.unwrap())
    ***REMOVED***/     ***REMOVED*** Prints "0"
    ***REMOVED***/
    ***REMOVED***/     let noData: Result<Data> = .failure(error)
    ***REMOVED***/     let noInt = noData.map { $0.count }
    ***REMOVED***/     try print(noInt.unwrap())
    ***REMOVED***/     ***REMOVED*** Throws error
    ***REMOVED***/
    ***REMOVED***/ - parameter transform: A closure that takes the success value of the `Result` instance.
    ***REMOVED***/
    ***REMOVED***/ - returns: A `Result` containing the result of the given closure. If this instance is a failure, returns the
    ***REMOVED***/            same failure.
    public func map<T>(_ transform: (Value) -> T) -> AFResult<T> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }

    ***REMOVED***/ Evaluates the specified closure when the `Result` is a success, passing the unwrapped value as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `flatMap` method with a closure that may throw an error. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: Result<Data> = .success(Data(...))
    ***REMOVED***/     let possibleObject = possibleData.flatMap {
    ***REMOVED***/         try JSONSerialization.jsonObject(with: $0)
    ***REMOVED***/     }
    ***REMOVED***/
    ***REMOVED***/ - parameter transform: A closure that takes the success value of the instance.
    ***REMOVED***/
    ***REMOVED***/ - returns: A `Result` containing the result of the given closure. If this instance is a failure, returns the
    ***REMOVED***/            same failure.
    public func flatMap<T>(_ transform: (Value) throws -> T) -> AFResult<T> {
        switch self {
        case .success(let value):
            do {
                return try .success(transform(value))
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    ***REMOVED***/ Evaluates the specified closure when the `Result` is a failure, passing the unwrapped error as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `mapError` function with a closure that does not throw. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: Result<Data> = .failure(someError)
    ***REMOVED***/     let withMyError: Result<Data> = possibleData.mapError { MyError.error($0) }
    ***REMOVED***/
    ***REMOVED***/ - Parameter transform: A closure that takes the error of the instance.
    ***REMOVED***/ - Returns: A `Result` instance containing the result of the transform. If this instance is a success, returns
    ***REMOVED***/            the same instance.
    public func mapError<T: Error>(_ transform: (Error) -> T) -> AFResult {
        switch self {
        case .failure(let error):
            return .failure(transform(error))
        case .success:
            return self
        }
    }

    ***REMOVED***/ Evaluates the specified closure when the `Result` is a failure, passing the unwrapped error as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `flatMapError` function with a closure that may throw an error. For example:
    ***REMOVED***/
    ***REMOVED***/     let possibleData: Result<Data> = .success(Data(...))
    ***REMOVED***/     let possibleObject = possibleData.flatMapError {
    ***REMOVED***/         try someFailableFunction(taking: $0)
    ***REMOVED***/     }
    ***REMOVED***/
    ***REMOVED***/ - Parameter transform: A throwing closure that takes the error of the instance.
    ***REMOVED***/
    ***REMOVED***/ - Returns: A `Result` instance containing the result of the transform. If this instance is a success, returns
    ***REMOVED***/            the same instance.
    public func flatMapError<T: Error>(_ transform: (Error) throws -> T) -> AFResult {
        switch self {
        case .failure(let error):
            do {
                return try .failure(transform(error))
            } catch {
                return .failure(error)
            }
        case .success:
            return self
        }
    }

    ***REMOVED***/ Evaluates the specified closure when the `Result` is a success, passing the unwrapped value as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `withValue` function to evaluate the passed closure without modifying the `Result` instance.
    ***REMOVED***/
    ***REMOVED***/ - Parameter closure: A closure that takes the success value of this instance.
    ***REMOVED***/ - Returns: This `Result` instance, unmodified.
    @discardableResult
    public func withValue(_ closure: (Value) throws -> Void) rethrows -> AFResult {
        if case let .success(value) = self { try closure(value) }

        return self
    }

    ***REMOVED***/ Evaluates the specified closure when the `Result` is a failure, passing the unwrapped error as a parameter.
    ***REMOVED***/
    ***REMOVED***/ Use the `withError` function to evaluate the passed closure without modifying the `Result` instance.
    ***REMOVED***/
    ***REMOVED***/ - Parameter closure: A closure that takes the success value of this instance.
    ***REMOVED***/ - Returns: This `Result` instance, unmodified.
    @discardableResult
    public func withError(_ closure: (Error) throws -> Void) rethrows -> AFResult {
        if case let .failure(error) = self { try closure(error) }

        return self
    }

    ***REMOVED***/ Evaluates the specified closure when the `Result` is a success.
    ***REMOVED***/
    ***REMOVED***/ Use the `ifSuccess` function to evaluate the passed closure without modifying the `Result` instance.
    ***REMOVED***/
    ***REMOVED***/ - Parameter closure: A `Void` closure.
    ***REMOVED***/ - Returns: This `Result` instance, unmodified.
    @discardableResult
    public func ifSuccess(_ closure: () throws -> Void) rethrows -> AFResult {
        if isSuccess { try closure() }

        return self
    }

    ***REMOVED***/ Evaluates the specified closure when the `Result` is a failure.
    ***REMOVED***/
    ***REMOVED***/ Use the `ifFailure` function to evaluate the passed closure without modifying the `Result` instance.
    ***REMOVED***/
    ***REMOVED***/ - Parameter closure: A `Void` closure.
    ***REMOVED***/ - Returns: This `Result` instance, unmodified.
    @discardableResult
    public func ifFailure(_ closure: () throws -> Void) rethrows -> AFResult {
        if isFailure { try closure() }

        return self
    }
}
