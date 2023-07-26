//
//  ATError.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation

public enum ATError: Error {
    case invalidUrl,
         unauthorised,
         unknown,
         decoding(message: String?)
}
