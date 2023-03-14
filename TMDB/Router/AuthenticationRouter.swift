//
//  AuthenticationRoute.swift
//  TMDB
//
//  Created by acupofstarbugs on 14/03/2023.
//

import Foundation
import Alamofire

enum AuthEndpoint {
    case newToken, validateWithLogin(userName: String, pwd: String, rq_token: String)
}
class AuthenticationRouter: BaseRouter {
    var endpoint: AuthEndpoint
    init(endpoint: AuthEndpoint) {
        self.endpoint = endpoint
    }
    override var path: String {
        switch endpoint {
            case .newToken:
                return "/authentication/token/new"
            case .validateWithLogin(_, _, _):
                return "/authentication/token/validate_with_login"
        }
    }
    override var urlParams: Parameters {
        return ["api_key" : K.api_key]
    }
    
    override var method: HTTPMethod?{
        switch endpoint {
            case .newToken:
                return .get
            case .validateWithLogin(_, _, _):
                return .post
        }
    }
    
    override var headers: HTTPHeaders? {
        return nil
    }
    
    override var params: Parameters? {
        switch endpoint {
            case .newToken:
                return nil
            case .validateWithLogin(let userName, let pwd, let rq_token):
                return [
                    "username": userName,
                    "password":pwd,
                    "request_token": rq_token
                ]
        }
    }
    
    override var paramEncoding: ParameterEncoding {
        switch endpoint {
            case .newToken:
                return URLEncoding.default
            case .validateWithLogin(_, _, _):
                return JSONEncoding.default
        }
    }
}
