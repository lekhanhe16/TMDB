//
//  MyCollectionViewCell.swift
//  CompositionalLayout
//
//  Created by acupofstarbugs on 28/02/2023.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    static let reuseIdentifier = "mycell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(with num: Int) {
        if num <= 10{
            img.image = UIImage(named: "iOS\(num)")
        }
        else {
            img.image = UIImage(named: "iOS\(num-10)")
        }
    }
}
