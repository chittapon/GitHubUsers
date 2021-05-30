//
//  UserItemViewModel.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 25/5/2564 BE.
//

import Foundation

class UserItemViewModel {
    
    let name: String
    let avatarURL: URL?
    let gitURL: String
    let user: User
    var isFavorite: Bool { user.isFavorite }
    typealias OnUserFavoiteChanged = (_ user: User) -> Void
    let onUserFavoiteChanged: OnUserFavoiteChanged?
    
    init(user: User, onUserFavoiteChanged: OnUserFavoiteChanged? = nil) {
        self.user = user
        self.onUserFavoiteChanged = onUserFavoiteChanged
        name = user.login
        avatarURL = URL(string: user.avatarURL)
        gitURL = user.reposURL
    }
    
    func setFavorite(isFavorite: Bool){
        user.isFavorite = isFavorite
        onUserFavoiteChanged?(user)
    }
}
