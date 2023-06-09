//
//  TrendingMovieCell.swift
//  TMDB
//
//  Created by acupofstarbugs on 26/02/2023.
//

import UIKit
import SDWebImage

class TrendingMovieCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    let transformer = SDImageResizingTransformer(size: CGSize(width: 400, height: 200), scaleMode: .aspectFit)
}

extension TrendingMovieCell : BaseCell {
    func config<T>(with movie: T) {
        let movie = movie as! Movie
        guard let url = movie.backdrop_path else {return}
        title.text = movie.title
        if let urlStr = (K.baseImgUrl+url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            imageView.sd_setImage(with: URL(string: urlStr), placeholderImage: nil, context: [.imageTransformer:transformer])
        }
    }
    
    static var reuseIdentifier: String {
        return "TrendingMovieCell"
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TrendingMovieCell", bundle: nil)
    }
    
    
}
