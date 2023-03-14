//
//  GenreViewCell.swift
//  TMDB
//
//  Created by acupofstarbugs on 01/03/2023.
//

import UIKit

class GenreViewCell: UICollectionViewCell {

    @IBOutlet weak var genreName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

extension GenreViewCell: BaseCell {
    func config<T>(with movie: T) {
        let genre = movie as! Genre
        genreName.text = genre.name
        genreName.backgroundColor = UIColor.random
        genreName.textColor = .white
        genreName.layer.cornerRadius = 8
        genreName.layer.masksToBounds = true
    }
    
    static var reuseIdentifier: String {
        return "GenreCell"
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "GenreViewCell", bundle: nil)
    }
    
    
}
