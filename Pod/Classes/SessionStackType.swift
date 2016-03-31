//
//  SessionStack.swift
//  Pods
//
//  Created by muukii on 3/31/16.
//
//

import Foundation
import Alamofire

public protocol SessionStackType {
    
    var baseURLString: String { get }
    var defaultHeader: [String : String] { get }
    var defaultParameter: [String : AnyObject] { get }
    var manager: Alamofire.Manager { get }
}
