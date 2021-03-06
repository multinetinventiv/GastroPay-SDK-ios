//
//  MIStackCollectionView.swift
//  Alamofire
//
//  Created by  on 5.03.2020.
//

import UIKit

public class MIStackCollectionView: UICollectionView {
    public override func reloadData() {
        super.reloadData()
        performBatchUpdates(nil) { (completed) in
            self.invalidateIntrinsicContentSize()
        }
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(
            width: max(collectionViewLayout.collectionViewContentSize.width, 1),
            height: max(collectionViewLayout.collectionViewContentSize.height,1)
        )
    }
}
