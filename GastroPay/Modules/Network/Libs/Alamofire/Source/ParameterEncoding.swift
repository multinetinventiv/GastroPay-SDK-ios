***REMOVED***
***REMOVED***  ParameterEncoding.swift
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

***REMOVED***/ HTTP method definitions.
***REMOVED***/
***REMOVED***/ See https:***REMOVED***tools.ietf.org/html/rfc7231#section-4.3
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

***REMOVED*** MARK: -

***REMOVED***/ A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]

***REMOVED***/ A type used to define how a set of parameters are applied to a `URLRequest`.
public protocol ParameterEncoding {
    ***REMOVED***/ Creates a URL request by encoding parameters and applying them onto an existing request.
    ***REMOVED***/
    ***REMOVED***/ - parameter urlRequest: The request to have parameters applied.
    ***REMOVED***/ - parameter parameters: The parameters to apply.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ***REMOVED***/
    ***REMOVED***/ - returns: The encoded request.
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest
}

***REMOVED*** MARK: -

***REMOVED***/ Creates a url-encoded query string to be set as or appended to any existing URL query string or set as the HTTP
***REMOVED***/ body of the URL request. Whether the query string is set or appended to any existing URL query string or set as
***REMOVED***/ the HTTP body depends on the destination of the encoding.
***REMOVED***/
***REMOVED***/ The `Content-Type` HTTP header field of an encoded request with HTTP body is set to
***REMOVED***/ `application/x-www-form-urlencoded; charset=utf-8`.
***REMOVED***/
***REMOVED***/ There is no published specification for how to encode collection types. By default the convention of appending
***REMOVED***/ `[]` to the key for array values (`foo[]=1&foo[]=2`), and appending the key surrounded by square brackets for
***REMOVED***/ nested dictionary values (`foo[bar]=baz`) is used. Optionally, `ArrayEncoding` can be used to omit the
***REMOVED***/ square brackets appended to array keys.
***REMOVED***/
***REMOVED***/ `BoolEncoding` can be used to configure how boolean values are encoded. The default behavior is to encode
***REMOVED***/ `true` as 1 and `false` as 0.
public struct URLEncoding: ParameterEncoding {

    ***REMOVED*** MARK: Helper Types

    ***REMOVED***/ Defines whether the url-encoded query string is applied to the existing query string or HTTP body of the
    ***REMOVED***/ resulting URL request.
    ***REMOVED***/
    ***REMOVED***/ - methodDependent: Applies encoded query string result to existing query string for `GET`, `HEAD` and `DELETE`
    ***REMOVED***/                    requests and sets as the HTTP body for requests with any other HTTP method.
    ***REMOVED***/ - queryString:     Sets or appends encoded query string result to existing query string.
    ***REMOVED***/ - httpBody:        Sets encoded query string result as the HTTP body of the URL request.
    public enum Destination {
        case methodDependent, queryString, httpBody
    }

    ***REMOVED***/ Configures how `Array` parameters are encoded.
    ***REMOVED***/
    ***REMOVED***/ - brackets:        An empty set of square brackets is appended to the key for every value.
    ***REMOVED***/                    This is the default behavior.
    ***REMOVED***/ - noBrackets:      No brackets are appended. The key is encoded as is.
    public enum ArrayEncoding {
        case brackets, noBrackets

        func encode(key: String) -> String {
            switch self {
            case .brackets:
                return "\(key)[]"
            case .noBrackets:
                return key
            }
        }
    }

    ***REMOVED***/ Configures how `Bool` parameters are encoded.
    ***REMOVED***/
    ***REMOVED***/ - numeric:         Encode `true` as `1` and `false` as `0`. This is the default behavior.
    ***REMOVED***/ - literal:         Encode `true` and `false` as string literals.
    public enum BoolEncoding {
        case numeric, literal

        func encode(value: Bool) -> String {
            switch self {
            case .numeric:
                return value ? "1" : "0"
            case .literal:
                return value ? "true" : "false"
            }
        }
    }

    ***REMOVED*** MARK: Properties

    ***REMOVED***/ Returns a default `URLEncoding` instance.
    public static var `default`: URLEncoding { return URLEncoding() }

    ***REMOVED***/ Returns a `URLEncoding` instance with a `.methodDependent` destination.
    public static var methodDependent: URLEncoding { return URLEncoding() }

