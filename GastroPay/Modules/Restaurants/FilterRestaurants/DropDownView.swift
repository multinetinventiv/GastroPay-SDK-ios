***REMOVED***
***REMOVED***  DropDownView.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***

import Foundation
import UIKit

class DropDownView: UIView {
    private let titleTextField = PickerTextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.Restaurants.Search.cityTagTitle
        $0.textColor = ColorHelper.RestaurantSearch.cityTitle
        $0.textAlignment = .left
    }
    
    private let imageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.image = ImageHelper.General.dropDownIcon
    }
    
    var placeholder = "Placeholder" {
        didSet {
            titleTextField.text = placeholder
        }
    }
    
    var selectedIndexChanged: Bool = false
    var selectedIndex: Int = 0 {
        didSet {
            pickerView.reloadAllComponents()
            pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
            titleTextField.text = items[safeIndex:selectedIndex]
        }
    }
    var items = [String]() {
        didSet {
            items.insert(placeholder, at: 0)
            selectedIndex = 0
        }
    }

    var toolBar = UIToolbar()
    var pickerView  = UIPickerView()
    var onSelectedIndexChanged: ((Int)->())?

    init() {
        super.init(frame: .zero)
        
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = ColorHelper.RestaurantSearch.cityBorder.cgColor
        
        addSubview(titleTextField)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -10),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),

            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            imageView.widthAnchor.constraint(equalToConstant: 6.72),
            imageView.heightAnchor.constraint(equalToConstant: 9.52)
        ])
                
        createPickerView()
        titleTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUserInteractionEnabled(isEnabled: Bool) {
        self.isUserInteractionEnabled = isEnabled
        self.titleTextField.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func createPickerView() {
        pickerView = UIPickerView.init()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        pickerView.autoresizingMask = .flexibleWidth
        pickerView.contentMode = .center
        pickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.backgroundColor = UIColor.white
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem.init(title: Localization.General.keyboardDoneButton.local, style: .done, target: self, action: #selector(onDoneButtonTapped))
        toolBar.items = [flexibleSpace, doneButton]
        
        titleTextField.inputView = pickerView
        titleTextField.inputAccessoryView = toolBar
    }
    
    @objc func onDoneButtonTapped() {
        endEditing(true)
    }
}

extension DropDownView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width-10, height: 30))
        label.lineBreakMode = .byWordWrapping;
        label.textAlignment = .center
        label.numberOfLines = 0;
        label.text = items[safeIndex:row] ?? nil
        label.sizeToFit()
        return label;
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedIndex != row {
            selectedIndex = row
            selectedIndexChanged = true
            
            titleTextField.text = items[safeIndex:row]
        }
    }
}

extension DropDownView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if selectedIndexChanged {
            onSelectedIndexChanged?(selectedIndex)

            selectedIndexChanged = false
        }
    }
}

public class PickerTextField: UITextField {
    public override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
    public override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
            action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
