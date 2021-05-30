//
//  UserRepository.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 26/5/2564 BE.
//

import Foundation

class UserRepository: Decodable {
    let id: Int
    let name: String
    let owner: User
    let description: String?
}
