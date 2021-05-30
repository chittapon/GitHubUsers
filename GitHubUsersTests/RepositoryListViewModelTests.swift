//
//  RepositoryListViewModelTests.swift
//  GitHubUsersTests
//
//  Created by Chittapon Thongchim on 29/5/2564 BE.
//

import XCTest
@testable import GitHubUsers

class RepositoryListViewModelTests: XCTestCase {

    var viewModel: RepositoryListViewModelInput!
    var output: MockRepositoryListViewModelOutput!
    var mockUseCase: MockGitHubUseCase!
    let user: User = MockJSON.fromFile(name: "mock_user.json")
    
    override func setUp() {
        mockUseCase = MockGitHubUseCase()
        viewModel = RepositoryListViewModel(user: user, gitHubUseCase: mockUseCase)
        output = MockRepositoryListViewModelOutput()
        viewModel.config(output: output)
        super.setUp()
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }

    func test_user_detail() {
        // Given
        let viewModel = self.viewModel!
        
        // When
        let userDetail = viewModel.getUserDetail()
        
        // Then
        XCTAssert(userDetail.user == user)
    }
    
    func test_get_repositories_success() {
        // Given
        mockUseCase.repos = []
        
        // When
        viewModel.getRepositoryList()
        let mockRepos: [UserRepository] = MockJSON.fromFile(name: "mock_repos.json")
        mockUseCase.onResponseRepositories(.success(model: mockRepos))
        
        // Then
        XCTAssert(!output.repos.isEmpty)
    }
    
    func test_get_repositories_fail() {
        // Given
        let error = MockGitHubUseCase.MockAPIError.badRequest
        
        // When
        viewModel.getRepositoryList()
        mockUseCase.onResponseRepositories(.failure(error: error))
        
        // Then
        XCTAssert(output.isShowErrorMessage)
    }
    
    
}

class MockRepositoryListViewModelOutput: RepositoryListViewModelOutput {
    
    var repos: [UserRepository] = []
    var isShowErrorMessage: Bool = false
    
    func displayReposList(repos: [UserRepository]) {
        self.repos = repos
    }
    
    func showErrorMessage(_ message: String) {
        isShowErrorMessage = true
    }
    
}