    ***REMOVED***/ Returns a `URLEncoding` instance with a `.queryString` destination.
    public static var queryString: URLEncoding { return URLEncoding(destination: .queryString) }

    ***REMOVED***/ Returns a `URLEncoding` instance with an `.httpBody` destination.
    public static var httpBody: URLEncoding { return URLEncoding(destination: .httpBody) }

    ***REMOVED***/ The destination defining where the encoded query string is to be applied to the URL request.
    public let destination: Destination

    ***REMOVED***/ The encoding to use for `Array` parameters.
    public let arrayEncoding: ArrayEncoding

    ***REMOVED***/ The encoding to use for `Bool` parameters.
    public let boolEncoding: BoolEncoding

    ***REMOVED*** MARK: Initialization

    ***REMOVED***/ Creates a `URLEncoding` instance using the specified destination.
    ***REMOVED***/
    ***REMOVED***/ - parameter destination: The destination defining where the encoded query string is to be applied.
    ***REMOVED***/ - parameter arrayEncoding: The encoding to use for `Array` parameters.
    ***REMOVED***/ - parameter boolEncoding: The encoding to use for `Bool` parameters.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `URLEncoding` instance.
    public init(destination: Destination = .methodDependent, arrayEncoding: ArrayEncoding = .brackets, boolEncoding: BoolEncoding = .numeric) {
        self.destination = destination
        self.arrayEncoding = arrayEncoding
        self.boolEncoding = boolEncoding
    }

    ***REMOVED*** MARK: Encoding

    ***REMOVED***/ Creates a URL request by encoding parameters and applying them onto an existing request.
    ***REMOVED***/
    ***REMOVED***/ - parameter urlRequest: The request to have parameters applied.
    ***REMOVED***/ - parameter parameters: The parameters to apply.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `Error` if the encoding process encounters an error.
    ***REMOVED***/
    ***REMOVED***/ - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

        if let method = HTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), encodesParametersInURL(with: method) {
            guard let url = urlRequest.url else {
                throw AFError.parameterEncodingFailed(reason: .missingURL)
            }

            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }

        return urlRequest
    }

    ***REMOVED***/ Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
    ***REMOVED***/
    ***REMOVED***/ - parameter key:   The key of the query component.
    ***REMOVED***/ - parameter value: The value of the query component.
    ***REMOVED***/
    ***REMOVED***/ - returns: The percent-escaped, URL encoded query string components.
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: arrayEncoding.encode(key: key), value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape(boolEncoding.encode(value: value.boolValue))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape(boolEncoding.encode(value: bool))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }

        return components
    }

    ***REMOVED***/ Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ***REMOVED***/
    ***REMOVED***/ RFC 3986 states that the following characters are "reserved" characters.
    ***REMOVED***/
    ***REMOVED***/ - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    ***REMOVED***/ - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ***REMOVED***/
    ***REMOVED***/ In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    ***REMOVED***/ query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    ***REMOVED***/ should be percent-escaped in the query string.
    ***REMOVED***/
    ***REMOVED***/ - parameter string: The string to be percent-escaped.
    ***REMOVED***/
    ***REMOVED***/ - returns: The percent-escaped string.
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" ***REMOVED*** does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        var escaped = ""

        ***REMOVED***==========================================================================================================
        ***REMOVED***
        ***REMOVED***  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        ***REMOVED***  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        ***REMOVED***  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        ***REMOVED***  info, please refer to:
        ***REMOVED***
        ***REMOVED***      - https:***REMOVED***github.com/Alamofire/Alamofire/issues/206
        ***REMOVED***
        ***REMOVED***==========================================================================================================

        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex

            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex

                let substring = string[range]

                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)

                index = endIndex
            }
        }

        return escaped
    }

    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }

    private func encodesParametersInURL(with method: HTTPMethod) -> Bool {
        switch destination {
        case .queryString:
            return true
        case .httpBody:
            return false
        default:
            break
        }

        switch method {
        case .get, .head, .delete:
            return true
        default:
            return false
        }
    }
}

***REMOVED*** MARK: -

***REMOVED***/ Uses `JSONSerialization` to create a JSON representation of the parameters object, which is set as the body of the
***REMOVED***/ request. The `Content-Type` HTTP header field of an encoded request is set to `application/json`.
public struct JSONEncoding: ParameterEncoding {

