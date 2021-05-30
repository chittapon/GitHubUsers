//
//  Error+Extension.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 26/5/2564 BE.
//

import Foundation
import Moya

extension Error {
    
    func toErrorResponse<Model: Decodable>(type: Model.Type = Model.self) -> Model? {
        guard let moyaError = self as? MoyaError,
              let data = moyaError.response?.data else { return nil }
        return try? data.decode(type: Model.self)
    }
}
