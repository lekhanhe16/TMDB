//
//  MainViewModel.swift
//  TMDB
//
//  Created by acupofstarbugs on 23/02/2023.
//

import Foundation

class FeaturedViewModel {
    private var trendings: [Movie] = []
    private var nowPlaying: [Movie] = []
    
    private func apiLevel() -> String {
        "3"
    }
    
    func fetchWeekTrendingMovies(type: MediaType, handler: @escaping ([Movie]) -> Void) {
        TmdbApiRouter.shared.request(cls: Response.self, router: FeaturedRouter(endpoint: .weekTrendings(mType: "movie")))
            { [weak self] data, error in
                if let data {
                    self?.trendings = data.results
                    handler(data.results)
                }
                else if let err = error {
                    print(err.localizedDescription)
                }
            }
    }
    
    private func withApiKey() -> String {
        "?api_key=" + K.api_key
    }
    
    func fetchNowPlayingMovies(handler: @escaping ([Movie]) -> Void) {
        TmdbApiRouter.shared.request(cls: Response.self, router: FeaturedRouter(endpoint: .nowPlaying))
            { [weak self] data, error in
                if let data {
                    self?.nowPlaying = data.results
                    handler(data.results)
                }
                else if let err = error {
                    print(err.localizedDescription)
                }
            }
    }
    
    func getTrendingMovies() -> [Movie] {
        trendings
    }
    
    func getNowPlayingMovies() -> [Movie] {
        nowPlaying
    }
}

enum MediaType: String {
    case all
    case movie
    case tv
    case person
}
