import UIKit

class RestaurantListViewPaginationFooter: UICollectionReusableView {
    ***REMOVED***MARK: Variables
    
    public static let reuseIdentifier = "MyFooterClass"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear

        ***REMOVED*** Customize here
     }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     }
}
