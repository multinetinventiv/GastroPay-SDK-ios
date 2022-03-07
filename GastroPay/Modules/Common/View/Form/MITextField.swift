//
//  MITextField.swift
//  Alamofire
//
//  Created by  on 8.12.2019.
//

import MaterialComponents.MaterialTextFields

public enum MITextFieldType {
    case phone
    case email
    case expirationDate
    case cardNumber
}

public enum MITextFieldAllowedCharacters {
    case alphabet
    case digit
    case coupleName
}

public class MITextField: MDCTextField {
    private weak var _delegate: UITextFieldDelegate?

    open override var delegate: UITextFieldDelegate? {
        get {
            return self._delegate
        }
        set {
            self._delegate = newValue
        }
    }

    public var inputType: MITextFieldType?
    public var allowedCharacters: MITextFieldAllowedCharacters?

    open override var text: String? {
        set {
            super.text = self.getFormattedString(newValue ?? "")
            NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
        }
        get {
            return super.text
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        autocorrectionType = .no
        super.delegate = self
    }

    public func isInputValid() -> Bool {
        switch inputType {
        case .phone:
            return NSPredicate(format: "SELF MATCHES %@", #"\([0-9]{3}\)\ [0-9]{3}\ [0-9]{2}\ [0-9]{2}"#).evaluate(with: self.text)
        case .email:
            return isValidEmail(self.text ?? "")
        case .expirationDate:
            return NSPredicate(format: "SELF MATCHES %@",
                               "/'\'b(0[1-9]|1[0-2])'\'/?([0-9]{4}|[0-9]{2})'\'b/").evaluate(with: self.text)
        case .cardNumber:
            return NSPredicate(format: "SELF MATCHES %@",
                               "^([0-9]{4}?){3}([0-9]{4})$").evaluate(with: self.text)
        default:
            return true
        }
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("01234567890() ")
        return text.filter {okayChars.contains($0) }
    }
    
    public func isInputValidPhone() -> Bool {
        var phone = removeSpecialCharsFromString(text: self.text ?? "")
        if phone.first == "0" { phone.removeFirst() }
        return NSPredicate(format: "SELF MATCHES %@", #"\([0-9]{3}\)\ [0-9]{3}\ [0-9]{2}\ [0-9]{2}"#).evaluate(with: phone)
    }

    public func getFormattedString(_ from: String) -> String {
        switch inputType {
        case .phone:
            return StringFormatter.format(text: from, template: "0(5xx~) *x*x*x~ xx~ xx") ?? from
        case .expirationDate:
            return StringFormatter.format(text: from, template: "xx/xx") ?? from
        case .cardNumber:
            return StringFormatter.format(text: from, template: "xxxx xxxx xxxx xxxx") ?? from
        default:
            return from
        }
    }
    
}

extension MITextField: UITextFieldDelegate {

    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range == NSRange(location: 0, length: 0), string == " " {
            return false
        }

        guard let text = text else {
            return false
        }

        guard self._delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true else {
            return false
        }

        let nsText = text as NSString
        var modifiedNSText = nsText.replacingCharacters(in: range, with: string)
        
        modifiedNSText = removeSpecialCharsFromString(text: modifiedNSText)
        
        if modifiedNSText.first == "9" {
            modifiedNSText.removeFirst()
            
        }


        if let allowedCharacters = self.allowedCharacters {
            switch allowedCharacters {
            case .alphabet:
                if NSPredicate(format: "SELF MATCHES %@", #"^\p{L}*$"#).evaluate(with: modifiedNSText) == false {
                    return false
                }
            case .digit:
                if NSPredicate(format: "SELF MATCHES %@", #"[0-9\ \(\)]*"#).evaluate(with: modifiedNSText) == false {
                    return false
                }
            case .coupleName:
                if NSPredicate(format: "SELF MATCHES %@", #"^([\p{L}]*\s?[\p{L}]*)$"#).evaluate(with: modifiedNSText) == false {
                    return false
                }
            default:
                break
            }
        }

        let filteredCharacters = modifiedNSText.filter {
            String($0).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }

        switch inputType {
        case .phone, .expirationDate, .cardNumber:
            textField.text = self.getFormattedString(modifiedNSText)
            sendActions(for: .editingChanged)
            return false
        default:
            return true
        }
    }

    // MARK: UITextfield Delegate
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self._delegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    open func textFieldDidBeginEditing(_ textField: UITextField) {
        self._delegate?.textFieldDidBeginEditing?(textField)
    }

    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self._delegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    open func textFieldDidEndEditing(_ textField: UITextField) {
        self._delegate?.textFieldDidEndEditing?(textField)
    }

    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self._delegate?.textFieldShouldClear?(textField) ?? true
    }

    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self._delegate?.textFieldShouldReturn?(textField) ?? true
    }

}

extension MITextField{
    
    func isValidEmail(_ email: String) -> Bool {
        
        let newRegex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", newRegex)
        return emailPred.evaluate(with: email)
    }
    
}
