//
//  CategoriesViewController.swift
//  TMDB
//
//  Created by acupofstarbugs on 01/03/2023.
//

import UIKit

class GenreViewController: UIViewController {

    let viewModel = GenreViewModel()
    var dataSource: UICollectionViewDiffableDataSource<Int, Genre>!
    var snapshot: NSDiffableDataSourceSnapshot<Int, Genre>!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
    }
    
    func setupCollectionView() {
        categoryCollectionView.register(GenreViewCell.nib(), forCellWithReuseIdentifier: GenreViewCell.reuseIdentifier)
        categoryCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        categoryCollectionView.collectionViewLayout = createCollectionViewLayout()
        createDataSource()
        viewModel.getGenres { arrGenres in
            DispatchQueue.main.async {
                [weak self] () in
                if let self = self {
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
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            return self.createSection()
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
    deinit {
        print("genre view controller deinit")
    }
}
