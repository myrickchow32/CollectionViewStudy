//
//  ViewController.swift
//  Sway
//
//  Created by Omar Ahmed on 13/06/2022.
//

import UIKit

class FoodViewController: UIViewController {
    
    // MARK: Properties
    
    let navigationView : UIView = {
        let nv = UIView()
        nv.translatesAutoresizingMaskIntoConstraints = false
        nv.backgroundColor = .systemBackground
        return nv
    }()
    
    lazy var filterHeaderView: FilterHeaderView = {
        let filter = FilterHeaderView()
        filter.translatesAutoresizingMaskIntoConstraints = false
        filter.isHidden = true
        filter.delegate = self
        return filter
    }()
    
    lazy var collectionView : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(FoodTopBannerCollectionViewCell.self, forCellWithReuseIdentifier: FoodTopBannerCollectionViewCell.cellIdentifier)
        cv.register(FoodCategoryCollectionViewCell.self, forCellWithReuseIdentifier: FoodCategoryCollectionViewCell.cellIdentifier)
        cv.register(RestaurantListCollectionViewCell.self, forCellWithReuseIdentifier: RestaurantListCollectionViewCell.cellIdentifier)
        
        cv.register(FilterHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: FilterHeaderView.headerIdentifier)
        cv.register(DividerFooterView.self, forSupplementaryViewOfKind: "Footer", withReuseIdentifier: DividerFooterView.footerIdentifier)
        cv.register(VeganSectionHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: VeganSectionHeaderView.headerIdentifier)
        cv.register(RestaurantVeganCollectionViewCell.self, forCellWithReuseIdentifier: RestaurantVeganCollectionViewCell.cellIdentifier)
        
        cv.backgroundColor = .systemBackground
        return cv
    }()
    
    //MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpNavigation()
        setUpConstrains()
        configureCompositionalLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigation()
    }
    
    func setUpNavigation(){
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = false
        
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        btn.setButtonTitleWithRightImage(title: "Home", btnImage: "ic_arrow_down", customFont: UIFont.systemFont(ofSize: 20,weight: .bold), color: .label, imageColor: .label, imageSize: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func configureUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(navigationView)
        view.addSubview(collectionView)
        view.addSubview(filterHeaderView)
    }
    
    func setUpConstrains(){
        collectionView.setUp(to: view)
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor, constant: -(windowConstant.getTopPadding + 64)),
            navigationView.heightAnchor.constraint(equalToConstant: windowConstant.getTopPadding + 64),
            
            filterHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterHeaderView.heightAnchor.constraint(equalToConstant: 45),
        ])
    }


}

extension FoodViewController {
    
    func configureCompositionalLayout(){
        let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
            switch sectionIndex {
            case 0 :
                return AppLayouts.foodBannerSection()
            case 1 :
                return AppLayouts.foodCategorySection()
            case 2 :
                return AppLayouts.restaurantsListSection()
            default:
                return AppLayouts.VeganSectionLayout()
            }
        }
        layout.register(SectionDecorationView.self, forDecorationViewOfKind: "SectionBackground")
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension FoodViewController: FilterActionDelegate {
    func didTabFilterBTN() {
        print("Open Filter")
    }
}

extension FoodViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return foodTopBannerMockData.count
        case 1 :
            return foodCategoryMockData.count
        case 2 :
            return restaurantListMockData.count
        default:
            return veganRestaurantMockData.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodTopBannerCollectionViewCell.cellIdentifier, for: indexPath) as? FoodTopBannerCollectionViewCell else {fatalError("Unable deque cell...")}
             cell.cellData = foodTopBannerMockData[indexPath.row]
             return cell
            
        case 1 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCategoryCollectionViewCell.cellIdentifier, for: indexPath) as? FoodCategoryCollectionViewCell else {fatalError("Unable deque cell...")}
             cell.cellData = foodCategoryMockData[indexPath.row]
             return cell
        case 2 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantListCollectionViewCell.cellIdentifier, for: indexPath) as? RestaurantListCollectionViewCell else {fatalError("Unable deque cell...")}
                cell.cellData = restaurantListMockData[indexPath.row]
             return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantVeganCollectionViewCell.cellIdentifier, for: indexPath) as? RestaurantVeganCollectionViewCell else {fatalError("Unable deque cell...")}
             cell.cellData = veganRestaurantMockData[indexPath.row]
             return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "Header" {
            
            switch indexPath.section {
            case 2 :
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterHeaderView.headerIdentifier, for: indexPath) as! FilterHeaderView
                header.delegate = self
                return header
            default :
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VeganSectionHeaderView.headerIdentifier, for: indexPath) as! VeganSectionHeaderView
                return header
            }
            
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DividerFooterView.footerIdentifier, for: indexPath) as! DividerFooterView
            
            return footer
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FoodTopBannerCollectionViewCell {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
                cell.bannerImage.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? RestaurantListCollectionViewCell {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
                cell.restaurantImgCover.transform = .init(scaleX: 0.95, y: 0.95)
                cell.offerView.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FoodTopBannerCollectionViewCell {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
                cell.bannerImage.transform = .identity
            }
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? RestaurantListCollectionViewCell {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
                cell.restaurantImgCover.transform = .identity
                cell.offerView.transform = .identity
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offestY = scrollView.contentOffset.y
        if abs(offestY) > 350 {
            filterHeaderView.isHidden = false
            filterHeaderView.isSticky = true
        }else {
            filterHeaderView.isHidden = true
            filterHeaderView.isSticky = false
        }
    }
    
    
}
