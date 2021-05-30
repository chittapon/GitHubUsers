//
//  UserListViewModelTests.swift
//  GitHubUsersTests
//
//  Created by Chittapon Thongchim on 28/5/2564 BE.
//

import XCTest
@testable import GitHubUsers

class UserListViewModelTests: XCTestCase {
    
    var viewModel: UserListViewModelInput!
    var output: MockUserListViewModelOutput!
    var mockUseCase: MockGitHubUseCase!
    
    override func setUp() {
        mockUseCase = MockGitHubUseCase()
        viewModel = UserListViewModel(gitHubUseCase: mockUseCase)
        output = MockUserListViewModelOutput()
        viewModel.config(output: output)
        super.setUp()
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func test_get_users_success() {
        // Given
        mockUseCase.users = []

        // When
        viewModel.getUserList()
        let mockUsers: [User] = MockJSON.fromFile(name: "mock_users.json")
        mockUseCase.onResponseUsers(.success(mockUsers))
    
        // Then
        XCTAssert(!output.users.isEmpty)
    }
    
    func test_get_users_fail() {
        // Given
        let error = MockGitHubUseCase.MockAPIError.badRequest

        // When
        viewModel.getUserList()
        mockUseCase.onResponseUsers(.failure(error))
    
        // Then
        XCTAssert(output.isShowErrorMessage)
    }
    
    func test_search_users_success() {
        // Given
        mockUseCase.users = []
        
        // When
        viewModel.searchUsers(keyword: "chittapon")
        let mockSearchResponse: SearchUserResponse = MockJSON.fromFile(name: "mock_search_users.json")
        mockUseCase.onSearchUsers(.success(mockSearchResponse.items!))
        
        // Then
        XCTAssert(!output.users.isEmpty)
    }
    
    func test_search_users_fail() {
        // Given
        let error = MockGitHubUseCase.MockAPIError.requestLimitation
        
        // When
        viewModel.searchUsers(keyword: "chittapon")
        mockUseCase.onSearchUsers(.failure(error))
        
        // Then
        XCTAssert(output.isShowErrorMessage)
    }
    
    func test_sort_by_ascending() {
        // Given
        viewModel.getUserList()
        let mockUsers: [User] = MockJSON.fromFile(name: "mock_sort_users.json")
        mockUseCase.onResponseUsers(.success(mockUsers))
        
        // When
        viewModel.sortBy(ascending: true)
        
        // Then
        let sorted = output.users.map { $0.name }
        XCTAssert(sorted == ["a", "b", "c"])
    }
    
    func test_sort_by_descending() {
        // Given
        viewModel.getUserList()
        let mockUsers: [User] = MockJSON.fromFile(name: "mock_sort_users.json")
        mockUseCase.onResponseUsers(.success(mockUsers))
        
        // When
        viewModel.sortBy(ascending: false)
        
        // Then
        let sorted = output.users.map { $0.name }
        XCTAssert(sorted == ["c", "b", "a"])
    }
    
    func test_filter_only_favorite() {
        // Given
        viewModel.getUserList()
        let mockUsers: [User] = MockJSON.fromFile(name: "mock_sort_users.json")
        mockUsers.first?.isFavorite = true
        mockUseCase.onResponseUsers(.success(mockUsers))
        
        // When
        viewModel.filterFavorite(active: true)
        
        // Then
        XCTAssert(output.users.count == 1)
    }
    
    func test_filter_not_favorite() {
        // Given
        viewModel.getUserList()
        let mockUsers: [User] = MockJSON.fromFile(name: "mock_sort_users.json")
        mockUseCase.onResponseUsers(.success(mockUsers))
        
        // When
        viewModel.filterFavorite(active: false)
        
        // Then
        XCTAssert(output.users.count == mockUsers.count)
    }
    
}

class MockUserListViewModelOutput: UserListViewModelOutput {
    
    var isShowErrorMessage: Bool = false
    var users: [UserItemViewModel] = []
    
    func displayUserList(users: [UserItemViewModel]) {
        self.users = users
    }
    
    func showErrorMessage(_ message: String) {
        isShowErrorMessage = true
    }
    
}

class MockGitHubUseCase: GitHubUseCaseProtocol {

    var isGetUsersCalled = false
    var users: [User] = []
    var onResponseUsers: ((Result<[User], Error>) -> Void)!
    var onSearchUsers: ((Result<[User], Error>) -> Void)!
    var isFilterOnlyFavorite = false
    var repos: [UserRepository] = []
    var onResponseRepositories: ((Result<[UserRepository], Error>) -> Void)!
    
    enum MockAPIError: Error {
        case badRequest
        case requestLimitation
    }
    
    func getUsers(onResponse: @escaping (Result<[User], Error>) -> Void) {
        isGetUsersCalled = true
        onResponseUsers = onResponse
    }
    
    func searchUsers(keyword: String, onResponse: @escaping (Result<[User], Error>) -> Void) {
        onSearchUsers = onResponse
    }
    
    func getFavoriteUsers() -> [User] {
        return []
    }
    
    func addFavorite(user: User) {
        
    }
    
    func removeFavorite(user: User) {
        
    }
    
    func getRepositories(userName: String, onResponse: @escaping (Result<[UserRepository], Error>) -> Void) {
        onResponseRepositories = onResponse
    }
    
}

class MockJSON<Model: Decodable> {
    
    static func fromFile(name: String) -> Model {
        return try! dataFromFile(name: name).decode(type: Model.self)
    }
    
}

func dataFromFile(name: String) -> Data {
    let url = Bundle(for: UserListViewModelTests.self).url(forAuxiliaryExecutable: name)
    return try! Data(contentsOf: url!)
}
