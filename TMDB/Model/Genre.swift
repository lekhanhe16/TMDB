//
//  Genre.swift
//  TMDB
//
//  Created by acupofstarbugs on 01/03/2023.
//

import Foundation

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}

struct ResponseGenre: Codable {
    let genres: [Genre]
}
