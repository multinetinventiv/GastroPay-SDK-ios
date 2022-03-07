//
//  UIRange.swift
//  Alamofire
//
//  Created by  on 2.03.2020.
//

import UIKit

public extension Range where Bound == String.Index {
    var nsRange: NSRange {
        return NSRange(
            location: self.lowerBound.encodedOffset,
            length: self.upperBound.encodedOffset - self.lowerBound.encodedOffset
        )
    }

}
