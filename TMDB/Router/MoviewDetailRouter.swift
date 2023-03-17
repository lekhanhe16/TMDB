//
//  MoviewDetailRouter.swift
//  TMDB
//
//  Created by acupofstarbugs on 17/03/2023.
//

import Foundation
import Alamofire

enum MovieDetailEndpoint {
    case trailer(id: Int), similarMovies(id: Int)
}

class MovieDetailRouter: BaseRouter {
    var endpoint: MovieDetailEndpoint
    init(endpoint: MovieDetailEndpoint) {
        self.endpoint = endpoint
    }

    override var path: String {
        switch endpoint {
            case .trailer(let id):
                return "/movie/\(id)/videos"
            case .similarMovies(let id):
                return "/movie/\(id)/similar"
        }
    }

    override var headers: HTTPHeaders? {
        nil
    }

    override var params: Parameters? {
        nil
    }

    override var paramEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    override var method: HTTPMethod? {
        .get
    }
}
