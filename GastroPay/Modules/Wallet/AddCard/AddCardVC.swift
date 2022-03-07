//
//  AddCardVC.swift
//  Wallet
//
//  Created by Emrah Multinet on 9.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Then
import YPNavigationBarTransition

public class AddCardVC: MIStackableViewController, NavigationBarConfigureStyle{
    public var viewModel: AddCardViewModel

    var creditCardCampaigns: [Campaign]? {
        didSet {
            campaignPageControl.numberOfPages = self.creditCardCampaigns?.count ?? 0
        }
    }
    
    
    public init(with viewModel: AddCardViewModel){
        self.viewModel = viewModel
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        .backgroundStyleTransparent
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        .black
    }
    
    private var currentPage: Int = 0 {
        didSet{
            campaignPageControl.currentPage = currentPage
        }
    }
    
    
    // MARK: - Variables
    private var textFieldHeight: CGFloat{
        return viewModel.textFieldHeight
    }
    
    // MARK: - TextFields
    private var cardPlaceholderController: MITextFieldControllerOutlined!
    lazy var cardPlaceholderTextField = MITextField().then {
        $0.addTarget(self, action: #selector(textFieldHasChanged(_:)), for: .editingChanged)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = viewModel.cardOwnerPlaceholder
        $0.keyboardType = viewModel.cardOwnerKeyboardType
        $0.font = viewModel.textFieldFont
    }
    
        
    private var cardNumberController: MITextFieldControllerOutlined!
    lazy var cardNumberTextField = MITextField().then {
        $0.addTarget(self, action: #selector(textFieldHasChanged(_:)), for: .editingChanged)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.keyboardType = viewModel.cardNumberKeyboardType
        $0.placeholder = viewModel.cardNumberPlaceholder
        $0.font = viewModel.textFieldFont
        $0.inputType = .cardNumber
    }
    
    private var expirationDateController: MITextFieldControllerOutlined!
    lazy var expirationDateTextField = MITextField().then {
        $0.addTarget(self, action: #selector(textFieldHasChanged(_:)), for: .editingChanged)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.keyboardType = viewModel.expDateKeyboardType
        $0.placeholderLabel.minimumScaleFactor = 0.96
        $0.placeholder = viewModel.expDatePlaceholder
        $0.font = viewModel.textFieldFont
        $0.inputType = .expirationDate
    }
    
    private var cvvController: MITextFieldControllerOutlined!
    lazy var cvvTextField = MITextField().then{
        $0.addTarget(self, action: #selector(textFieldHasChanged(_:)), for: .editingChanged)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.keyboardType = viewModel.cvvKeyboardType
        $0.placeholder = viewModel.cvvPlaceholder
        $0.delegate = self
    }
    
    private lazy var cardInformationContainerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubview(cvvTextField)
        $0.addSubview(expirationDateTextField)

        expirationDateTextField.topAnchor.constraint(equalTo: $0.topAnchor).isActive = true
        expirationDateTextField.leadingAnchor.constraint(equalTo: $0.leadingAnchor).isActive = true
        expirationDateTextField.widthAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 0.6, constant: -5).isActive = true
        expirationDateTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true

        cvvTextField.topAnchor.constraint(equalTo: $0.topAnchor).isActive = true
        cvvTextField.trailingAnchor.constraint(equalTo: $0.trailingAnchor).isActive = true
        cvvTextField.widthAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 0.4, constant: -5).isActive = true
        cvvTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true

    }
    
    private var cardAliasController: MITextFieldControllerOutlined!
    lazy var cardAliasTextField = MITextField().then{
        $0.addTarget(self, action: #selector(textFieldHasChanged(_:)), for: .editingChanged)
        $0.placeholderLabel.font = FontHelper.Wallet.AddCard.title
        $0.keyboardType = viewModel.cardAliasKeyboardType
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = viewModel.cardAliasPlaceholder
    }
    
    
    private var addCardButtonBottomConstraint: NSLayoutConstraint!
    public lazy var addCardButton = UIButton().then {
        
        $0.setTitleColor(ColorHelper.Wallet.AddCard.Button.disabledTextColor, for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(addCardClicked(_:)), for: UIControl.Event.touchUpInside)
        $0.backgroundColor = ColorHelper.Wallet.AddCard.Button.backgroundDisabled
        $0.titleLabel?.font = FontHelper.Wallet.AddCard.buttonText
        $0.setTitle(viewModel.submitButtonTitle, for: UIControl.State.normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 24.0
        $0.isEnabled = false
    }
    
    private var collectionViewLayout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var campaignCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout).then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(CreditCardCompactCell.self)
        $0.backgroundColor = .clear
        $0.isPagingEnabled = true
        $0.dataSource = self
        $0.delegate = self
    }
    
    
    public var campaignPageControl = UIPageControl().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.pageIndicatorTintColor = ColorHelper.Wallet.AddCard.pageControlNotSelected
        $0.currentPageIndicatorTintColor = ColorHelper.Wallet.AddCard.pageControlSelected
    }

