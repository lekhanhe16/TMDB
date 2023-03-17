//
//  GenreRouter.swift
//  TMDB
//
//  Created by acupofstarbugs on 17/03/2023.
//

import Alamofire
import Foundation

enum GenreEndpoint {
    case getGenres
}

class GenreRouter: BaseRouter {
    var endpoint: GenreEndpoint
    init(endpoint: GenreEndpoint) {
        self.endpoint = endpoint
    }

    override var path: String {
        "/genre/movie/list"
    }
    
    override var method: HTTPMethod? {
        switch endpoint {
            case .getGenres:
                return .get
        }
    }
    
    override var headers: HTTPHeaders? {
        nil
    }
    
    override var params: Parameters? {
        nil
    }
    
    override var paramEncoding: ParameterEncoding {
        URLEncoding.default
    }
}
