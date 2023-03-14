//
//  BaseCell.swift
//  TMDB
//
//  Created by acupofstarbugs on 23/02/2023.
//

import Foundation
import UIKit.UINib

protocol BaseCell : UICollectionViewCell{
    func config<T>(with movie: T)
    static var reuseIdentifier: String { get }
    static func nib() -> UINib
}