    ***REMOVED*** MARK: Properties

    ***REMOVED***/ Returns a `JSONEncoding` instance with default writing options.
    public static var `default`: JSONEncoding { return JSONEncoding() }

    ***REMOVED***/ Returns a `JSONEncoding` instance with `.prettyPrinted` writing options.
    public static var prettyPrinted: JSONEncoding { return JSONEncoding(options: .prettyPrinted) }

    ***REMOVED***/ The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions

    ***REMOVED*** MARK: Initialization

    ***REMOVED***/ Creates a `JSONEncoding` instance using the specified options.
    ***REMOVED***/
    ***REMOVED***/ - parameter options: The options for writing the parameters as JSON data.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `JSONEncoding` instance.
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }

    ***REMOVED*** MARK: Encoding

    ***REMOVED***/ Creates a URL request by encoding parameters and applying them onto an existing request.
    ***REMOVED***/
    ***REMOVED***/ - parameter urlRequest: The request to have parameters applied.
    ***REMOVED***/ - parameter parameters: The parameters to apply.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `Error` if the encoding process encounters an error.
    ***REMOVED***/
    ***REMOVED***/ - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }

    ***REMOVED***/ Creates a URL request by encoding the JSON object and setting the resulting data on the HTTP body.
    ***REMOVED***/
    ***REMOVED***/ - parameter urlRequest: The request to apply the JSON object to.
    ***REMOVED***/ - parameter jsonObject: The JSON object to apply to the request.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `Error` if the encoding process encounters an error.
    ***REMOVED***/
    ***REMOVED***/ - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, withJSONObject jsonObject: Any? = nil) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let jsonObject = jsonObject else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }
}

***REMOVED*** MARK: -

***REMOVED***/ Uses `PropertyListSerialization` to create a plist representation of the parameters object, according to the
***REMOVED***/ associated format and write options values, which is set as the body of the request. The `Content-Type` HTTP header
***REMOVED***/ field of an encoded request is set to `application/x-plist`.
public struct PropertyListEncoding: ParameterEncoding {

    ***REMOVED*** MARK: Properties

    ***REMOVED***/ Returns a default `PropertyListEncoding` instance.
    public static var `default`: PropertyListEncoding { return PropertyListEncoding() }

    ***REMOVED***/ Returns a `PropertyListEncoding` instance with xml formatting and default writing options.
    public static var xml: PropertyListEncoding { return PropertyListEncoding(format: .xml) }

    ***REMOVED***/ Returns a `PropertyListEncoding` instance with binary formatting and default writing options.
    public static var binary: PropertyListEncoding { return PropertyListEncoding(format: .binary) }

    ***REMOVED***/ The property list serialization format.
    public let format: PropertyListSerialization.PropertyListFormat

    ***REMOVED***/ The options for writing the parameters as plist data.
    public let options: PropertyListSerialization.WriteOptions

    ***REMOVED*** MARK: Initialization

    ***REMOVED***/ Creates a `PropertyListEncoding` instance using the specified format and options.
    ***REMOVED***/
    ***REMOVED***/ - parameter format:  The property list serialization format.
    ***REMOVED***/ - parameter options: The options for writing the parameters as plist data.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `PropertyListEncoding` instance.
    public init(
        format: PropertyListSerialization.PropertyListFormat = .xml,
        options: PropertyListSerialization.WriteOptions = 0)
    {
        self.format = format
        self.options = options
    }

    ***REMOVED*** MARK: Encoding

    ***REMOVED***/ Creates a URL request by encoding parameters and applying them onto an existing request.
    ***REMOVED***/
    ***REMOVED***/ - parameter urlRequest: The request to have parameters applied.
    ***REMOVED***/ - parameter parameters: The parameters to apply.
    ***REMOVED***/
    ***REMOVED***/ - throws: An `Error` if the encoding process encounters an error.
    ***REMOVED***/
    ***REMOVED***/ - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try PropertyListSerialization.data(
                fromPropertyList: parameters,
                format: format,
                options: options
            )

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .propertyListEncodingFailed(error: error))
        }

        return urlRequest
    }
}

***REMOVED*** MARK: -

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
