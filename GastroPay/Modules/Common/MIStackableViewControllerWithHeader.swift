//
//  MIStackableViewControllerWithHeader.swift
//  Inventiv+CommonModule
//
//  Created by  on 8.01.2020.
//

import UIKit

open class MIStackableViewControllerWithHeader: MIViewController {
    public let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    public let headerViewContainer: UIView = {
        let headerViewContainer = UIView()
        headerViewContainer.translatesAutoresizingMaskIntoConstraints = false
        return headerViewContainer
    }()

    open var headerView: UIView = UIView() {
        didSet {
            self.headerView.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    var stackViewTopAnchorWithHeader: NSLayoutConstraint!
    var stackViewTopAnchorWithScrollView: NSLayoutConstraint!
    public let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initViews() {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }

        view.addSubview(scrollView)
        scrollView.bindFrameToSuperviewBounds()
        scrollView.addSubview(headerViewContainer)
        headerViewContainer.addSubview(headerView)
        scrollView.addSubview(stackView)

        stackViewTopAnchorWithHeader = stackView.topAnchor.constraint(equalTo: headerViewContainer.bottomAnchor, constant: 16)
        if #available(iOS 11.0, *) {
            stackViewTopAnchorWithScrollView = stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        } else {
            // Fallback on earlier versions
        }

        let headerViewTopAnchor = headerView.topAnchor.constraint(equalTo: view.topAnchor)
        headerViewTopAnchor.priority = .defaultHigh

        let headerViewHeightAnchor = headerView.heightAnchor.constraint(greaterThanOrEqualTo: headerViewContainer.heightAnchor)
        headerViewHeightAnchor.priority = .required

        let headerViewFittingSize = headerView.systemLayoutSizeFitting(CGSize(width: self.view.bounds.width, height: UIView.layoutFittingCompressedSize.height))

        NSLayoutConstraint.activate([
            headerViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            headerViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerViewContainer.heightAnchor.constraint(equalToConstant: headerViewFittingSize.height),

            headerViewTopAnchor,
            headerView.leadingAnchor.constraint(equalTo: headerViewContainer.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: headerViewContainer.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: headerViewContainer.bottomAnchor),
            headerViewHeightAnchor,

            stackViewTopAnchorWithHeader,
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if #available(iOS 11.0, *) {
            scrollView.scrollIndicatorInsets = view.safeAreaInsets
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        } else {
            // Fallback on earlier versions
        }
    }
}
