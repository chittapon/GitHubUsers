//
//  RepositoryListViewModel.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 26/5/2564 BE.
//

import Foundation

protocol RepositoryListViewModelInput {
    func config(output: RepositoryListViewModelOutput)
    func getUserDetail() -> UserItemViewModel
    func getRepositoryList()
}

protocol RepositoryListViewModelOutput: class {
    func displayReposList(repos: [UserRepository])
    func showErrorMessage(_ message: String)
}

class RepositoryListViewModel: RepositoryListViewModelInput {
    
    weak var output: RepositoryListViewModelOutput!
    
    private let gitHubUseCase: GitHubUseCaseProtocol
    private let user: User
    
    init(user: User, gitHubUseCase: GitHubUseCaseProtocol = GitHubUseCase()) {
        self.user = user
        self.gitHubUseCase = gitHubUseCase
    }
    
    func config(output: RepositoryListViewModelOutput) {
        self.output = output
    }
    
    func getRepositoryList() {
        
        gitHubUseCase.getRepositories(userName: user.login, onResponse: { [weak self] response in
            switch response {
            case .success(let repos):
                self?.output.displayReposList(repos: repos)
            case .failure:
                self?.output.showErrorMessage("Could not get repositories.\nPlease try again later.")
            }
        })
        
    }
    
    func getUserDetail() -> UserItemViewModel {
        return UserItemViewModel(user: user)
    }
}
