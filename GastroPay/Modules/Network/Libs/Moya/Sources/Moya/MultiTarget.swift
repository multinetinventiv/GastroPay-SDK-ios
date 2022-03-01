import Foundation

***REMOVED***/ A `TargetType` used to enable `MoyaProvider` to process multiple `TargetType`s.
public enum MultiTarget: TargetType {
    ***REMOVED***/ The embedded `TargetType`.
    case target(TargetType)

    ***REMOVED***/ Initializes a `MultiTarget`.
    public init(_ target: TargetType) {
        self = MultiTarget.target(target)
    }

    ***REMOVED***/ The embedded target's base `URL`.
    public var path: String {
        return target.path
    }

    ***REMOVED***/ The baseURL of the embedded target.
    public var baseURL: URL {
        return target.baseURL
    }

    ***REMOVED***/ The HTTP method of the embedded target.
    public var method: Method {
        return target.method
    }

    ***REMOVED***/ The sampleData of the embedded target.
    public var sampleData: Data {
        return target.sampleData
    }

    ***REMOVED***/ The `Task` of the embedded target.
    public var task: Task {
        return target.task
    }

    ***REMOVED***/ The `ValidationType` of the embedded target.
    public var validationType: ValidationType {
        return target.validationType
    }

    ***REMOVED***/ The headers of the embedded target.
    public var headers: [String: String]? {
        return target.headers
    }

    ***REMOVED***/ The embedded `TargetType`.
    public var target: TargetType {
        switch self {
        case .target(let target): return target
        }
    }
}
