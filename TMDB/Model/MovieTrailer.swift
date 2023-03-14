//
//  MovieTrailer.swift
//  TMDB
//
//  Created by acupofstarbugs on 26/02/2023.
//

import Foundation

struct MovieTrailer: Codable {
    let key: String
    let official: Bool
    let site: String
    let name: String
}

struct TrailerResponse: Codable {
    let id: Int
    let results: [MovieTrailer]
}
