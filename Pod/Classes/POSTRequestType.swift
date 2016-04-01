// POSTRequestType.swift
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

public protocol POSTRequestType:
    PathRequestType,
    JSONResponseType,
    ManagerRequestType
{
    
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
