//
//  Authentication.swift
//  TMDB
//
//  Created by acupofstarbugs on 04/03/2023.
//

import Alamofire
import Foundation

class Authentication {
    func isValidRequestToken(expiredTime: String) -> Bool {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curDateStr = df.string(from: Date())
        
        let df2 = DateFormatter()
        df2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df2.timeZone = TimeZone(abbreviation: "UTC")
        
        if let curDate = df.date(from: curDateStr), let expiredDate = df2.date(from: expiredTime) {
            switch curDate.compare(expiredDate) {
            case .orderedDescending:
                return false
            default:
                return true
            }
        }
        return false
    }
    
    func getNewRequestToken(handler: @escaping (Token?, Error?) -> Void) {
        let router = AuthenticationRouter(endpoint: .newToken)
        TmdbApiRouter.shared.request(cls: Token.self, router: router) { token, err in
            if token != nil, err == nil {
                handler(token, nil)
            }
            else {
                handler(nil, err)
            }
        }
    }
    
    func validateWithLogin(userName: String, password: String, requestToken: String, handler: @escaping (Token?, Error?) -> Void) {
        TmdbApiRouter.shared.request(cls: Token.self, router: AuthenticationRouter(endpoint: .validateWithLogin(userName: userName, pwd: password, rq_token: requestToken))) { data, err in
            
            if let safeData = data {
                print(safeData)
                handler(safeData, nil)
            }
            else if let error = err {
                print(error.localizedDescription)
                handler(nil, error)
            }
        }
    }
}
