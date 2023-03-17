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
        auth.getNewRequestToken { [weak self] data, _ in
            if let request_token = data, let wself = self {
                print(request_token.request_token ?? "nil")
                wself.auth.validateWithLogin(userName: username, password: pass, requestToken: request_token.request_token!) { ldata, err in
                    if let rqToken = ldata, err == nil {
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
                    else {
                        handler(false)
                    }
                }
            }
        }
    }
}
