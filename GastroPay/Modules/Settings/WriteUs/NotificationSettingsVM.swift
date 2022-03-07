
class NotificationSettingsVM: NSObject {
   
    weak public var viewController: NotificationSettingsVC?
    
    var notificationGroups: [Int: [NetworkModels.NotificationPreference]] = [:]
    var notificationPreferences: [NetworkModels.NotificationPreference] = []

    let preferencesTableView = MIStackTableView().then {
        $0.register(NotificationDetailCell.self)
        $0.allowsSelection = false
    }
    
    init(vc: NotificationSettingsVC?) {
        self.viewController = vc
    }
    
    func setupView(){
        preferencesTableView.delegate = viewController
        preferencesTableView.dataSource = viewController
        preferencesTableView.separatorStyle = .singleLine
        preferencesTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        preferencesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        
        doServiceRequest()
    }
    
    func doServiceRequest(){
        self.viewController?.setLoadingState(show: true)

        Service.getAPI()?.getNotificationPreferences { [weak self] (result) in
            guard let self = self else { return }
            defer { self.viewController?.setLoadingState(show: false) }
            switch result {
            case .success(let preferences):
                self.notificationPreferences = preferences
                preferences.forEach {[weak self] (pref) in
                    guard let self = self else { return }
                    if !self.notificationGroups.keys.contains(pref.id) {
                        self.notificationGroups[pref.id] = [pref]
                    } else if !self.notificationGroups[pref.id]!.contains(where: { $0.channel == pref.channel }), pref.channel != .push {
                        self.notificationGroups[pref.id]!.append(pref)
                    }
                }
                self.initPreferences()
            case .failure(let error):
                Service.getPopupManager()?.showErrorMessage(error)
            }
        }
    }
    
    func initPreferences() {
        self.viewController?.stackView.addRow(preferencesTableView, animated: true)
    }
}
