//
//  BaseErrorResponse.swift
//  TMDB
//
//  Created by acupofstarbugs on 07/03/2023.
//

import Foundation

struct BaseErrorResponse{
    var errorType: ErrorType
    var errorCode: Int
    var errorMsg: String
}

enum ErrorType {
    case HTTP_ERROR, API_ERROR
}
