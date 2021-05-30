//
//  Data+Extension.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 25/5/2564 BE.
//

import Foundation

extension Data {
    
    func decode<Model: Decodable>(type: Model.Type = Model.self) throws -> Model {
        return try JSONDecoder().decode(Model.self, from: self)
    }
    
}
