//
//  TmdbApiRouter.swift
//  TMDB
//
//  Created by acupofstarbugs on 07/03/2023.
//

import Alamofire
import Foundation

class TmdbApiRouter {
    private init() {}

    static let shared = TmdbApiRouter()
    var sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10
        return Session(configuration: configuration)
    }()

    func request<T: Decodable>(cls: T.Type, router: BaseRouter, completion: @escaping (T?, Error?) -> Void) {
        sessionManager.request(router, method: router.method!, parameters: router.params ?? [:], encoding: router.paramEncoding, headers: router.headers).response { [weak self] response in
            switch response.result {
                case .success(let data):
                    switch response.response?.statusCode ?? 500 {
                        case 200 ... 201:
                            completion(self?.decodeData(cls: T.self, data: data!), nil)
                        default:
                            completion(nil, LoginError())
                    }
//                    return
                case .failure(let error):
                    print(error.localizedDescription)
//                    return
            }
        }
    }

    func decodeData<T: Decodable>(cls: T.Type, data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        }
        catch {
            print(error)
        }
        return nil
    }
}

struct LoginFailResponse: Decodable {
    var success: Bool
    var status_code: Int
    var status_message: String
}

struct LoginError: Error {}
