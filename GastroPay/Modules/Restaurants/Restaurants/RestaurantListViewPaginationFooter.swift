import UIKit

class RestaurantListViewPaginationFooter: UICollectionReusableView {
    //MARK: Variables
    
    public static let reuseIdentifier = "MyFooterClass"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear

        // Customize here
     }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     }
}
