import UIKit
import YPNavigationBarTransition

class SettingsVC: MIViewController {
    var viewModel: SettingsVM!
    
    var gradientProgress: CGFloat = 0.0
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if gradientProgress >= 0.3 {
            return .default
        }
        
        return statusBarUpdater?.preferredStatusBarStyle ?? .lightContent
    }
    
    init(viewModel: SettingsVM? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        if let viewModel = viewModel {
            self.viewModel = viewModel
        } else {
            self.viewModel = SettingsVM(vc: self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarUpdater = Bartinter(.init(initialStatusBarStyle: .lightContent))
        setUI()

        viewModel.setupView()
        viewModel.onSelectCell = didSelectCell
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        yp_refreshNavigationBarStyle()
    }
    
    func setUI() {
        view.backgroundColor = viewModel.backgroundColor
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.titleView = viewModel.navigationTitleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: viewModel.navigationLeftImage, style: .done, target: self, action: #selector(tappedLeftButton))
    }
    
    @objc func tappedLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didSelectCell(type: SettingsCellType) {
        switch type {
        case .userAggreement:
            break
        case .writeUs:
            let notificationSettingsVC = NotificationSettingsVC(viewModel: nil)
            self.navigationController?.pushViewController(notificationSettingsVC, animated: true)
            
            break
        case .faq:
           break
        case .contactUs:
            let contactUsVC = ContactUsVC()
            self.navigationController?.pushViewController(contactUsVC, animated: true)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerHeight: CGFloat
        
        if #available(iOS 11.0, *) {
            headerHeight = 350 - self.view.safeAreaInsets.top
        } else {
            headerHeight = 350
        }
        
        let progress = viewModel.collectionView.contentOffset.y + viewModel.collectionView.contentInset.top
        var gradientProgress = max(0.0, min(1.0, progress / headerHeight))
        gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress
        
        if self.gradientProgress != gradientProgress {
            self.gradientProgress = gradientProgress
            yp_refreshNavigationBarStyle()
        }
    }
}

extension SettingsVC: NavigationBarConfigureStyle {
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        var configuration: YPNavigationBarConfigurations = .backgroundStyleColor
        
        if gradientProgress == 1 {
            configuration = .backgroundStyleOpaque
        }
        
        viewModel.navigationTitleLabel.textColor = .white
        
        return configuration
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        return UIColor(white: 1.0 - gradientProgress, alpha: 1.0)
    }
    
    public func yp_navigationBackgroundColor() -> UIColor! {
        return UIColor(white: 1.0, alpha: gradientProgress)
    }
}
