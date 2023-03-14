//
//  AccountViewModel.swift
//  TMDB
//
//  Created by acupofstarbugs on 04/03/2023.
//

import Foundation

class AccountViewModel {
    var auth = Authentication()
    func isUserLogin() -> UserModel? {
        if UserModel.shared.currentUser != nil {
            return UserModel.shared.currentUser
        }
        else {
            if let expired = UserDefaults.standard.string(forKey: "token_expired_at") {
                if auth.isValidRequestToken(expiredTime: expired) == false{
                    return nil
                }
                else {
                    return UserModel()
                }
            }
        }
        return nil
    }
}
