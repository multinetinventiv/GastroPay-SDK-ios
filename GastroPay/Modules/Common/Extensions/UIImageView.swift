***REMOVED***
***REMOVED***  UIImageView.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 16.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit
import SDWebImage

public enum UIImageViewImageTransition {
    case fade
    case none
}

public extension UIImageView {

    func setImage(from url: String) {
        self.sd_setImage(with: URL(string: url), completed: nil)
    }

    func setImage(from url: String, placeholder: UIImage?, animation: UIImageViewImageTransition, delayPlaceholder: Bool = false) {
        self.sd_setImage(with: URL(string: url), placeholderImage: placeholder, options: delayPlaceholder ? SDWebImageOptions.delayPlaceholder : []) { (image, error, _, _) in
            if error != nil {
                self.image = placeholder
                return
            }

            if let image = image {
                self.setImage(image: image, animation: animation)
            } else {
                self.image = placeholder
            }
        }
    }

    func setImage(image: UIImage, animation: UIImageViewImageTransition) {
        switch animation {
        case .fade:
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.image = image
            }, completion: nil)
        default:
            self.image = image
        }
    }

}

public extension UIImage {

    func base64String(quality: CGFloat = 100, forSize: CGSize? = nil) -> String? {
        guard let imageData = (forSize != nil ? self.resizeImage(image: self, targetSize: forSize!) : self).jpegData(compressionQuality: quality) else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        ***REMOVED*** Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        ***REMOVED*** This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        ***REMOVED*** Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func tinted(with color: UIColor, isOpaque: Bool = false) -> UIImage? {
            let format = imageRendererFormat
            format.opaque = isOpaque
            return UIGraphicsImageRenderer(size: size, format: format).image { _ in
                color.set()
                withRenderingMode(.alwaysTemplate).draw(at: .zero)
            }
    }

}
