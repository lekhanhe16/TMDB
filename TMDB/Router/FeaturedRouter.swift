//
//  FeaturedRouter.swift
//  TMDB
//
//  Created by acupofstarbugs on 07/03/2023.
//

import Alamofire
import Foundation

enum FeaturedEndpoint {
    case weekTrendings(mType: String), nowPlaying
}

class FeaturedRouter: BaseRouter {
    var endpoint: FeaturedEndpoint
    
    init(endpoint: FeaturedEndpoint) {
        self.endpoint = endpoint
    }
    
    override var path: String {
        switch endpoint {
        case .weekTrendings(let mType):
            return "/trending/\(mType)/week"
        case .nowPlaying:
            return "/movie/now_playing"
        }
    }
    
    override var params: Parameters? {
        nil
    }
    
    override var paramEncoding: ParameterEncoding {
        if method != nil, method == .post {
            return JSONEncoding.default
        }
        else {
            return URLEncoding.default
        }
    }
    
    override var method: HTTPMethod? {
        switch endpoint {
        case .weekTrendings(_), .nowPlaying:
            return .get
        }
    }
    
    override var headers: HTTPHeaders? {
        nil
    }
}
