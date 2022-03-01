import Foundation

public extension URL {

    ***REMOVED***/ Initialize URL from Moya's `TargetType`.
    init<T: TargetType>(target: T) {
        ***REMOVED*** When a TargetType's path is empty, URL.appendingPathComponent may introduce trailing /, which may not be wanted in some cases
        ***REMOVED*** See: https:***REMOVED***github.com/Moya/Moya/pull/1053
        ***REMOVED*** And: https:***REMOVED***github.com/Moya/Moya/issues/1049
        if target.path.isEmpty {
            self = target.baseURL
        } else {
            self = target.baseURL.appendingPathComponent(target.path)
        }
    }
}
