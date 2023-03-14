//
//  TMDBApi.swift
//  TMDB
//
//  Created by acupofstarbugs on 23/02/2023.
//

import Foundation
import Alamofire
class TMDBApi {
    static var shared: TMDBApi = TMDBApi()
    func sendRequest(with rq: Request,  handler: @escaping (Data?, Error?) -> Void) {
        AF.request(rq.url, method: rq.method, parameters: rq.param, headers: rq.headers, interceptor: nil)
            .response { response in
                switch response.result {
                case .success(let data):
                    handler(data, nil)
                case .failure(let error):
                    handler(nil, error)
                }
            }
    }
//    func request<T:Decodable>(with req: URLConvertible, resultType: T.Type, handler: @escaping (T?, BaseErrorResponse?) -> Void) {
//        AF.request(req).responseData { responseData in
//            if responseData.response != nil {
//                switch responseData.result {
//                case .success(let data):
//                    
//                case .failure(let error):
//                }
//            }
//            else {
//                
//            }
//        }
//    }
    func downloadImgFromUrl(url: String, downloadCompletionHanler: @escaping (Data?, Error?) -> Void){
       AF.request(url, method: .get).response { response in
            switch response.result {
            case .success(let data):
                downloadCompletionHanler(data, nil)
            case .failure(let error):
                downloadCompletionHanler(nil, error)
            }
        }
    }
}

struct Request {
    var url: URLConvertible
    let method: HTTPMethod
    let headers: HTTPHeaders?
    var param: Parameters? = nil
}
