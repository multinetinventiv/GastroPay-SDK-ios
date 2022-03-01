
import UIKit

protocol ContactUsHeaderViewProtocol {
    func cellTapped(row: Int)
}

class ContactUsHeaderView: UIView {
    var delegate: ContactUsHeaderViewProtocol?
    var pageType: ProfilePageType = .contactUs
    
    var tableView = UITableView()
    
    var contactUsImageArry: [UIImage] = [ImageHelper.Profile.writeUs]
    var contactUsTitleArry: [String] = [Localization.Settings.contactUsWrite.local]
    
    var settingsImageArry: [UIImage] = [ImageHelper.Profile.userAgreement, ImageHelper.Profile.writeUs, ImageHelper.Profile.faq, ImageHelper.Profile.contactUs]
    var settingsTitleArry: [String] = [Localization.Settings.termsOfUse.local, Localization.Settings.notificationPreferences.local, Localization.Settings.faq.local, Localization.Settings.contactUs.local]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContactUsHeaderView: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView(){
        self.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ImageTextTableCell.self)
        tableView.isScrollEnabled = false
        
        self.tableView.tableFooterView = UIView()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch pageType {
        case .contactUs:
            return self.contactUsImageArry.count
        case .settings:
            return self.settingsImageArry.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ImageTextTableCell.self)
        switch pageType {
        case .contactUs:
            cell.setUI(image: contactUsImageArry[indexPath.row], title: contactUsTitleArry[indexPath.row])
        case .settings:
            cell.setUI(image: settingsImageArry[indexPath.row], title: settingsTitleArry[indexPath.row])
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        delegate?.cellTapped(row: indexPath.row)
    }
}
