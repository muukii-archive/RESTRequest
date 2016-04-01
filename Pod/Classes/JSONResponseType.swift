// JSONResponseType.swift
//
// Copyright (c) 2015 muukii
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

import Alamofire
import BrickRequest
import SwiftyJSON

public protocol JSONResponseType: ResponseType {}

private let ErrorCodesForRetry = Set<Int>([
    NSURLErrorNetworkConnectionLost,
    NSURLErrorNetworkConnectionLost,
    NSURLErrorNotConnectedToInternet
    ])

extension JSONResponseType {
    
    public var responseSerializer: Alamofire.ResponseSerializer<JSON, RESTRequestError> {
        return ResponseSerializer<JSON, RESTRequestError> { request, response, data, error in
            
            if let error = error {
                
                if ErrorCodesForRetry.contains(error.code) {
                    
                    return .Failure(RESTRequestError.LostConnection)
                }
                
                return .Failure(RESTRequestError.UnknownError)
            }
            
            guard let data = data, let response = response where error == nil else {
                
                return .Failure(RESTRequestError.LostData)
            }
            
            let json = JSON(data: data)
            guard json != JSON.null || request?.HTTPMethod == "DELETE" else {
                
                return .Failure(RESTRequestError.NotJSONResponse)
            }
            
            let statusCode = response.statusCode
            switch statusCode {
            case 200..<300:
                return .Success(json)
            case 300..<400:
                assertionFailure("status code 300..<400 not handled")
                fallthrough
            default: // 400 and over
                
                return .Failure(RESTRequestError.UnknownError)
            }
        }
    }
}