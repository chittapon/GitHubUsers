//
//  User.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 25/5/2564 BE.
//

import Foundation

class User: Codable, Hashable {
    
    let login: String
    let nodeId: String
    let avatarURL: String
    let reposURL: String
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case login
        case nodeId = "node_id"
        case avatarURL = "avatar_url"
        case reposURL = "repos_url"
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.nodeId == rhs.nodeId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(nodeId)
    }
}
