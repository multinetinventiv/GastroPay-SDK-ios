***REMOVED***
***REMOVED***  MIStackTableView.swift
***REMOVED***  Inventiv+CommonModule
***REMOVED***
***REMOVED***  Created by  on 16.07.2020.
***REMOVED***

import UIKit

public class MIStackTableView: UITableView {

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        isScrollEnabled = false
        separatorStyle = .none
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

    override public var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        let s = self.contentSize
        return CGSize(width: max(s.width, 1), height: max(s.height,1))
    }

}
