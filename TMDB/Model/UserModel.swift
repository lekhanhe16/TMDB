//
//  UserModel.swift
//  TMDB
//
//  Created by acupofstarbugs on 04/03/2023.
//

import Foundation

class UserModel {
    static var shared = UserModel()
    var currentUser: UserModel?
    var user: User?
    var token: Token?
    
    func save(user: UserModel) {
        currentUser = user
//        print(currentUser?.token?.expires_at)
        UserDefaults.standard.set(currentUser?.user?.userName, forKey: "username")
        UserDefaults.standard.set(currentUser?.token?.expires_at, forKey: "token_expired_at")
    }
}

class User {
    var userName: String?
}

class Token: Codable {
    var success: Bool?
    var request_token: String?
    var expires_at: String?
    func toDateFormat() {
        if let expires_at = expires_at {
            var res = ""
            var cnt = 0
            for char in expires_at{
                if char == " "{
                    cnt = cnt + 1
                }
                if cnt == 2 {
                    break
                }
                res = res + String(char)
            }
            self.expires_at = res
        }
    }
}
