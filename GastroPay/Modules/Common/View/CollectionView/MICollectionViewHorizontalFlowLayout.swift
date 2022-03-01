***REMOVED***
***REMOVED***  MICollectionViewHorizontalFlowLayout.swift
***REMOVED***  Inventiv+CommonModule
***REMOVED***
***REMOVED***  Created by  on 3.06.2020.
***REMOVED***

import UIKit

public class MICollectionViewHorizontalFlowLayout: UICollectionViewFlowLayout {
    public var isPagingEnabled: Bool = true
    public var cellWidth: CGFloat?

    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard
            let collectionView = self.collectionView,
            let cellWidth = cellWidth,
            isPagingEnabled
        else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        ***REMOVED*** Page height used for estimating and calculating paging.
        let pageWidth = cellWidth + self.minimumLineSpacing

        ***REMOVED*** Make an estimation of the current page position.
        let approximatePage = collectionView.contentOffset.x/pageWidth

        ***REMOVED*** Determine the current page based on velocity.
        let currentPage = velocity.x == 0.0 ? round(approximatePage) : (velocity.x < 0.0 ? floor(approximatePage) : ceil(approximatePage))

        ***REMOVED*** Create custom flickVelocity.
        let flickVelocity = velocity.x * 0.3

        ***REMOVED*** Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

        ***REMOVED*** Calculate newVerticalOffset.
        let newVerticalOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.left

        return CGPoint(x: newVerticalOffset, y: proposedContentOffset.y)
    }

}
