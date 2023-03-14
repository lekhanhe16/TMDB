//
//  TrendingMovieCell.swift
//  TMDB
//
//  Created by acupofstarbugs on 26/02/2023.
//

import UIKit

class TrendingMovieCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension TrendingMovieCell : BaseCell {
    func config<T>(with movie: T) {
        let movie = movie as! Movie
        guard let url = movie.backdrop_path else {return}
        title.text = movie.title
        if let urlStr = (K.baseImgUrl+url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            imageView.sd_setImage(with: URL(string: urlStr))
        }
    }
    
    static var reuseIdentifier: String {
        return "TrendingMovieCell"
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TrendingMovieCell", bundle: nil)
    }
    
    
}
