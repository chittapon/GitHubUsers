//
//  GitHubUseCase.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 25/5/2564 BE.
//

import Foundation
import Moya

protocol GitHubUseCaseProtocol {
    func getUsers(onResponse: @escaping (Result<[User], Error>) -> Void)
    func searchUsers(keyword: String, onResponse: @escaping (Result<[User], Error>) -> Void)
    func getFavoriteUsers() -> [User]
    func addFavorite(user: User)
    func removeFavorite(user: User)
    func getRepositories(userName: String, onResponse: @escaping (Result<[UserRepository], Error>) -> Void)
}

class GitHubUseCase: GitHubUseCaseProtocol {
    
    let network: Networkable
    let userDefault: UserDefaultRepositoryProtocol
    
    init(network: Networkable = Network(),
         userDefault: UserDefaultRepositoryProtocol = UserDefaultRepository()) {
        self.network = network
        self.userDefault = userDefault
    }
    
    func getUsers(onResponse: @escaping (Result<[User], Error>) -> Void) {
        
        let target: MultiTarget = .init(GitHubAPI.userList())
        
        network.request(target) { [weak self] (result) in
            
            switch result {
            
            case .success(let response):
                do {
                    let users = try response.data.decode(type: [User].self)
                    let favoriteUsers = self?.getFavoriteUsers() ?? []
                    for user in users {
                        if favoriteUsers.contains(user){
                            user.isFavorite = true
                        }
                    }
                    onResponse(.success(users))
                } catch { onResponse(.failure(error)) }
                
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
        
    }
    
    func getFavoriteUsers() -> [User] {
        return userDefault.object(forKey: "users") ?? []
    }
    
    func addFavorite(user: User) {
        var users = Set(getFavoriteUsers())
        users.insert(user)
        try? userDefault.setObject(object: users, forKey: "users")
    }
    
    func removeFavorite(user: User) {
        var users = Set(getFavoriteUsers())
        users.remove(user)
        try? userDefault.setObject(object: users, forKey: "users")
    }
    
    func getRepositories(userName: String, onResponse: @escaping (Result<[UserRepository], Error>) -> Void) {
        
        let target: MultiTarget = .init(GitHubAPI.repoList(userName: userName))
        
        network.request(target) { (result) in
            
            switch result {
            
            case .success(let response):
                do {
                    let repos = try response.data.decode(type: [UserRepository].self)
                    onResponse(.success(repos))
                } catch { onResponse(.failure(error)) }
                
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
    
    func searchUsers(keyword: String, onResponse: @escaping (Result<[User], Error>) -> Void) {
        
        let target: MultiTarget = .init(GitHubAPI.search(keyword: keyword))
        
        network.request(target) { [weak self] (result) in
            
            switch result {
            
            case .success(let response):
                do {
                    let searchUsers = try response.data.decode(type: SearchUserResponse.self)
                    guard searchUsers.items != nil else {
                        onResponse(.failure(MoyaError.jsonMapping(response)))
                        return
                    }
                    let users = searchUsers.items ?? []
                    let favoriteUsers = self?.getFavoriteUsers() ?? []
                    for user in users {
                        if favoriteUsers.contains(user){
                            user.isFavorite = true
                        }
                    }
                    onResponse(.success(users))
                } catch { onResponse(.failure(error)) }
                
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
}
