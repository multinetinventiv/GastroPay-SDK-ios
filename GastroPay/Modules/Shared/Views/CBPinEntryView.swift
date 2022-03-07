//
//  CBPinEntryView.swift
//  Shared
//
//  Created by  on 6.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit

public protocol CBPinEntryViewDelegate: AnyObject {
    func entryChanged(_ completed: Bool)
}

public struct CBPinEntryViewDefaults {
    // Default number of fields
    static let length: Int = 4

    // Default spacing between fields
    static let spacing: CGFloat = 20

    // Default backgorund colour of pin entry field
    static let entryBackgroundColour: UIColor = UIColor.white

    // Default border width
    static let entryBorderWidth: CGFloat = 1

    // Default border colour of fields before selection
    static let entryDefaultBorderColour: UIColor = UIColor(red: 210 / 255, green: 215 / 255, blue: 219 / 255, alpha: 1.0)

    // Default border colour of currently editing field
    static let entryBorderColour: UIColor = UIColor(red: 69 / 255, green: 78 / 255, blue: 86 / 255, alpha: 1.0)

    // Default border colour for error state
    static let entryErrorColour: UIColor = UIColor.red

    // Default corner radius of entry fields
    static let entryCornerRadius: CGFloat = 25.0

    // Default text colour for the entry label
    static let entryTextColour: UIColor = .black

    // Default font for entry fields
    static let entryFont: UIFont = UIFont.systemFont(ofSize: 16)

    static let isSecure: Bool = true

    static let secureCharacter: String = "●"

    static let keyboardType: Int = 4
}

open class CBPinEntryView: UIView {
    open var length: Int = CBPinEntryViewDefaults.length

    open var spacing: CGFloat = CBPinEntryViewDefaults.spacing

    open var entryCornerRadius: CGFloat = CBPinEntryViewDefaults.entryCornerRadius {
        didSet {
            if oldValue != entryCornerRadius {
                updateButtonStyles()
            }
        }
    }

    open var entryBorderWidth: CGFloat = CBPinEntryViewDefaults.entryBorderWidth {
        didSet {
            if oldValue != entryBorderWidth {
                updateButtonStyles()
            }
        }
    }

    open var entryDefaultBorderColour: UIColor = CBPinEntryViewDefaults.entryDefaultBorderColour {
        didSet {
            if oldValue != entryDefaultBorderColour {
                updateButtonStyles()
            }
        }
    }

    open var entryBorderColour: UIColor = CBPinEntryViewDefaults.entryBorderColour {
        didSet {
            if oldValue != entryBorderColour {
                updateButtonStyles()
            }
        }
    }

    open var entryErrorBorderColour: UIColor = CBPinEntryViewDefaults.entryErrorColour

    open var entryBackgroundColour: UIColor = CBPinEntryViewDefaults.entryBackgroundColour {
        didSet {
            if oldValue != entryBackgroundColour {
                updateButtonStyles()
            }
        }
    }

    open var entryTextColour: UIColor = CBPinEntryViewDefaults.entryTextColour {
        didSet {
            if oldValue != entryTextColour {
                updateButtonStyles()
            }
        }
    }

    open var entryFont: UIFont = CBPinEntryViewDefaults.entryFont {
        didSet {
            if oldValue != entryFont {
                updateButtonStyles()
            }
        }
    }

    open var isSecure: Bool = CBPinEntryViewDefaults.isSecure

    open var secureCharacter: String = CBPinEntryViewDefaults.secureCharacter

    open var keyboardType: Int = CBPinEntryViewDefaults.keyboardType

    private var stackView: UIStackView?
    private var textField: UITextField!

    fileprivate var errorMode: Bool = false

    fileprivate var entryButtons: [UIButton] = [UIButton]()

