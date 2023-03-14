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
//        TmdbApiRouter.shared.request(cls: Response.self, router: <#T##BaseRouter#>, completion: <#T##(Decodable?, AFError?) -> Void#>)
        let request = Request(url: K.baseUrl+apiLevel()+"/movie/\(id)/similar"+withApiKey(), method: .get, headers: nil)
        TMDBApi.shared.sendRequest(with: request) { data, error in
            if let safeData = data {
                do {
                    let movies = try JSONDecoder().decode(Response.self, from: safeData).results
                    completion(movies)
                }
                catch {
                    print(error)
                }
            }
        }
    }
    func getMovieTrailer(id: Int, completion: @escaping (String) -> Void) {
        let request = Request(url: K.baseUrl+apiLevel()+"/movie/\(id)/videos"+withApiKey(), method: .get, headers: nil)
        TMDBApi.shared.sendRequest(with: request, handler: { (data, reqError) in
            guard reqError != nil else {
                if let safeData = data {
                    do {
                        let links = try JSONDecoder().decode(TrailerResponse.self, from: safeData)
                        completion(links.results.first(where: { trailer in
                            trailer.name.contains("Official")
                        })?.key ?? links.results[0].key)
                    }
                    catch {
                        print(error)
                    }
                }
                return
            }
        })
    }
}
