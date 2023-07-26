//
//  ATHTTPMethod.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation

/**
 This enum provides string values for each of the supported HTTP methods.
 
 You can access each string values via the rawValue or as a function.
 */
public enum ATHTTPMethod: String {
    case delete = "DELETE",
         get = "GET",
         patch = "PATCH",
         post = "POST",
         put = "PUT"
    
    func callAsFunction() -> String {
        rawValue
    }
}
