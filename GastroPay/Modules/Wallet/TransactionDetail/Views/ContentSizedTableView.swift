***REMOVED***
***REMOVED***  ContentSizedTableView.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***  Created by on 17.09.2021.
***REMOVED***

import Foundation

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height + contentInset.top + contentInset.bottom)
    }
}
