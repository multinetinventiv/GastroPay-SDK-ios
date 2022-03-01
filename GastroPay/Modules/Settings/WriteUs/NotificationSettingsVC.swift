
import UIKit
import Then
import YPNavigationBarTransition

class NotificationSettingsVC: MIStackableViewController {
    
    var viewModel: NotificationSettingsVM!
    
    init(viewModel: NotificationSettingsVM? = nil) {
        super.init(stackViewTopConstraintToSafeArea: true)
        
        if let viewModel = viewModel {
            self.viewModel = viewModel
        } else {
            self.viewModel = NotificationSettingsVM(vc: self)
        }
        
        self.viewModel.setupView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = Localization.Profile.notificationPreferencesTitle.local
    }
}

extension NotificationSettingsVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.notificationGroups.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection \(viewModel.notificationGroups[viewModel.notificationGroups.index(viewModel.notificationGroups.startIndex, offsetBy: section)].value.count)")
        
        let tempGroup = viewModel.notificationGroups[viewModel.notificationGroups.index(viewModel.notificationGroups.startIndex, offsetBy: section)]
        
        return tempGroup.value.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dictIndex = viewModel.notificationGroups.index(viewModel.notificationGroups.startIndex, offsetBy: section)
        let elementInDict = viewModel.notificationGroups[dictIndex]
        let titleString = elementInDict.value.first?.label ?? ""
        
        
        let title = UILabel()
        title.font = FontHelper.lightTextFont(size: 16)
        title.textColor = UIColor(rgb: 0x273C2F)
        title.text = titleString

        let headerView = UIView()
        headerView.addSubview(title)
        title.bindFrameToSuperviewBounds(lefMargin: 16, rightMargin: 16, topMargin: 16, bottomMargin: 16)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NotificationDetailCell.self)
        let dictIndex = viewModel.notificationGroups.index(viewModel.notificationGroups.startIndex, offsetBy: indexPath.section)
        let preference = self.viewModel.notificationGroups[dictIndex].value[indexPath.row]
        cell.configure(for: preference)
        cell.onSwitchChanged  = { [weak self] switchStatus in
            guard let self = self else { return }
            if let row = self.viewModel.notificationPreferences.firstIndex(where: {$0.id == preference.id && $0.channel == preference.channel}) {
                self.viewModel.notificationPreferences[row].state = switchStatus ? 1 : 0
            }
            
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

}

extension NotificationSettingsVC: NavigationBarConfigureStyle {
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return [.showShadowImage]
    }

    func yp_navigationBarTintColor() -> UIColor! {
        .black
    }
}
