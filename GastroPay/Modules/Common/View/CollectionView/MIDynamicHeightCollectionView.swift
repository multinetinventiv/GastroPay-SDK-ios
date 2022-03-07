//
//  MIDynamicHeightCollectionView.swift
//  Alamofire
//
//  Created by  on 5.03.2020.
//

import UIKit

public class MIDynamicHeightCollectionView: UICollectionView {
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override public var intrinsicContentSize: CGSize {
        return self.contentSize
    }
}
