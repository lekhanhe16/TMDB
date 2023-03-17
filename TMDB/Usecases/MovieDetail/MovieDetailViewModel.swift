//
//  MovieDetailViewModel.swift
//  TMDB
//
//  Created by acupofstarbugs on 26/02/2023.
//

import Foundation

class MovieDetailViewModel {
    private func withApiKey() -> String {
        return "?api_key="+K.api_key;
    }
    
    private func apiLevel() -> String{
        return "3"
    }
    
    func getSimilarMovies(id: Int, completion: @escaping ([Movie]) -> Void) {
        let router = MovieDetailRouter(endpoint: .similarMovies(id: id))
        TmdbApiRouter.shared.request(cls: Response.self, router: router) { data, err in
            if let data = data, err == nil {
                completion(data.results)
            }
        }
    }
    
    func getMovieTrailer(id: Int, completion: @escaping (String) -> Void) {
        let router = MovieDetailRouter(endpoint: .trailer(id: id))
        TmdbApiRouter.shared.request(cls: TrailerResponse.self, router: router) { data, err in
            if let links = data, err == nil {
                completion(links.results.first(where: { trailer in
                    trailer.name.contains("Official")
                })?.key ?? links.results[0].key)
            }
        }
    }
}
