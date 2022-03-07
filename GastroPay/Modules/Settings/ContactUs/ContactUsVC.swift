import UIKit
import YPNavigationBarTransition
import MessageUI

public class ContactUsVC: MIViewController {
    var viewModel: ContactUsVM!

    var gradientProgress: CGFloat = 0.0
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if gradientProgress >= 0.3 {
            return .default
        }
        
        return statusBarUpdater?.preferredStatusBarStyle ?? .lightContent
    }
    
    init(viewModel: ContactUsVM? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        if let viewModel = viewModel {
            self.viewModel = viewModel
        } else {
            self.viewModel = ContactUsVM(vc: self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        statusBarUpdater = Bartinter(.init(initialStatusBarStyle: .lightContent))
        setUI()

        viewModel.setupView()
        viewModel.onSelectCell = didSelectCell
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
    
    func didSelectCell(type: ContactUsCellType) {
        sendEmail()
    }
    
    func callCallCenter() {
        var phoneNumber = "08503041083"
        if let settings = Service.getSettings() {
            phoneNumber = settings.phoneNumber
        }
        
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func sendEmail() {
        var email = "destek@gastroclub.com.tr"
        if let settings = Service.getSettings() {
            email = settings.email
        }
        if !MFMailComposeViewController.canSendMail() {
            UIApplication.shared.open(URL(string: "mailto:" + email)!)
            return
        }
        
        // Use the iOS Mail app
        let composeVC = MFMailComposeViewController()
        composeVC.setToRecipients([email])
        composeVC.mailComposeDelegate = self
        composeVC.setSubject(Localization.Settings.contactUsMailSubject.local)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
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

extension ContactUsVC: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ContactUsVC: NavigationBarConfigureStyle {
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
