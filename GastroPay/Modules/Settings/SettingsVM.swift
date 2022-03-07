import Foundation
import UIKit

enum SettingsCellType: Int {
    case userAggreement = 0
    case writeUs = 1
    case faq = 2
    case contactUs = 3
}

class SettingsVM: NSObject {
    public var backgroundColor = ColorHelper.General.vcBackgroundColor
    public var navigationTitleText = Localization.Settings.navigationTitle.local
    public var navigationTitleFont = FontHelper.Navigation.title
    public var navigationTitleTextColor = UIColor.white
    public var navigationLeftImage = ImageHelper.Icons.backArrow
    public var collectionView: UICollectionView!
    public var viewController: MIViewController

    var onSelectCell: ((SettingsCellType) -> ())? = nil

    let navigationTitleLabel = UILabel()
    
    init(vc: MIViewController) {
        self.viewController = vc
    }
    
    func setupView() {
        viewController.view.backgroundColor = backgroundColor
        navigationTitleLabel.text = self.navigationTitleText
        navigationTitleLabel.font = self.navigationTitleFont
        navigationTitleLabel.textColor = self.navigationTitleTextColor
        
        initCollectionView()
    }
    
    func initCollectionView() {
        let collectionViewFlowLayout = UICollectionViewStretchyHeaderLayout()
        collectionViewFlowLayout.minimumLineSpacing = 0.0
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = .clear
        collectionView.registerSupplementaryViewHeader(ContactUsReusableView.self)
        collectionView.register(UINib(nibName: "ProfileCollectionCell", bundle: BundleManager.getPodBundle()), forCellWithReuseIdentifier: "ProfileCollectionCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        viewController.view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        if #available(iOS 11.0, *) {
            collectionView.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            collectionView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        }
        collectionView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
    }
}

extension SettingsVM: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ContactUsReusableViewProtocol {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ProfileCollectionCell.self, for: indexPath)
        cell.setupForEmptyCell()
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: viewController.view.frame.width, height: 60)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueSupplementaryViewHeader(ContactUsReusableView.self, for: indexPath)
        headerView.delegate = self
        headerView.pageType = .settings
        
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: viewController.view.frame.width, height: 410)
    }
    
    func cellTapped(row: Int) {
        onSelectCell?(SettingsCellType(rawValue: row)!)
    }
}
