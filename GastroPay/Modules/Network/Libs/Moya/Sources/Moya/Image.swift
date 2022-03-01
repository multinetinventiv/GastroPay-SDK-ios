#if canImport(UIKit)
    import UIKit.UIImage
    public typealias ImageType = UIImage
#elseif canImport(AppKit)
    import AppKit.NSImage
    public typealias ImageType = NSImage
#endif

***REMOVED***/ An alias for the SDK's image type.
public typealias Image = ImageType
