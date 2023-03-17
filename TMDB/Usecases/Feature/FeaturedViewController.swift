//
//  ViewController.swift
//  TMDB
//
//  Created by acupofstarbugs on 18/02/2023.
//

import UIKit
import AuthenticationServices

class FeaturedViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel = FeaturedViewModel()
    var selectedMovie: Movie!
    var dataSource: UICollectionViewDiffableDataSource<Int, Movie>!
    var snapShot: NSDiffableDataSourceSnapshot<Int, Movie>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchWeekTrendingMovies(type: .movie) {
            [weak self] (trendings) in
            if let self = self {
                self.loadData(section: 0, data: trendings)
            }
        }
        viewModel.fetchNowPlayingMovies() {
            [weak self] (nowplaying) in
            if let self = self {
                self.loadData(section: 1, data: nowplaying)
            }
            
        }
        
        
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        registerReusableCell()
        
        createDataSource()
    }
    
    func registerReusableCell() {
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(TrendingMovieCell.nib(), forCellWithReuseIdentifier: TrendingMovieCell.reuseIdentifier)
        collectionView.register(NowPlaying.nib(), forCellWithReuseIdentifier: NowPlaying.reuseIdentifier)
    }
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout{[weak self] (section,layoutEnv) in
            if let wself = self {
                switch section {
                case 1:
                    return wself.createNowPlayingSection()
                default:
                    return wself.createTrendingSection()
                }
            }
            return nil
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        layout.configuration = config
        return layout
    }
    
    func createNowPlayingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .absolute(450))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [layoutSectionHeader]

        return section
    }
    
    func loadData(section: Int, data: [Movie]) {
        if snapShot == nil {
            snapShot = NSDiffableDataSourceSnapshot()
        }
        snapShot.appendSections([section])
        if section == 0 {
            snapShot.appendItems(viewModel.getTrendingMovies(), toSection: 0)
        }
        else {
            snapShot.appendItems(viewModel.getNowPlayingMovies(), toSection: 1)
        }
        dataSource.apply(snapShot)
    }
    
    func createTrendingSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 32)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(230))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let layoutSectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [layoutSectionHeader]
        return section
    }
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [self] collectionView,indexPath,movie in
            switch indexPath.section {
            case 0:
                return configure(TrendingMovieCell.self, with: movie, for: indexPath)
            case 1:
                return configure(NowPlaying.self, with: movie, for: indexPath)
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return UICollectionReusableView()
            }

            sectionHeader.title.text = indexPath.section == 0 ? "Trendings" : "Now playing"
            sectionHeader.subtitle.text = indexPath.section == 0 ? "This week" : ""
    
            return sectionHeader
        }
    }
    
    func configure<T: BaseCell>(_ cellType: T.Type, with movie: Movie, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            return UICollectionViewCell() as! T
        }
        
        cell.config(with: movie)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedMovie = nil
    }
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    deinit {
        print("featured view controller deinit")
    }
}

extension FeaturedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedMovie = viewModel.getTrendingMovies()[indexPath.row]
        default:
            selectedMovie = viewModel.getNowPlayingMovies()[indexPath.row]
        }
        performSegue(withIdentifier: "viewmoviedetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "viewmoviedetail":
            if let vc = segue.destination as? MovieDetailViewController {
                vc.movie = selectedMovie
            }
        default:
            return
        }
    }
    
}
