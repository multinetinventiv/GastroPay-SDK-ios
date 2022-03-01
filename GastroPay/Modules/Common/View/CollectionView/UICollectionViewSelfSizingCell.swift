***REMOVED***
***REMOVED***  UICollectionViewSelfSizingCell.swift
***REMOVED***  Inventiv+CommonModule
***REMOVED***
***REMOVED***  Created by  on 25.12.2019.
***REMOVED***

import UIKit

public class UICollectionViewSelfSizingCell: UICollectionViewCell {

    public func addAndConstraintSubview(subview: UIView) {
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        subview.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subview)
        subview.bindFrameToSuperviewBounds()
    }

    override public func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let subview = contentView.subviews.first else {
            fatalError("Cannot instantiate first subview for UICollectionViewSelfSizingCell")
        }

        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        ***REMOVED*** Specify you want _full width_
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 1)

        ***REMOVED*** Calculate the size (height) using Auto Layout
        let autoLayoutSize = subview.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)

        ***REMOVED*** Assign the new size to the layout attributes
        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }

}
