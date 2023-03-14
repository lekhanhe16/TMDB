//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by acupofstarbugs on 26/02/2023.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    @IBAction func btnPlayTrailerClicked(_ sender: UIButton) {
        playVideo()
    }
    @IBOutlet weak var similarMoviesList: UICollectionView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieInfo: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var datasource: UICollectionViewDiffableDataSource<Int, Movie>!
    var movie: Movie!
    var trailerKey = ""
    var snapshot =  NSDiffableDataSourceSnapshot<Int, Movie>()
    let viewModel = MovieDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    func setupCollectionView() {
        similarMoviesList.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        similarMoviesList.register(TrendingMovieCell.nib(), forCellWithReuseIdentifier: TrendingMovieCell.reuseIdentifier)
        similarMoviesList.collectionViewLayout = UICollectionViewCompositionalLayout {[weak self] (index,layoutEnv) in
            if let weakself = self {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(230))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let layoutSectionHeader = weakself.createSectionHeader()
                section.boundarySupplementaryItems = [layoutSectionHeader]
                return section
            }
            return nil
        }
        createDataSource()
        viewModel.getSimilarMovies(id: movie.id) { [weak self] (arrMovies) in
            if let self = self {
                self.loadSimilarMovie(movies: arrMovies)
            }
        }
    }
    func createDataSource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: similarMoviesList) {
            collectionView, indexPath, movie in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingMovieCell.reuseIdentifier, for: indexPath) as? TrendingMovieCell {
                cell.config(with: movie)
                return cell
            }
            return TrendingMovieCell()
        }
        
        datasource.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return UICollectionReusableView()
            }
            sectionHeader.title.text = "Similar movies"
            return sectionHeader
        }
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    func loadSimilarMovie(movies: [Movie]) {
        snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(movies, toSection: 0)
        datasource.apply(snapshot)
    }
    func setupView() {
        overview.text = movie.overview
        
        movieTitle.text = movie.title
        movieInfo.text = movie.release_date
//        subTitle.text = movie.original_title
        
        guard let url = movie.backdrop_path else {return}
        if let urlStr = (K.baseImgUrl+url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            imageView.sd_setImage(with: URL(string: urlStr))
        }
        
        viewModel.getMovieTrailer(id: movie.id) { [weak self] (key) in
            if let self = self{
                self.trailerKey = key
            }
        }
    }
    
    func playVideo() {
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PopUpTrailerViewController", creator: { [weak self] (coder) in
            guard let weakSelf = self else { return PopUpTrailerViewController(coder: coder, key: "")}
            return PopUpTrailerViewController(coder: coder, key: weakSelf.trailerKey)
        })
        
        addChild(popVC)
        popVC.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.height)
//        popVC.view.layer.cornerRadius = 5
        view.addSubview(popVC.view)
        
        view.addConstraints([
            popVC.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popVC.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        popVC.didMove(toParent: self)
    }
    
    deinit {
        print("moviedetail view controller deinit")
    }
}

