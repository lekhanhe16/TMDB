//
//  LoginViewModel.swift
//  TMDB
//
//  Created by acupofstarbugs on 04/03/2023.
//

import Foundation

class LoginViewModel {
    var auth = Authentication()
    func login(username: String, pass: String, handler: @escaping (Bool) -> Void) {
        auth.getNewRequestToken { [weak self] (data, err) in
            if let safeData = data, let wself = self {
                do {
                    let request_token = try JSONDecoder().decode(Token.self, from: safeData)
                    wself.auth.validateWithLogin(userName: username, password: pass, requestToken: request_token.request_token!) { ldata, lerr in
                        if let rqToken = ldata {
//                            let rqToken = try! JSONDecoder().decode(Token.self, from: sdata)
                            print(rqToken)
                            rqToken.toDateFormat()
                            let userModel = UserModel()
                            
                            userModel.token = rqToken
                            let user = User()
                            user.userName = username
                            userModel.user = user
                            UserModel.shared.save(user: userModel)
                            if rqToken.success == true {
                                handler(true)
                            }
                            else {
                                handler(false)
                            }
                        }
                    }
                }
                catch {
//                            print(error)
                }
            }
        }
    }
}
