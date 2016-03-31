//
//  RequestContext+Rx.swift
//  Product
//
//  Created by muukii on 3/25/16.
//  Copyright © 2016 eure. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

import BrickRequest

extension RequestContextType where Self: ResponseType, Self: RequestType, Self.ResponseError == AppRequestError {

    public func resume() -> Observable<Self.SerializedObject> {
        return Observable.create { observer in
            
            let request = self.create { (response: Alamofire.Response<SerializedObject, ResponseError>) in
                
                switch response.result {
                case .Success(let value):
                    
                    observer.onNext(value)
                    observer.onCompleted()
                    
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            
            request.resume()
            
            return AnonymousDisposable {
                
                request.cancel()
            }
        }
        .retryOnBecomesReachable(ReachabilityService.sharedReachabilityService)
    }
}
