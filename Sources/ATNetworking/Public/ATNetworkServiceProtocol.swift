//
//  ATNetworkService.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation

protocol ATNetworkServiceProtocol: AnyObject {
    func request<T: Decodable>(endpoint: String, type: T.Type) -> Result<Error, T>
}
