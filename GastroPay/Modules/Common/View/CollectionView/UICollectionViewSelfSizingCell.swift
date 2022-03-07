//
//  UICollectionViewSelfSizingCell.swift
//  Inventiv+CommonModule
//
//  Created by  on 25.12.2019.
//

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

        // Specify you want _full width_
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 1)

        // Calculate the size (height) using Auto Layout
        let autoLayoutSize = subview.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)

        // Assign the new size to the layout attributes
        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }

}
