//
//  BaseRouter.swift
//  TMDB
//
//  Created by acupofstarbugs on 08/03/2023.
//

import Alamofire
import Foundation

class BaseRouter: URLConvertible {
    func asURL() throws -> URL {
        try! (K.baseUrl + contextPath + path).asURL().appending(queryItems: [URLQueryItem(name: "api_key", value: K.api_key)])
    }

    var contextPath: String {
        "3"
    }

    var path: String {
        fatalError("[\(#function))] Must be overridden in subclass")
    }

    var headers: HTTPHeaders? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }

    var params: Parameters? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }

    var paramEncoding: ParameterEncoding {
        fatalError("[\(#function))] Must be overridden in subclass")
    }

    var method: HTTPMethod? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
}
