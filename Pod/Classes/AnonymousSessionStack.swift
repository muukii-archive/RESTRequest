//
//  AnonymousSessionStack.swift
//  Pods
//
//  Created by muukii on 4/1/16.
//
//

import Foundation
import Alamofire

public struct AnonymousSessionStack: SessionStackType {
    
    public var baseURLString: String {
        fatalError("AnonymousSessionStack is dummy class")
    }
    
    public var defaultHeader: [String : String] {
        fatalError("AnonymousSessionStack is dummy class")
    }
    
    public var defaultParameter: [String : AnyObject] {
        fatalError("AnonymousSessionStack is dummy class")
    }
    
    public var manager: Alamofire.Manager {
        fatalError("AnonymousSessionStack is dummy class")
    }
}