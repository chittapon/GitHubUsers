//
//  UserListViewModel.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 25/5/2564 BE.
//

import Foundation

protocol UserListViewModelInput {
    func config(output: UserListViewModelOutput)
    func getUserList()
    func searchUsers(keyword: String)
    func filterFavorite(active: Bool)
    func sortBy(ascending: Bool)
}

protocol UserListViewModelOutput: class {
    func displayUserList(users: [UserItemViewModel])
    func showErrorMessage(_ message: String)
}

class UserListViewModel: UserListViewModelInput {
    
    weak var output: UserListViewModelOutput!
    
    private let gitHubUseCase: GitHubUseCaseProtocol
    private var favoriteActive: Bool = false
    private var searchActive: Bool = false
    private var ascending: Bool = true
    private var users: [User] = []
    private var searchResult: [User] = []
    
    init(gitHubUseCase: GitHubUseCaseProtocol = GitHubUseCase()) {
        self.gitHubUseCase = gitHubUseCase
    }
    
    func config(output: UserListViewModelOutput) {
        self.output = output
    }
    
    func getUserList() {
        gitHubUseCase.getUsers { [unowned self] (response) in
            switch response {
            case .success(let users):
                self.users = users
                let _users = self.mapUser(users: users,
                                          isFavorite: self.favoriteActive,
                                          ascending: self.ascending)
                self.output.displayUserList(users: _users)
            case .failure(let error):
                self.output.showErrorMessage(error.localizedDescription)
            }
        }
    }
    
    func filterFavorite(active: Bool) {
        favoriteActive = active
        let data = searchActive ? searchResult : users
        let filtered = mapUser(users: data, isFavorite: favoriteActive, ascending: ascending)
        output.displayUserList(users: filtered)
    }
    
    func sortBy(ascending: Bool) {
        self.ascending = ascending
        let data = searchActive ? searchResult : users
        let sorted = mapUser(users: data, isFavorite: favoriteActive, ascending: ascending)
        output.displayUserList(users: sorted)
    }
    
    func searchUsers(keyword: String) {
        
        guard !keyword.isEmpty else {
            searchActive = false
            filterFavorite(active: favoriteActive)
            return
        }
        searchActive = true
        gitHubUseCase.searchUsers(keyword: keyword) { [unowned self] (response) in
            switch response {
            case .success(let users):
                self.searchResult = users
                let _users = self.mapUser(users: users,
                                          isFavorite: self.favoriteActive,
                                          ascending: self.ascending)
                self.output.displayUserList(users: _users)
            case .failure(let error):
                if let errorResponse: SearchUserResponse = error.toErrorResponse(),
                   let message = errorResponse.message {
                    self.output.showErrorMessage(message)
                } else {
                    self.output.showErrorMessage(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Helper
    
    private func mapUser(users: [User],
                 isFavorite: Bool,
                 ascending: Bool) -> [UserItemViewModel] {
        
        return users.compactMap { (user) in
            
            guard user.isFavorite == isFavorite else { return nil }
            
            return UserItemViewModel(user: user, onUserFavoiteChanged: { [weak self] userChanged in
                if userChanged.isFavorite {
                    self?.gitHubUseCase.addFavorite(user: userChanged)
                } else {
                    self?.gitHubUseCase.removeFavorite(user: userChanged)
                }
            })
            
        }.sorted {
            if ascending {
                return ($0.name < $1.name)
            } else {
                return ($0.name > $1.name)
            }
        }
    }
}
