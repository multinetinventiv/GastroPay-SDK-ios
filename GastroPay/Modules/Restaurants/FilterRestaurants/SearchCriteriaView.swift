***REMOVED***
***REMOVED***  CitySearchCriteriaView.swift
***REMOVED***  Restaurants
***REMOVED***
***REMOVED***  Created by  on 13.02.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import SkeletonView
import YPNavigationBarTransition

protocol SearchCriteriaViewDelegate: AnyObject {
    func onAddTag(tag: String)
    func onRemoveTag(tag: String)
}

enum SearchCriteriaViewType: String {
    case cities = "Regions"
    case categories = "Categories"
    case tags = "Others"
}

class SearchCriteriaView: UIView {
    let criteriaTitle = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isSkeletonable = true
        $0.font = FontHelper.Restaurants.Search.criteriaTitle
        $0.textColor = ColorHelper.RestaurantSearch.criteriaTitle
        $0.text = "Placeholder Text"
    }

    var collectionViewHeight: NSLayoutConstraint
    let collectionView: UICollectionView

    let criteriaType: SearchCriteriaViewType
    var criteriaData: NetworkModels.SearchCriteria?

    weak var delegate: SearchCriteriaViewDelegate?

    init(cellType: SearchCriteriaViewType, spacingBetweenItems: CGFloat = 16.0) {
        self.criteriaType = cellType
        let collectionViewLayout = UICollectionViewFlowLayout().then {
            $0.minimumInteritemSpacing = spacingBetweenItems
            $0.scrollDirection = cellType == .tags ? .vertical : .horizontal
            $0.sectionInset = UIEdgeInsets(top: cellType == .tags ? 16 : 0, left: 16, bottom: 0, right: 16)
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CityCollectionViewCellTemplate.self)
        collectionView.register(CategoryCollectionViewCellTemplate.self)
        collectionView.register(TagCollectionViewCellTemplate.self)
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        collectionView.isScrollEnabled = cellType == .tags ? false : true
        collectionView.clipsToBounds = false

        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: cellType == .tags ? 100 : 90).with({ (const) in
            const.priority = .init(249)
        })

        super.init(frame: .zero)

        isSkeletonable = true

        addSubview(criteriaTitle)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            criteriaTitle.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            criteriaTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            criteriaTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: criteriaTitle.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionViewHeight
        ])

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCriteriaData(criteriaData: NetworkModels.SearchCriteria) {
        self.criteriaData = criteriaData

        if let restaurantsNC = Service.getTabbarController()?.viewControllers?[1] as? MINavigationController, let restaurantsVC = restaurantsNC.topViewController as? RestaurantsVC {
            let restaurantManager = Service.getEarnableRestaurantsManager()

            if let criteriaData = self.criteriaData {
                for (index, criteriaItem) in criteriaData.tags.enumerated() {
                    if restaurantManager?.tags?.contains(criteriaItem.id) == true {
                        self.criteriaData?.tags[index].selected = true
                    }
                }
            }
        }

        self.collectionView.reloadData()

        DispatchQueue.main.async {
            self.criteriaTitle.text = criteriaData.tagGroupName

            if self.criteriaType == .tags {
                self.collectionViewHeight.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            } else if self.criteriaType == .categories {
                self.collectionViewHeight.constant = 164
            }
        }
    }

}

extension SearchCriteriaView: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch criteriaType {
        case .cities:
            return String(describing: CityCollectionViewCellTemplate.self)
        case .tags:
            return String(describing: TagCollectionViewCellTemplate.self)
        default:
            return String(describing: CategoryCollectionViewCellTemplate.self)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return criteriaData?.tags.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if criteriaType == .cities, let city = criteriaData?.tags[indexPath.item] {
            let cell = collectionView.dequeue(CityCollectionViewCellTemplate.self, for: indexPath)
            cell.configure(criteriaItem: city)
            cell.applySketchShadow(blur: 20, cornerRadius: 8)
            return cell
        } else if criteriaType == .categories, let category = criteriaData?.tags[indexPath.item] {
            let cell = collectionView.dequeue(CategoryCollectionViewCellTemplate.self, for: indexPath)
            cell.configure(criteriaItem: category)
            return cell
        } else {
            let cell = collectionView.dequeue(TagCollectionViewCellTemplate.self, for: indexPath)
            cell.configure(criteriaItem: criteriaData!.tags[indexPath.item])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if criteriaType == .cities {
            let cell = collectionView.dequeue(CityCollectionViewCellTemplate.self, for: indexPath)
            if let city = criteriaData?.tags[safeIndex: indexPath.item] { cell.configure(criteriaItem: city) }
            let targetSize = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            collectionViewHeight.constant = targetSize.height + 40
            layoutIfNeeded()
            return targetSize
        } else if criteriaType == .categories {
            return CGSize(width: 98, height: 164)
        } else {
            print("criteriaData: \(String(describing: criteriaData?.tags.count))")
            if criteriaData?.tags.count ?? 0 > 0, collectionView.numberOfItems(inSection: indexPath.section) > 0, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagCollectionViewCellTemplate.self), for: indexPath) as? TagCollectionViewCellTemplate {
                if let tag = criteriaData?.tags[safeIndex: indexPath.item] { cell.configure(criteriaItem: tag) }
                let targetSize = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                return targetSize
            } else {
                return CGSize(width: 98, height: 164)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tag = criteriaData?.tags[indexPath.item] else { return }
        criteriaData?.tags[indexPath.item].selected = !tag.selected
        criteriaData?.tags[indexPath.item].selected == true ? delegate?.onAddTag(tag: tag.id) : delegate?.onRemoveTag(tag: tag.id)
        collectionView.reloadData()
    }

}
