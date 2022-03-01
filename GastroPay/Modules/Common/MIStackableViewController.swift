***REMOVED***
***REMOVED***  MIStackableViewController.swift
***REMOVED***  Inventiv+CommonModule
***REMOVED***
***REMOVED***  Created by  on 31.12.2019.
***REMOVED***

import UIKit
import AloeStackView

public class MIStackView: AloeStackView {

    public override init() {
        super.init()

    }

    public override func cellForRow(_ row: UIView) -> StackViewCell {
        let stackViewCell = StackViewCell(contentView: row)
        
        stackViewCell.clipsToBounds = false
        return stackViewCell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setRowSkeletonable(row: UIView, isSkeletonable: Bool) {
        (row.superview as? StackViewCell)?.isSkeletonable = isSkeletonable
    }
}

open class MIStackableView: UIView{
    
    public var stackViewBottomConstraint: NSLayoutConstraint!
    public var stackView: MIStackView = {
        let stackView = MIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.hidesSeparatorsByDefault = true
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    public init() {
        super.init(frame: .zero)
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            ***REMOVED*** Fallback on earlier versions
        }
        initStackView()
        
    }

    public init(stackViewTopConstraintToSafeArea: Bool = true, bottomOffset: CGFloat = 0) {
        super.init(frame: .zero)
        initStackView(topSafeConstraint: stackViewTopConstraintToSafeArea, bottomOffset: bottomOffset)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initStackView(topSafeConstraint: Bool = true, bottomOffset: CGFloat = 0) {
        self.addSubview(stackView)
        if #available(iOS 11.0, *) {
            stackView.topAnchor.constraint(equalTo: topSafeConstraint ? self.safeAreaLayoutGuide.topAnchor : self.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
            stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: bottomOffset)
        } else {
            stackView.topAnchor.constraint(equalTo: topSafeConstraint ? self.topAnchor : self.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomOffset)
        }
        stackViewBottomConstraint.isActive = true
        stackView.layer.zPosition = -1
        self.sendSubviewToBack(stackView)
    }
}

open class MIStackableViewController: MIViewController {
    public var stackViewBottomConstraint: NSLayoutConstraint!
    public var stackView: MIStackView = {
        let stackView = MIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.hidesSeparatorsByDefault = true
        stackView.backgroundColor = .clear
        return stackView
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)
        initStackView()
    }

    public init(stackViewTopConstraintToSafeArea: Bool = true, bottomOffset: CGFloat = 0) {
        super.init(nibName: nil, bundle: nil)
        initStackView(topSafeConstraint: stackViewTopConstraintToSafeArea, bottomOffset: bottomOffset)
    }

    private func initStackView(topSafeConstraint: Bool = true, bottomOffset: CGFloat = 0) {
        view.addSubview(stackView)
        if #available(iOS 11.0, *) {
            stackView.topAnchor.constraint(equalTo: topSafeConstraint ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomOffset)
        } else {
            stackView.topAnchor.constraint(equalTo: topSafeConstraint ? view.topAnchor : view.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomOffset)
        }
        stackViewBottomConstraint.isActive = true
        stackView.layer.zPosition = -1
        view.sendSubviewToBack(stackView)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
