// RESTRequest.swift
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

import Alamofire
import BrickRequest
import SwiftyJSON

public enum AppRequestError: ErrorType {
    
    public typealias StatusCode = Int
    
    case NotJSONResponse
    case LostData
    case UnknownError
    case LostConnection
}

public protocol PathRequestType: RequestType {
    
    var path: String { get }
    var parameterJSON: JSON { get }
    var header: [String : String] { get }
}

extension PathRequestType {
    
    public var URLString: String {
        return (SessionStackHolder.sessionStack.baseURLString as NSString).stringByAppendingPathComponent(self.path)
    }
    
    var combinedDefaultParameterJSON: JSON {
        
        var json = self.parameterJSON
        let defaultParameter = SessionStackHolder.sessionStack.defaultParameter
        
        for param in defaultParameter {
            json[param.0] = JSON(param.1)
        }
        
        return json
    }
    
    public var header: [String : String] {
        return [:]
    }
    
    var combinedDefaultHeader: [String : String] {
        
        var header = self.header
        for param in SessionStackHolder.sessionStack.defaultHeader {
            header[param.0] = param.1
        }
        return header
    }
}

public protocol APISessionRequestType: RequestType {}

extension APISessionRequestType {
    
    public var manager: Manager {
        return SessionStackHolder.sessionStack.manager
    }
}

public protocol JSONResponseType: ResponseType {}

public protocol GETRequestType: PathRequestType, JSONResponseType, APISessionRequestType {
    
}

extension GETRequestType {
    public var method: Alamofire.Method {
        return .GET
    }
    
    public func createRequest(method method: Alamofire.Method, URLString: String, manager: Manager) -> Request {
        
        guard let parameters = self.combinedDefaultParameterJSON.dictionaryObject else {
            preconditionFailure("Failed to convert to dictonary")
        }
        let header = self.combinedDefaultHeader
        let request = manager.request(method, URLString, parameters: parameters, encoding: .URL, headers: header)
        return request
    }
}

public protocol DELETERequestType: PathRequestType, JSONResponseType, APISessionRequestType {
    
}

extension DELETERequestType {
    public var method: Alamofire.Method {
        return .DELETE
    }
    
    public func createRequest(method method: Alamofire.Method, URLString: String, manager: Manager) -> Request {
        
        guard let parameters = self.combinedDefaultParameterJSON.dictionaryObject else {
            preconditionFailure("Failed to convert to dictonary")
        }
        let header = self.combinedDefaultHeader
        let request = manager.request(method, URLString, parameters: parameters, encoding: .URL, headers: header)
        return request
    }
}

public protocol PUTRequestType: PathRequestType, JSONResponseType, APISessionRequestType {
    
}

extension PUTRequestType {
    public var method: Alamofire.Method {
        return .PUT
    }
    
    public func createRequest(method method: Alamofire.Method, URLString: String, manager: Manager) -> Request {
        
        guard let parameters = self.parameterJSON.dictionaryObject else {
            preconditionFailure("Failed to convert to dictonary")
        }
        let header = self.combinedDefaultHeader
        let request = manager.request(method, URLString, parameters: parameters, encoding: .JSON, headers: header)
        return request
    }
}

public protocol POSTRequestType: PathRequestType, JSONResponseType, APISessionRequestType {
    
}

extension POSTRequestType {
    public var method: Alamofire.Method {
        return .POST
    }
    
    public func createRequest(method method: Alamofire.Method, URLString: String, manager: Manager) -> Request {
        
        let parameters = self.combinedDefaultParameterJSON.dictionaryObject
        let header = self.combinedDefaultHeader
        let request = manager.request(method, URLString, parameters: parameters, encoding: .JSON, headers: header)
        return request
    }
}

private let ErrorCodesForRetry = Set<Int>([
    NSURLErrorNetworkConnectionLost,
    NSURLErrorNetworkConnectionLost,
    NSURLErrorNotConnectedToInternet
    ])

extension JSONResponseType {
    
    public var responseSerializer: Alamofire.ResponseSerializer<JSON, AppRequestError> {
        return ResponseSerializer<JSON, AppRequestError> { request, response, data, error in
            
            if let error = error {
                
                if ErrorCodesForRetry.contains(error.code) {
                    
                    return .Failure(AppRequestError.LostConnection)
                }
                
                return .Failure(AppRequestError.UnknownError)
            }
            
            guard let data = data, let response = response where error == nil else {
                
                return .Failure(AppRequestError.LostData)
            }
            
            let json = JSON(data: data)
            guard json != JSON.null || request?.HTTPMethod == "DELETE" else {
                
                return .Failure(AppRequestError.NotJSONResponse)
            }
            
            let statusCode = response.statusCode
            switch statusCode {
            case 200..<300:
                return .Success(json)
            case 300..<400:
                assertionFailure("status code 300..<400 not handled")
                fallthrough
            default: // 400 and over
                
                return .Failure(AppRequestError.UnknownError)
            }
        }
    }
}
