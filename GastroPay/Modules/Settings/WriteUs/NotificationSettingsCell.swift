
import UIKit
import Then

class NotificationDetailCell: UITableViewCell {
    var notificationPreference: NetworkModels.NotificationPreference? {
        didSet {
            if let model = self.notificationPreference {
                preferenceSwitch.isOn = model.state == 1
                lblTitle.text = model.getTitle()
            }
        }
    }
    
    var onSwitchChanged : ((Bool) -> ())?

    let lblTitle = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.lightTextFont(size: 16)
        $0.textColor = UIColor(rgb: 0x273C2F)
        $0.numberOfLines = 0
    }

    let pushActionButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleColor(ColorHelper.Button.textColor, for: .normal)
        $0.contentEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        $0.heightAnchor.constraint(equalToConstant: 32).isActive = true
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ColorHelper.Button.backgroundColor.cgColor
    }

    let preferenceSwitch = UISwitch().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        pushActionButton.addTarget(self, action: #selector(onTapActionButton), for: .touchUpInside)
        preferenceSwitch.addTarget(self, action: #selector(onSwitchStateChanged), for: .valueChanged)


        contentView.addSubview(lblTitle)

        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).with({ (const) in
                const.priority = .init(249)
            }),
            lblTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for model: NetworkModels.NotificationPreference) {
        notificationPreference = model
        initSwitch()
    }

    func refreshNotificationStatus() {
        /*
        Service.getNotificationManager()?.getNotificationPermissionStatus {[weak self] (status) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch status {
                case .notDetermined:
                    self.initActionButton(withTitle: Localization.Profile.askNotificationPermission.local)
                case .denied:
                    self.initActionButton(withTitle: Localization.Profile.goToSettings.local)
                default:
                    self.initSwitch()
                }
            }
        }
        */
    }

    func initActionButton(withTitle title: String) {
        preferenceSwitch.removeFromSuperview()

        if pushActionButton.superview == nil {
            contentView.addSubview(pushActionButton)
            NSLayoutConstraint.activate([
                pushActionButton.leadingAnchor.constraint(equalTo: lblTitle.trailingAnchor, constant: 16),
                pushActionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                pushActionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }

        pushActionButton.setTitle(title, for: .normal)
    }

    func initSwitch() {
        pushActionButton.removeFromSuperview()

        if preferenceSwitch.superview == nil {
            contentView.addSubview(self.preferenceSwitch)
            NSLayoutConstraint.activate([
                preferenceSwitch.leadingAnchor.constraint(equalTo: lblTitle.trailingAnchor, constant: 16),
                preferenceSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                preferenceSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    }

    @objc func onTapActionButton(_ sender: UIButton) {
        if sender.title(for: .normal) == Localization.Profile.goToSettings.local {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        } else {
            ***REMOVED***Service.getNotificationManager()?.apnRegister()
        }
    }

    @objc func onSwitchStateChanged() {
        guard let preferenceModel = notificationPreference else { return }

***REMOVED***        ***REMOVED***Service.getTabbarController()?.view.setLoadingState(show: true)

        Service.getAPI()?.updateNotificationPreference(groupId: preferenceModel.id, channel: preferenceModel.channel.rawValue, accepted: preferenceSwitch.isOn) {[weak self] (result) in
            guard let self = self else { return }
            ***REMOVED***defer { Service.getTabbarController()?.view.setLoadingState(show: false) }
            switch result {
            case .success(_):
                self.onSwitchChanged?(self.preferenceSwitch.isOn)
                break
            case .failure(let error):
                Service.getPopupManager()?.showErrorMessage(error)
                self.preferenceSwitch.setOn(!self.preferenceSwitch.isOn, animated: true)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
