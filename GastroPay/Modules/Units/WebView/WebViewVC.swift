***REMOVED***
***REMOVED***  WebViewVC.swift
***REMOVED***  Units
***REMOVED***
***REMOVED***  Created by Ufuk Serdogan on 5.03.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import WebKit
import Then
import YPNavigationBarTransition

public class WebViewVC: MIViewController, NavigationBarConfigureStyle {
    public var pageUrl: String

    let wkWebView = WKWebView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let navigationTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = ""
    }

    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .showShadowImage
    }

    public func yp_navigationBarTintColor() -> UIColor! {
        return .black
    }

   public init(pageUrl: String) {
           self.pageUrl = pageUrl
           super.init(nibName: nil, bundle: nil)
       }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.titleView = navigationTitleLabel
        navigationController?.navigationBar.backIndicatorImage = ImageHelper.Icons.backArrow
           navigationController?.navigationBar.backIndicatorTransitionMaskImage = ImageHelper.Icons.backArrow
           navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)

        view.addSubview(wkWebView)
        wkWebView.bindFrameToSuperviewBounds(lefMargin: 16, rightMargin: 16, topMargin: 16, bottomMargin: 16)
        wkWebView.scrollView.showsVerticalScrollIndicator = false
        wkWebView.scrollView.showsHorizontalScrollIndicator = false
        guard let url = URL(string: pageUrl) else {
            return
        }

        wkWebView.load(URLRequest(url: url))
    }

}
