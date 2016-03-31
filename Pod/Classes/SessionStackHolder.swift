//
//  SessionStackHolder.swift
//  Pods
//
//  Created by muukii on 4/1/16.
//
//

import Foundation

public enum SessionStackHolder {
    static var sessionStack: SessionStackType = AnonymousSessionStack()
}
