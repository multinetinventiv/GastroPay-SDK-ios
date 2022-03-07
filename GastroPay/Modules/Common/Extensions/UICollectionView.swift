//
//  UICollectionView.swift
//  Alamofire
//
//  Created by  on 20.12.2019.
//

import UIKit

public extension UICollectionView {

    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }

    func registerNib<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: String(describing: T.self))
    }

    func registerNibSupplementaryViewHeader<T: UICollectionReusableView>(_: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self))
    }

    func registerSupplementaryViewHeader<T: UICollectionReusableView>(_: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self))
    }

    func registerNibSupplementaryViewFooter<T: UICollectionReusableView>(_: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self))
    }

    func dequeue<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    func dequeueSupplementaryViewHeader<T: UICollectionReusableView>(_: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    func dequeueSupplementaryViewFooter<T: UICollectionReusableView>(_: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }

}

public extension UITableView {

    /// Register given `UITableViewCell` in tableView.
    /// Cell will be registered with the name of it's class as identifier.
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    /// Register given `UITableViewCell` in tableView.
    /// Cell will be registered with the name of it's class as identifier.
    func registerNib<T: UITableViewCell>(_:T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }

    /// Dequeue cell of given class from tableView.
    func dequeue<T: UITableViewCell>(_: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T ?? T()
    }

}

public extension UICollectionViewCell {

    func applySketchShadow(
        color: UIColor = UIColor(red: 131.0 / 255.0, green: 131.0 / 255.0, blue: 131.0 / 255.0, alpha: 0.2),
        alpha: Float = 1.0,
        x: CGFloat = 2,
        y: CGFloat = 4,
        blur: CGFloat = 20,
        cornerRadius: Int = 10) {

        contentView.layer.cornerRadius = CGFloat(cornerRadius)
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = color.cgColor
        layer.shadowRadius = blur / 2
        layer.shadowOpacity = alpha
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }

}