    var serviceCallLock = NSLock()
    
    @objc private func addCardClicked(_ sender: UIButton){
        self.view.endEditing(true)
        
        setLoadingState(show: true)
        
        let expirationComponents = viewModel.expDate.split(separator: "/")
        let expirationMonth = expirationComponents[0]
        let expirationYear = expirationComponents[1]

        guard serviceCallLock.try() else { return }

        Service.getAPI()?.addCreditCard(cardHolderName: viewModel.cardOwner,
                                       cardNumber: viewModel.cardNumber,
                                       cardExpMonth: String(expirationMonth),
                                       cardExpYear: String(expirationYear),
                                       cardCvv: viewModel.cvv,
                                       cardAlias: viewModel.cardAlias) {[weak self] (result) in
            guard let self = self else { return }
            defer { self.setLoadingState(show: false) }
            defer { self.serviceCallLock.unlock() }
            
            switch result{
            case .success(let creditCard):
                if self.viewModel.showSuccessPopup {
                    self.viewModel.onSuccessBeforePopupPresent?(creditCard)
                    Service.getPopupManager()?.openAddCardSuccessPopup(actionCallback: self.viewModel.onSuccessPopupAction, willHideCallback: self.viewModel.successPopupWillHide)
                } else {
                    self.viewModel.onSuccess?(creditCard)
                }
            case .failure( _):
                Service.getPopupManager()?.openAddCardErrorPopup()
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        Service.getAPI()?.getCampaigns(campaignType: .creditCard) {[weak self] (result) in
            switch result {
            case .success(let campaigns):
                self?.creditCardCampaigns = campaigns
                self?.campaignCollectionView.reloadData()
            case .failure(let error):
                Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
            }
        }
        
        animateWithKeyboard { keyboardHeight in
            
            var safeAreaInsetBottom: CGFloat = 0.0
            
            if #available(iOS 11.0, *) {
                safeAreaInsetBottom = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
            }
            
            self.stackViewBottomConstraint.constant = -keyboardHeight - self.addCardButton.frame.height - 32
            self.addCardButtonBottomConstraint.constant = -keyboardHeight - 16 + safeAreaInsetBottom
            self.view.layoutIfNeeded()
        }
        
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if navigationController?.viewControllers.first == self {
            let barButtonItem = UIBarButtonItem(image: viewModel.navigationDismissIcon, style: .done, target: self, action: #selector(tappedDismiss(_:)))
            barButtonItem.tintColor = viewModel.navigationDismissIconTintColor
            navigationItem.leftBarButtonItem = barButtonItem
        } else {
            let backImage = ImageHelper.Icons.backArrow
            self.navigationController?.navigationBar.backIndicatorImage = backImage
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        }
    }
    
    
    private func setUI(){
        view.backgroundColor = viewModel.viewBackgroundColor
        self.stackView.backgroundColor = viewModel.viewBackgroundColor
        navigationItem.title = viewModel.navigationTitle

        cardPlaceholderController = MITextFieldControllerOutlined(textInput: cardPlaceholderTextField)
        cardNumberController = MITextFieldControllerOutlined(textInput: cardNumberTextField)
        expirationDateController = MITextFieldControllerOutlined(textInput: expirationDateTextField)
        cvvController = MITextFieldControllerOutlined(textInput: cvvTextField)
        cardAliasController = MITextFieldControllerOutlined(textInput: cardAliasTextField)

        stackView.addRows([cardPlaceholderTextField,
                           cardNumberTextField,
                           cardInformationContainerView,
                           cardAliasTextField,
                           campaignCollectionView,
                           campaignPageControl
                            ])

        stackView.setInset(forRow: cardPlaceholderTextField, inset: .init(top: 15, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: cardNumberTextField, inset: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: cardInformationContainerView, inset: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: cardAliasTextField, inset: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: campaignCollectionView, inset: .init(top: 8, left: 0, bottom: 0, right: 0))
        stackView.setInset(forRow: campaignPageControl, inset: .init(top: 8, left: 0, bottom: 0, right: 0))

        cardInformationContainerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        campaignCollectionView.heightAnchor.constraint(equalToConstant: 78).isActive = true

        view.addSubview(addCardButton)
        if #available(iOS 11.0, *) {
            addCardButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            addCardButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
            addCardButtonBottomConstraint = addCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        } else {
            addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            addCardButtonBottomConstraint = addCardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        }
        addCardButtonBottomConstraint.isActive = true
        addCardButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    @objc func tappedDismiss(_ sender: UIBarButtonItem){
        if let action = self.viewModel.onSuccessPopupAction{
            action()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private static var collectionViewHeight: CGFloat {
        return 78.0
    }
    
    private static var collectionViewCellIdentifier: String {
        return "CreditCardCompactCell"
    }
    
    @objc public func textFieldHasChanged(_ sender: UITextField){
        
        let text = sender.text
        
        if sender == cardPlaceholderTextField{
            viewModel.cardOwner = text
        }else if sender == cardNumberTextField{
            viewModel.cardNumber = text
        }else if sender == expirationDateTextField{
            viewModel.expDate = text
        }else if sender == cvvTextField{
            viewModel.cvv = text
        }else if sender == cardAliasTextField{
            viewModel.cardAlias = text
        }
        

        if self.isFormValid(){

            addCardButton.isEnabled = true
            addCardButton.backgroundColor = ColorHelper.Wallet.AddCard.Button.backgroundActive
            return
        }

           addCardButton.isEnabled = false
           addCardButton.backgroundColor = ColorHelper.Wallet.AddCard.Button.backgroundDisabled

        }
}
                
extension AddCardVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.creditCardCampaigns?.count ?? 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CreditCardCompactCell.self, for: indexPath)
        if let campaign = self.creditCardCampaigns?[indexPath.item] {
            cell.configure(campaign: campaign)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: AddCardVC.collectionViewHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
}

extension AddCardVC: UIScrollViewDelegate{
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let screenWidth = view.frame.width
        
        let value = scrollView.contentOffset.x

        switch value {
        case _ where value < screenWidth:
            currentPage = 0
        default:
            let _currentPage = value / screenWidth
            self.currentPage = Int(_currentPage)
        }
    }
    
}


// MARK: - This will change because there is not validator class for textfield types in GastroPay
protocol AdditionalMITextFieldValidators{
    func isFormValid() -> Bool
}

extension AddCardVC: AdditionalMITextFieldValidators {
    
    func isFormValid() -> Bool {
        
        guard let cardPlaceholderText   = cardPlaceholderTextField.text,
            let cardNumberText          = cardNumberTextField.text,
            let expirationText          = expirationDateTextField.text,
            let cvvText                 = cvvTextField.text,
            let cardAliasText        = cardAliasTextField.text  else {
                return false
        }
            
        return cardPlaceholderText.count >= 5  &&
                cardNumberText.count == 19  &&
                expirationText.count == 5   &&
                cvvText.count >= 3  && cvvText.count <= 4 &&
                cardAliasText.count >= 4
        
    }
    
}

extension AddCardVC: UITextFieldDelegate{

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let _ = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        
        if textField == cvvTextField{
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 4
        }
        
        return true
    }
}
