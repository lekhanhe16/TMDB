//
//  CategoryViewModel.swift
//  TMDB
//
//  Created by acupofstarbugs on 01/03/2023.
//

import Foundation

class GenreViewModel {
    var genres = [Genre]()
    private func withApiKey() -> String {
        "?api_key="+K.api_key
    }

    func getGenres(completion: @escaping ([Genre]) -> Void) {
        let request = Request(url: K.baseUrl+"3/genre/movie/list"+withApiKey(), method: .get, headers: nil)
        TMDBApi.shared.sendRequest(with: request) { [weak self] data, _ in
            if let safeData = data, let self {
                do {
                    self.genres = try JSONDecoder().decode(ResponseGenre.self, from: safeData).genres
                    completion(self.genres)
                }
                catch {
                }
            }
        }
    }
}
