***REMOVED***
***REMOVED***  UIRange.swift
***REMOVED***  Alamofire
***REMOVED***
***REMOVED***  Created by  on 2.03.2020.
***REMOVED***

import UIKit

public extension Range where Bound == String.Index {
    var nsRange: NSRange {
        return NSRange(
            location: self.lowerBound.encodedOffset,
            length: self.upperBound.encodedOffset - self.lowerBound.encodedOffset
        )
    }

}
