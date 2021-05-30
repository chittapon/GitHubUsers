//
//  SearchUserResponse.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 26/5/2564 BE.
//

import Foundation

class SearchUserResponse: Decodable {
    let items: [User]?
    let message: String?
}
