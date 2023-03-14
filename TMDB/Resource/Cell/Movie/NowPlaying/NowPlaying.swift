//
//  NowPlaying.swift
//  TMDB
//
//  Created by acupofstarbugs on 26/02/2023.
//

import UIKit
import SDWebImage

class NowPlaying: UICollectionViewCell {

    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension NowPlaying: BaseCell {
    
    func config<T>(with movie: T) {
        let movie = movie as! Movie
        title.text = movie.title
        addScoreView(voteAvg: movie.vote_average)
        guard let url = movie.backdrop_path else {return}
        if let urlStr = (K.baseImgUrl+url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            img.sd_setImage(with: URL(string: urlStr))
            img.layer.cornerRadius = 8
            img.clipsToBounds = true
            img.layer.masksToBounds = true
        }
    }
    func addScoreView(voteAvg: Float) {
        rating.text = String(voteAvg)
        rating.textColor = .black
        rating.textAlignment = .center
        rating.layer.cornerRadius = rating.frame.size.width / 2
        rating.layer.masksToBounds = true
        switch voteAvg {
        case 0.0...5.0:
            rating.backgroundColor = .red
        case 5.1...7.4:
            rating.backgroundColor = .yellow
        default:
            rating.backgroundColor = .green
        }
        
    }
    static var reuseIdentifier: String {
        return "NowPlaying"
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NowPlaying", bundle: nil)
    }
    
    
}
