***REMOVED***
***REMOVED***  MIViewController.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 11.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit
import NotificationCenter
import AloeStackView

open class MIViewController: UIViewController {
    
    public static var keyboardHeight: CGFloat?
    
    private var loadingSpinner: UIActivityIndicatorView!
    
    private var loadingSpinnerBackground: UIView!
    
    private var animateWithKeyboardClosure: ((_ keyboardHeight: CGFloat) -> Void)?
    
    public func setLoadingState(show: Bool) {
        setLoadingState(show: show, for: self.view)
    }
    
    public func setLoadingState(show: Bool, for view: UIView?) {
        guard let view = view else { return }
        
        if show, loadingSpinner == nil {
            
            let spinnerBackground = UIView()
            spinnerBackground.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            spinnerBackground.clipsToBounds = true
            spinnerBackground.layer.cornerRadius = 10
            
            let indicator = UIActivityIndicatorView(style: .gray)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.layer.zPosition = CGFloat(Int.max)
            indicator.color = .white
            
            spinnerBackground.addSubview(indicator)
            view.addSubview(spinnerBackground)
            view.bringSubviewToFront(spinnerBackground)
            indicator.snp.makeConstraints({$0.center.equalToSuperview()})
            indicator.layoutIfNeeded()
            indicator.startAnimating()
            
            spinnerBackground.snp.makeConstraints { make in
                        make.centerY.equalToSuperview()
                        make.centerX.equalToSuperview()
                        make.width.height.equalTo(indicator.frame.width*3)
            }
            
            loadingSpinner = indicator
            loadingSpinnerBackground = spinnerBackground
            
        } else if !show, loadingSpinner != nil {
            loadingSpinner!.removeFromSuperview()
            loadingSpinnerBackground.removeFromSuperview()
            loadingSpinner = nil
            loadingSpinnerBackground = nil
        }
    }
    
    public func animateWithKeyboard(_ callback: @escaping (_ keyboardHeight: CGFloat) -> Void) {
        self.animateWithKeyboardClosure = callback
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            let keyboardHeight = endFrameY >= UIScreen.main.bounds.size.height ? 0.0 : endFrame?.size.height ?? 0.0
            MIViewController.keyboardHeight = keyboardHeight
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                UIApplication.shared.beginIgnoringInteractionEvents()
                self.animateWithKeyboardClosure?(keyboardHeight)
            },
                           completion: { completed in
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension UIViewController {
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MIViewController{
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            ***REMOVED*** Fallback on earlier versions
        }
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.title = nil
        
        self.navigationController?.navigationBar.tintColor = .black
        
        if #available(iOS 11.0, *) {
            navigationItem.backButtonTitle = nil
        } else {
            ***REMOVED*** Fallback on earlier versions
        }
        navigationItem.backBarButtonItem?.tintColor = .black
        
        let backImage = ImageHelper.Icons.backArrow
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.leftBarButtonItem?.title = nil
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
