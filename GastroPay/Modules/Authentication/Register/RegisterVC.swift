//
//  RegisterVC.swift
//  Alamofire
//
//  Created by  on 16.12.2019.
//

import UIKit

import NotificationCenter
import Then

import YPNavigationBarTransition

import MaterialComponents.MaterialTextFields

public class RegisterVC: MIStackableViewController, NavigationBarConfigureStyle {
    public var viewModel: RegisterVM
    private var isUserAgreementsApproved = false

    let labelWelcome = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }

    let labelWelcomeInfo = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }

    var nameInputController: MITextFieldControllerOutlined!
    let nameInput = MITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.allowedCharacters = .coupleName
    }

    var surnameInputController: MITextFieldControllerOutlined!
    let surnameInput = MITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.allowedCharacters = .coupleName
    }

    var phoneInputController: MITextFieldControllerOutlined!
    let phoneInput = MITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.inputType = .phone
        $0.keyboardType = .phonePad
        $0.allowedCharacters = .digit
    }

    var emailInputController: MITextFieldControllerOutlined!
    let emailInput = MITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.inputType = .email
        $0.keyboardType = .emailAddress
    }
    
    var davetiyeInputController: MITextFieldControllerOutlined!
    let davetiyeInput = MITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.inputType = .email
        $0.keyboardType = .phonePad
    }

    let checkBoxPrivacy = MICheckBox().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let checkBoxPrivacyLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }
    
    let checkBoxGdpr = MICheckBox().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let checkBoxGdprLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }

    let checkBoxContactPermission = MICheckBox().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let checkBoxContactPermissionLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }

    var registerButtonBottomConstraint: NSLayoutConstraint!
    let registerButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .showShadowImage
    }

    public func yp_navigationBarTintColor() -> UIColor! {
        return .black
    }

    public func yp_navigationBackgroundColor() -> UIColor! {
        return .white
    }

    public init(viewModel: RegisterVM) {
        self.viewModel = viewModel
        super.init(bottomOffset: -82)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initViews() {
        labelWelcome.text = viewModel.welcomeText
        labelWelcome.textColor = viewModel.welcomeTextColor
        labelWelcome.font = viewModel.welcomeFont

        labelWelcomeInfo.text = viewModel.welcomeInfoText
        labelWelcomeInfo.textColor = viewModel.welcomeInfoTextColor
        labelWelcomeInfo.font = viewModel.welcomeInfoFont

        nameInput.placeholder = viewModel.nameInputPlaceholder
        surnameInput.placeholder = viewModel.surnameInputPlaceholder
        phoneInput.placeholder = viewModel.phoneInputPlaceholder
        emailInput.placeholder = viewModel.emailInputPlaceholder
        davetiyeInput.placeholder = viewModel.davetiyeInputPlaceholder

        checkBoxPrivacy.checkmarkColor = viewModel.checkboxMarkColor
        checkBoxPrivacy.checkedBorderColor = viewModel.checkboxActiveBorderColor
        checkBoxPrivacy.uncheckedBorderColor = viewModel.checkboxBorderColor
        checkBoxPrivacy.style = viewModel.checkboxStyle
        checkBoxPrivacy.borderStyle = viewModel.checkboxBorderStyle
        checkBoxPrivacy.isUserInteractionEnabled = true
        checkBoxPrivacyLabel.text = viewModel.checkboxPrivacyLabelText
        checkBoxPrivacyLabel.textColor = viewModel.checkboxLabelTextColor
        checkBoxPrivacyLabel.font = viewModel.checkboxLabelFont

        let privacyAttributedString = NSMutableAttributedString(string: viewModel.checkboxPrivacyLabelText)
        let privacyLinkRange = viewModel.checkboxPrivacyLabelText.range(of: viewModel.checkboxPrivacyLabelLinkSubstring)!
        privacyAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyLinkRange.nsRange)
        checkBoxPrivacyLabel.attributedText = privacyAttributedString
        
        checkBoxGdpr.checkmarkColor = viewModel.checkboxMarkColor
        checkBoxGdpr.checkedBorderColor = viewModel.checkboxActiveBorderColor
        checkBoxGdpr.uncheckedBorderColor = viewModel.checkboxBorderColor
        checkBoxGdpr.style = viewModel.checkboxStyle
        checkBoxGdpr.borderStyle = viewModel.checkboxBorderStyle
        checkBoxGdpr.isUserInteractionEnabled = true
        checkBoxGdprLabel.text = viewModel.checkboxPrivacyLabelText
        checkBoxGdprLabel.textColor = viewModel.checkboxLabelTextColor
        checkBoxGdprLabel.font = viewModel.checkboxLabelFont

        let gdprAttributedString = NSMutableAttributedString(string: viewModel.checkboxGdprLabelText)
        let clarificationTextLinkRange = viewModel.checkboxGdprLabelText.range(of: viewModel.checkboxGdprLabelLinkSubstring1)!
        let explicitConsentLinkRange = viewModel.checkboxGdprLabelText.range(of: viewModel.checkboxGdprLabelLinkSubstring2)!
        gdprAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: clarificationTextLinkRange.nsRange)
        gdprAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: explicitConsentLinkRange.nsRange)
        checkBoxGdprLabel.attributedText = gdprAttributedString
        
        checkBoxContactPermission.checkmarkColor = viewModel.checkboxMarkColor
        checkBoxContactPermission.checkedBorderColor = viewModel.checkboxActiveBorderColor
        checkBoxContactPermission.uncheckedBorderColor = viewModel.checkboxBorderColor
        checkBoxContactPermission.style = viewModel.checkboxStyle
        checkBoxContactPermission.borderStyle = viewModel.checkboxBorderStyle
        checkBoxContactPermissionLabel.textColor = viewModel.checkboxLabelTextColor
        checkBoxContactPermissionLabel.font = viewModel.checkboxLabelFont
        checkBoxContactPermissionLabel.text = viewModel.checkboxContactPermissionText

        registerButton.setTitle(viewModel.registerButtonText, for: .normal)
        registerButton.backgroundColor = viewModel.registerButtonDisabledBackgroundColor
        registerButton.setTitleColor(viewModel.registerButtonActiveTextColor, for: .normal)
        registerButton.setTitleColor(viewModel.registerButtonDisabledTextColor, for: .disabled)
        registerButton.isEnabled = false
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        if viewModel.showCloseIcon {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: viewModel.closeIconForNavigationRoot, style: .done, target: self, action: #selector(tappedClose))
        } else {
            navigationController?.navigationBar.backIndicatorImage = viewModel.backIconForNavigation
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = viewModel.backIconForNavigation
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Giriş Yap", style: .plain, target: self, action: #selector(onTapLogin))
        navigationItem.title = "ÜYE OL"

        nameInput.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        nameInputController = MITextFieldControllerOutlined(textInput: nameInput)

        surnameInput.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        surnameInputController = MITextFieldControllerOutlined(textInput: surnameInput)

        phoneInput.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        phoneInputController = MITextFieldControllerOutlined(textInput: phoneInput)

        emailInput.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        emailInputController = MITextFieldControllerOutlined(textInput: emailInput)

        davetiyeInput.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        davetiyeInputController = MITextFieldControllerOutlined(textInput: davetiyeInput)
        
        let nameSurnameContainer = UIView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addSubview(nameInput)
            $0.addSubview(surnameInput)
            NSLayoutConstraint.activate([
                nameInput.leadingAnchor.constraint(equalTo: $0.leadingAnchor),
                nameInput.widthAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 1/2, constant: -8),
                nameInput.topAnchor.constraint(equalTo: $0.topAnchor),
                nameInput.bottomAnchor.constraint(equalTo: $0.bottomAnchor),

                surnameInput.leadingAnchor.constraint(equalTo: nameInput.trailingAnchor, constant: 16),
                surnameInput.trailingAnchor.constraint(equalTo: $0.trailingAnchor),
                surnameInput.topAnchor.constraint(equalTo: $0.topAnchor),
                surnameInput.bottomAnchor.constraint(equalTo: $0.bottomAnchor),
            ])
        }

        checkBoxPrivacy.addTarget(self, action: #selector(checkBoxPrivacyChanged), for: .valueChanged)
        let privacyCheckboxContainer = createContainerForCheckboxAndLabel(checkBox: checkBoxPrivacy, label: checkBoxPrivacyLabel)
        let privacyTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapPrivacyLabel(recognizer:)))
        checkBoxPrivacyLabel.addGestureRecognizer(privacyTapRecognizer)
        checkBoxPrivacyLabel.isUserInteractionEnabled = true
        checkBoxGdpr.addTarget(self, action: #selector(validateForm), for: .valueChanged)
        let checkBoxGdprContainer = createContainerForCheckboxAndLabel(checkBox: checkBoxGdpr, label: checkBoxGdprLabel)
        let GdprTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapPrivacyLabel(recognizer:)))
        checkBoxGdprLabel.addGestureRecognizer(GdprTapRecognizer)
        checkBoxGdprLabel.isUserInteractionEnabled = true
        checkBoxContactPermission.addTarget(self, action: #selector(validateForm), for: .valueChanged)
        let contactConsentContainer = createContainerForCheckboxAndLabel(checkBox: checkBoxContactPermission, label: checkBoxContactPermissionLabel)

        stackView.addRows([
            labelWelcome, labelWelcomeInfo, nameSurnameContainer,
            phoneInput, emailInput, davetiyeInput,
            privacyCheckboxContainer, checkBoxGdprContainer, contactConsentContainer
        ])

        stackView.setInset(forRow: labelWelcome, inset: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: labelWelcomeInfo, inset: UIEdgeInsets(top: 4, left: 16, bottom: 16, right: 16))
        stackView.setInset(forRow: nameSurnameContainer, inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: phoneInput, inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: emailInput, inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: davetiyeInput, inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: privacyCheckboxContainer, inset: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: checkBoxGdprContainer, inset: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: contactConsentContainer, inset: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))

        view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(onTapRegister), for: .touchUpInside)
        if #available(iOS 11.0, *) {
            registerButtonBottomConstraint = registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            NSLayoutConstraint.activate([
                registerButtonBottomConstraint,
                registerButton.heightAnchor.constraint(equalToConstant: 50),
                registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            ])
        } else {
            registerButtonBottomConstraint = registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            NSLayoutConstraint.activate([
                registerButtonBottomConstraint,
                registerButton.heightAnchor.constraint(equalToConstant: 50),
                registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        }

        animateWithKeyboard { keyboardHeight in
            self.stackViewBottomConstraint.constant = -keyboardHeight - self.registerButton.frame.height - 32
            self.registerButtonBottomConstraint.constant = -keyboardHeight - 16
            self.view.layoutIfNeeded()
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(false)
    }

    func createContainerForCheckboxAndLabel(checkBox: MICheckBox, label: UILabel) -> UIView {
        return UIView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addSubview(checkBox)
            $0.addSubview(label)
            NSLayoutConstraint.activate([
                checkBox.leadingAnchor.constraint(equalTo: $0.leadingAnchor),
                checkBox.topAnchor.constraint(equalTo: $0.topAnchor, constant: 1),
                checkBox.bottomAnchor.constraint(lessThanOrEqualTo: $0.bottomAnchor),
                checkBox.heightAnchor.constraint(equalToConstant: 20),
                checkBox.widthAnchor.constraint(equalToConstant: 20),

                label.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 8),
                label.trailingAnchor.constraint(equalTo: $0.trailingAnchor),
                label.topAnchor.constraint(equalTo: $0.topAnchor),
                label.bottomAnchor.constraint(lessThanOrEqualTo: $0.bottomAnchor),
            ])
        }
    }
    
    @objc func checkBoxPrivacyChanged() {
        if self.isUserAgreementsApproved{
            validateForm()
        }
        else if self.checkBoxPrivacy.isChecked{
            self.viewModel.onTapPrivacyLink?()
            self.checkBoxPrivacy.isChecked = false
        }
    }

    @objc func validateForm() {
        var phoneNumberString = (phoneInput.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? ""
        if !phoneNumberString.isEmpty { phoneNumberString.removeFirst() }
        
        viewModel.userName = nameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel.userSurname = surnameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel.userEmail = emailInput.text ?? ""
        viewModel.userPhone = phoneNumberString
        viewModel.userPhoneFormatted = phoneNumberString ?? ""
        viewModel.checkedNotificationConsent = checkBoxContactPermission.isChecked
        viewModel.checkedTermsAndAggreements = checkBoxPrivacy.isChecked
        viewModel.checkedGdpr = checkBoxGdpr.isChecked

        if let code = davetiyeInput.text, code.count > 0{
            viewModel.referrerProfileCode = Int(code)
        }

        guard let userName = nameInput.text, let userSurname = surnameInput.text else {
            return
        }

        let formValid = userName.count >= 3 &&
            userSurname.count >= 2 &&
            emailInput.isInputValid() &&
            phoneInput.isInputValidPhone() &&
            checkBoxPrivacy.isChecked &&
            checkBoxGdpr.isChecked

        registerButton.isEnabled = formValid
        registerButton.backgroundColor = formValid ? viewModel.registerButtonActiveBackgroundColor : viewModel.registerButtonDisabledBackgroundColor
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        registerButton.layer.cornerRadius = registerButton.frame.size.height / 2
    }

    @objc func tappedClose() {
        self.dismiss(animated: true)
    }

    @objc func onTapRegister() {
        viewModel.onTapRegister?(viewModel)
    }

    @objc func onTapLogin() {
        viewModel.onTapLogin?()
    }

    @objc func onTapPrivacyLabel(recognizer: UITapGestureRecognizer) {
        let privacyLinkrange = self.checkBoxPrivacyLabel.text?.range(of: viewModel.checkboxPrivacyLabelLinkSubstring)?.nsRange
        let clarificationTextLinkRange = self.checkBoxGdprLabel.text?.range(of: viewModel.checkboxGdprLabelLinkSubstring1)?.nsRange
        let explicitConsentLinkRange = self.checkBoxGdprLabel.text?.range(of: viewModel.checkboxGdprLabelLinkSubstring2)?.nsRange

        if let range = privacyLinkrange, recognizer.didTapAttributedTextRangeInLabel(label: self.checkBoxPrivacyLabel, inRange: range) {
            self.viewModel.onTapPrivacyLink?()
        }
        
        if let range = clarificationTextLinkRange, recognizer.didTapAttributedTextRangeInLabel(label: self.checkBoxGdprLabel, inRange: range) {
            self.viewModel.onTapClarificationTextLink?()
        }
        
        if let range = explicitConsentLinkRange, recognizer.didTapAttributedTextRangeInLabel(label: self.checkBoxGdprLabel, inRange: range) {
            self.viewModel.onTapExplicitConsentLink?()
        }
    }
}

extension RegisterVC: TermsAndAgreementsProtocol{
    
    public func isuserApprovedConditions(isApproved: Bool) {
        self.isUserAgreementsApproved = isApproved
        if isApproved{
            self.checkBoxPrivacy.isUserInteractionEnabled = true
            self.checkBoxPrivacy.isChecked = true
            self.validateForm()
        }
    }
    
}