    public weak var delegate: CBPinEntryViewDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
    }

    override open func prepareForInterfaceBuilder() {
        commonInit()
    }

    private func commonInit() {
        setupStackView()
        setupTextField()

        createButtons()
    }

    private func setupStackView() {
        stackView = UIStackView(frame: bounds)
        stackView!.alignment = .fill
        stackView!.axis = .horizontal
        stackView!.distribution = .fillEqually
        stackView!.spacing = spacing
        stackView!.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView!)

        // stackView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        // stackView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        stackView!.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        stackView!.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }

    private func setupTextField() {
        textField = UITextField(frame: bounds)
        textField.delegate = self
        textField.keyboardType = UIKeyboardType(rawValue: keyboardType) ?? .numberPad
        textField.addTarget(self, action: #selector(textfieldChanged(_:)), for: .editingChanged)

        addSubview(textField)

        textField.isHidden = true
    }

    private func createButtons() {
        for i in 0..<length {
            let button = UIButton()
            button.backgroundColor = entryBackgroundColour
            button.setTitleColor(entryTextColour, for: .normal)
            button.titleLabel?.font = entryFont

            button.layer.cornerRadius = entryCornerRadius
            button.layer.borderColor = entryDefaultBorderColour.cgColor
            button.layer.borderWidth = entryBorderWidth

            button.tag = i + 1

            button.addTarget(self, action: #selector(didPressCodeButton(_:)), for: .touchUpInside)

            entryButtons.append(button)
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
            stackView?.addArrangedSubview(button)
        }
    }
    
    public func clearAll(){
        textField.text = ""
        for button in entryButtons {
            button.setTitle("", for: UIControl.State.normal)
        }
    }
    
    public func openKeyboard(){
        textField.becomeFirstResponder()
    }

    private func updateButtonStyles() {
        for button in entryButtons {
            button.backgroundColor = entryBackgroundColour
            button.setTitleColor(entryTextColour, for: .normal)
            button.titleLabel?.font = entryFont

            button.layer.cornerRadius = entryCornerRadius
            button.layer.borderColor = entryDefaultBorderColour.cgColor
            button.layer.borderWidth = entryBorderWidth
        }
    }

    @objc private func didPressCodeButton(_ sender: UIButton) {
        errorMode = false

        let entryIndex = textField.text!.count + 1
        for button in entryButtons {
            button.layer.borderColor = entryBorderColour.cgColor

            if button.tag == entryIndex {
                button.layer.borderColor = entryBorderColour.cgColor
            } else {
                button.layer.borderColor = entryDefaultBorderColour.cgColor
            }
        }

        textField.becomeFirstResponder()
    }

    open func toggleError() {
        if !errorMode {
            for button in entryButtons {
                button.layer.borderColor = entryErrorBorderColour.cgColor
                button.layer.borderWidth = entryBorderWidth
            }
        } else {
            for button in entryButtons {
                button.layer.borderColor = entryBorderColour.cgColor
            }
        }

        errorMode = !errorMode
    }

    open func getPinAsInt() -> Int? {
        if let intOutput = Int(textField.text!) {
            return intOutput
        }

        return nil
    }

    open func getPinAsString() -> String {
        return textField.text!
    }

    @discardableResult override open func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()

        if let firstButton = entryButtons.first {
            didPressCodeButton(firstButton)
        }

        return true
    }

    @discardableResult override open func resignFirstResponder() -> Bool {
        super.resignFirstResponder()

        entryButtons.forEach {
            $0.layer.borderColor = entryDefaultBorderColour.cgColor
        }

        return textField.resignFirstResponder()
    }
}

extension CBPinEntryView: UITextFieldDelegate {
    @objc func textfieldChanged(_ textField: UITextField) {
        let complete: Bool = textField.text!.count == length
        delegate?.entryChanged(complete)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorMode = false
        for button in entryButtons {
            button.layer.borderColor = entryBorderColour.cgColor
        }

        let deleting = (range.location == textField.text!.count - 1 && range.length == 1 && string == "")

        if string.count > 0, !Scanner(string: string).scanInt(nil) {
            return false
        }

        let oldLength = textField.text!.count
        let replacementLength = string.count
        let rangeLength = range.length

        let newLength = oldLength - rangeLength + replacementLength

        if !deleting {
            for button in entryButtons {
                if button.tag == newLength {
                    button.layer.borderColor = entryDefaultBorderColour.cgColor
                    UIView.setAnimationsEnabled(false)
                    if !isSecure {
                        button.setTitle(string, for: .normal)
                    } else {
                        button.setTitle(secureCharacter, for: .normal)
                    }
                    UIView.setAnimationsEnabled(true)
                } else if button.tag == newLength + 1 {
                    button.layer.borderColor = entryBorderColour.cgColor
                } else {
                    button.layer.borderColor = entryDefaultBorderColour.cgColor
                }
            }
        } else {
            for button in entryButtons {
                if button.tag == oldLength {
                    button.layer.borderColor = entryBorderColour.cgColor
                    UIView.setAnimationsEnabled(false)
                    button.setTitle("", for: .normal)
                    UIView.setAnimationsEnabled(true)
                } else {
                    button.layer.borderColor = entryDefaultBorderColour.cgColor
                }
            }
        }

        return newLength <= length
    }
}
