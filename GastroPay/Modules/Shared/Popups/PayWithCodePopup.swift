import Then
import UIKit
import SnapKit

public class PayWithCodePopup: UIView, MIPopupView {
    
    public var dialogId: String
    
    public var paymentCode: String?

    public var actionCallback: ((_ paymentCode: String?) -> Void)?

    public var willHideCallback: (() -> Void)?
    
    public var errorOccured: ((String) -> Void)?
    
    public let progressIndicatior: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge).then { (make) in
        make.hidesWhenStopped = true
    }

    let artwork = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.PopupArtworks.line
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PopupDialog.title
        $0.textAlignment = .center
        $0.textColor = ColorHelper.PopupDialog.titleText
        $0.numberOfLines = 0
        $0.backgroundColor = .clear
    }
    
    let errorLbl = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PopupDialog.title
        $0.textAlignment = .center
        $0.textColor = UIColor.red
        $0.numberOfLines = 0
        $0.backgroundColor = .clear
    }

    let actionButton = UIButton().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle("", for: .normal)
            $0.backgroundColor = ColorHelper.Button.backgroundColorDisabled
            $0.setTitleColor(ColorHelper.PopupDialog.actionButtonText, for: .normal)
            $0.titleLabel?.font = FontHelper.PopupDialog.actionButton
            $0.isEnabled = false
    }

    let closeButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(ImageHelper.Icons.close, for: .normal)
        $0.imageView?.tintColor = .black
        $0.isHidden = true
    }
    
    let digitInput = DigitInputView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfDigits = 8
        $0.bottomBorderColor = UIColor(red: 236 / 255, green: 236 / 255, blue: 236 / 255, alpha: 1.0)
        $0.nextDigitBottomBorderColor = UIColor(red: 39 / 255, green: 60 / 255, blue: 47 / 255, alpha: 1.0)
        $0.textColor = UIColor(red: 39 / 255, green: 60 / 255, blue: 47 / 255, alpha: 1.0)
        $0.acceptableCharacters = "0123456789"
        $0.keyboardType = .decimalPad
        ***REMOVED***digitInput.font = UIFont.monospacedDigitSystemFont(ofSize: 10, weight: UIFont.Weight(rawValue: 1))
        $0.animationType = .spring
    }

    init(paymentCode: String? = nil, dialogId: String, title: String?, buttonTitle: String?) {
        self.dialogId = dialogId
        
        super.init(frame: .zero)
        
        if let paymentCode = paymentCode{
            self.paymentCode = paymentCode
            onTapActionButton()
            return
        }
        
        if let titleText = title {
            titleLabel.text = titleText
        }
        
        if let buttonTitle = buttonTitle{
            actionButton.setTitle(buttonTitle, for: .normal)
        }

        backgroundColor = .white

        closeButton.addTarget(self, action: #selector(onTapCloseButton), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(onTapActionButton), for: .touchUpInside)

        addSubview(artwork)
        addSubview(closeButton)
        addSubview(actionButton)
        addSubview(titleLabel)
        addSubview(digitInput)
        addSubview(errorLbl)
        addSubview(progressIndicatior)
        
        digitInput.delegate = self

        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        artwork.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(5)
            make.left.equalToSuperview().offset(120)
            make.right.equalToSuperview().offset(-120)
        }

        titleLabel.topAnchor.constraint(equalTo: artwork.bottomAnchor, constant: 38).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        digitInput.snp.remakeConstraints { (make) in
            make.height.equalTo(30)
            make.top.equalTo(titleLabel.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        
        
        errorLbl.snp.makeConstraints { (make) in
            make.top.equalTo(digitInput.snp.bottom).offset(20)
            make.left.equalTo(digitInput.snp.left)
            make.right.equalToSuperview().offset(-10)
        }

        actionButton.topAnchor.constraint(equalTo: errorLbl.bottomAnchor, constant: 20).isActive = true
        actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        
        progressIndicatior.snp.makeConstraints { (make) in
            make.center.equalTo(actionButton.snp.center)
        }
        
        _ = digitInput.becomeFirstResponder()
        
        MIServiceBus.onMainThread(self, name: MIEventHelper.ErrorOccuredWhenPayWithCode) { (notification) in
            
            if let userInfo = notification?.userInfo, let errorMessage = userInfo["errorMessage"] as? String {
                self.errorLbl.text = errorMessage
            }
            
            self.actionButtonEnableStateChange(isEnabled: true)
            
            self.progressIndicatior.stopAnimating()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        actionButton.layer.cornerRadius = actionButton.frame.height / 2
    }

    @objc func onTapCloseButton() {
        Service.getPopupManager()?.hideDialog(self)
        willHideCallback?()
    }

    @objc func onTapActionButton() {
        errorLbl.text = ""
        codeEntered()
        ***REMOVED***Service.getPopupManager().hideDialog(self)
    }

    public func popupWillBeHidden() {
        willHideCallback?()
    }
}

extension PayWithCodePopup {
    func codeEntered(){
        if !progressIndicatior.isAnimating{
            progressIndicatior.startAnimating()
            actionButtonEnableStateChange(isEnabled: false)
            actionCallback?(self.paymentCode)
        }
    }
}

extension PayWithCodePopup: DigitInputViewDelegate {

    public func digitsDidChange(digitInputView: DigitInputView) {
        let code = digitInputView.text

        self.paymentCode = code

        if code.count >= 8 {
            actionButtonEnableStateChange(isEnabled: true)
        }
        
        else{
            actionButtonEnableStateChange(isEnabled: false)
        }
    }

}

extension PayWithCodePopup{
    func actionButtonEnableStateChange(isEnabled: Bool){
        if isEnabled{
            self.actionButton.backgroundColor = ColorHelper.Button.backgroundColor
            self.actionButton.isEnabled = true
        }
        else{
            self.actionButton.backgroundColor = ColorHelper.Button.backgroundColorDisabled
            self.actionButton.isEnabled = false
        }
    }
}

