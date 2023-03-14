//
//  Authentication.swift
//  TMDB
//
//  Created by acupofstarbugs on 04/03/2023.
//

import Foundation
import Alamofire

class Authentication {
    func isValidRequestToken(expiredTime: String) -> Bool {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curDateStr = df.string(from: Date())
        
        let df2 = DateFormatter()
        df2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df2.timeZone = TimeZone(abbreviation: "UTC")
        
        
        if let curDate = df.date(from: curDateStr),  let expiredDate = df2.date(from: expiredTime) {
            switch curDate.compare(expiredDate) {
            case .orderedDescending:
                return false
            default:
                return true
            }
        }
        return false
    }
    
    private func withApiKey() -> String {
        return "?api_key="+K.api_key;
    }
    
    func getNewRequestToken(handler: @escaping (Data?, Error?) -> Void) {
        let request = Request(url: K.baseUrl+"3/authentication/token/new"+withApiKey(), method: .get, headers: nil)
        TMDBApi.shared.sendRequest(with: request) { data, err in
            if let safeData = data {
                handler(safeData, nil)
            }
            else {
                handler(nil, nil)
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
                print(err?.localizedDescription)
                handler(nil, error)
            }
        }
    }
}
