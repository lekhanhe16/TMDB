//
//  CategoriesViewController.swift
//  TMDB
//
//  Created by acupofstarbugs on 01/03/2023.
//

import UIKit

class GenreViewController: UIViewController {
    private var startContentOffset: CGFloat!
    private var lastContentOffset: CGFloat!
    private var isHidingTabBar: Bool = false
    
    let viewModel = GenreViewModel()
    var dataSource: UICollectionViewDiffableDataSource<Int, Genre>!
    var snapshot: NSDiffableDataSourceSnapshot<Int, Genre>!
    @IBOutlet var categoryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("genre view controller")
        // Do any additional setup after loading the view.
        setupCollectionView()
    }
    
    func setupCollectionView() {
        categoryCollectionView.register(GenreViewCell.nib(), forCellWithReuseIdentifier: GenreViewCell.reuseIdentifier)
        categoryCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        categoryCollectionView.collectionViewLayout = createCollectionViewLayout()
        createDataSource()
        categoryCollectionView.delegate = self
        viewModel.getGenres { arrGenres in
            DispatchQueue.main.async {
                [weak self] () in
                if let self {
                    self.reloadData(genres: arrGenres)
                }
            }
        }
    }
    
    func reloadData(genres: [Genre] = []) {
        if genres.count > 0 {
            snapshot = NSDiffableDataSourceSnapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(genres, toSection: 0)
            dataSource.apply(snapshot)
        }
    }

    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: categoryCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreViewCell.reuseIdentifier, for: indexPath) as? GenreViewCell {
                cell.config(with: itemIdentifier)
                return cell
            }
            return UICollectionViewCell()
        })
    }

    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            self.createSection()
        }
        return layout
    }
    
    func createSection() -> NSCollectionLayoutSection {
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(1))
        
        let group2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1))
        
        let group2ItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        
        let group2Item = NSCollectionLayoutItem(layoutSize: group2ItemSize)
        group2Item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        
        let group2 = NSCollectionLayoutGroup.vertical(layoutSize: group2Size, subitems: [group2Item])
        
        let group1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: group1Size, subitems: [largeItem, group2])
        
        let section = NSCollectionLayoutSection(group: group1)
        return section
    }
    
    func hideTabBarIfNeed() {
        guard !isHidingTabBar else { return }
        isHidingTabBar = true
        tabBarController?.setTabbar(hidden: isHidingTabBar, animate: true)
    }
    
    func showTabBarIfNeed() {
        guard isHidingTabBar else { return }
        isHidingTabBar = false
        tabBarController?.setTabbar(hidden: isHidingTabBar, animate: true)
    }
    
    deinit {
        print("genre view controller deinit")
    }
}

extension GenreViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let differentFromStart = startContentOffset - currentOffset
        let differentFromLast = lastContentOffset - currentOffset
        lastContentOffset = currentOffset
        if differentFromStart < 0 {
            if scrollView.isTracking, abs(differentFromLast) > 1 {
                hideTabBarIfNeed()
            }
        } else {
            if scrollView.isTracking, abs(differentFromLast) > 1 {
                showTabBarIfNeed()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startContentOffset = scrollView.contentOffset.y
        lastContentOffset = scrollView.contentOffset.y
    }
}
