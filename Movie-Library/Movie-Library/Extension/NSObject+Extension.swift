//
//  NSObject+Extension.swift
//  Movie-Library
//
//  Created by Sabbir Hossain on 27/9/22.
//

import Foundation

// The extension to get the className as a variable
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
