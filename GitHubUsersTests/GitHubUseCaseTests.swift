//
//  GitHubUseCaseTests.swift
//  GitHubUsersTests
//
//  Created by Chittapon Thongchim on 29/5/2564 BE.
//

import XCTest
@testable import GitHubUsers
import Moya

class GitHubUseCaseTests: XCTestCase {

    var useCase: GitHubUseCaseProtocol!
    var mockNetwork: MockNetwork!
    var mockUserDefault: MockUserDefaultRepository!
    
    override func setUp() {
        mockUserDefault = MockUserDefaultRepository()
        mockNetwork = MockNetwork(target: MockAPI(sampleData: Data()), provider: .init())
        useCase = GitHubUseCase(network: mockNetwork, userDefault: mockUserDefault)
        super.setUp()
    }

    override func tearDown() {
        mockNetwork = nil
        mockUserDefault = nil
        useCase = nil
        super.tearDown()
    }
    
    func test_get_users_success() {
        // Given
        useCase = makeUseCaseWithSuccessResponse(fileName: "mock_users.json")
        
        // When
        let expect = XCTestExpectation(description: "onResponse users")
        useCase.getUsers { (response) in
            switch response {
            case .success:
                expect.fulfill()
            case .failure:
                expect.isInverted = true
                expect.fulfill()
            }
        }
        
        // Then
        wait(for: [expect], timeout: 1)
    }
    
    func test_get_users_fail() {
        // Given
        useCase = makeUseCaseWithFailResponse(fileName: "mock_users_response_error.json")
        
        // When
        let expect = XCTestExpectation(description: "onResponse users")
        useCase.getUsers { (response) in
            switch response {
            case .success:
                expect.isInverted = true
                expect.fulfill()
                
            case .failure:
                expect.fulfill()
            }
        }
        
        // Then
        wait(for: [expect], timeout: 1)
    }
    
    func test_search_users_success() {
        // Given
        useCase = makeUseCaseWithSuccessResponse(fileName: "mock_search_users.json")
        
        // When
        let expect = XCTestExpectation(description: "onResponse users")
        useCase.searchUsers(keyword: "chittapon") { (response) in
            switch response {
            case .success:
                expect.fulfill()
                
            case .failure:
                expect.isInverted = true
                expect.fulfill()
            }
        }
        
        //Then
        wait(for: [expect], timeout: 1)
    }
    
    func test_search_users_fail() {
        // Given
        useCase = makeUseCaseWithFailResponse(fileName: "mock_search_users.json")
        
        // When
        let expect = XCTestExpectation(description: "onResponse users")
        useCase.searchUsers(keyword: "chittapon") { (response) in
            switch response {
            case .success:
                expect.isInverted = true
                expect.fulfill()
                
            case .failure:
                expect.fulfill()
            }
        }
        
        //Then
        wait(for: [expect], timeout: 1)
    }
    
    func test_get_repos_success() {
        // Given
        useCase = makeUseCaseWithSuccessResponse(fileName: "mock_repos.json")
        
        // When
        let expect = XCTestExpectation(description: "onResponse repos")
        useCase.getRepositories(userName: "chittapon") { (response) in
            switch response {
            case .success:
                expect.fulfill()
                
            case .failure:
                expect.isInverted = true
                expect.fulfill()
            }
        }
        
        // Then
        wait(for: [expect], timeout: 1)
    }
    
    func test_get_repos_fail() {
        // Given
        useCase = makeUseCaseWithFailResponse(fileName: "mock_users_response_error.json")
        
        // When
        let expect = XCTestExpectation(description: "onResponse users")
        useCase.getRepositories(userName: "chittapon") { (response) in
            switch response {
            case .success:
                expect.isInverted = true
                expect.fulfill()
                
            case .failure:
                expect.fulfill()
            }
        }
        
        // Then
        wait(for: [expect], timeout: 1)
    }
    
    func test_save_favorite_user() {
        // Given
        let user: User = MockJSON.fromFile(name: "mock_user.json")
        
        // When
        user.isFavorite = true
        useCase.addFavorite(user: user)
        
        // Then
        let favoriteUsers = useCase.getFavoriteUsers()
        XCTAssert(favoriteUsers.contains(user))
    }
    
    func test_remove_favorite_user() {
        // Given
        let user: User = MockJSON.fromFile(name: "mock_user.json")
        
        // When
        user.isFavorite = false
        useCase.removeFavorite(user: user)
        
        // Then
        let favoriteUsers = useCase.getFavoriteUsers()
        XCTAssert(!favoriteUsers.contains(user))
    }
    
    // MARK: - Helper
    
    func makeUseCaseWithSuccessResponse(fileName: String) -> GitHubUseCase {
        let mockReposAPI = MockAPI(sampleData: dataFromFile(name: fileName))
        let provider = MoyaProvider<MultiTarget>(stubClosure: { (target) -> StubBehavior in
            return .immediate
        })
        mockNetwork = MockNetwork(target: mockReposAPI, provider: provider)
        return GitHubUseCase(network: mockNetwork, userDefault: mockUserDefault)
    }
    
    func makeUseCaseWithFailResponse(fileName: String) -> GitHubUseCase {
        let sampleData = dataFromFile(name: fileName)
        let mockUsersAPI = MockAPI(sampleData: sampleData)
        let provider = MoyaProvider<MultiTarget>.init(endpointClosure: { (target) -> Endpoint in
            return .init(url: target.baseURL.absoluteString,
                         sampleResponseClosure: { () -> EndpointSampleResponse in
                            return .networkResponse(400, sampleData)
                         },
                         method: target.method,
                         task: target.task,
                         httpHeaderFields: target.headers)
        }, stubClosure: { (target) -> StubBehavior in
            return .immediate
        })
        mockNetwork = MockNetwork(target: mockUsersAPI, provider: provider)
        return GitHubUseCase(network: mockNetwork, userDefault: mockUserDefault)
    }
}


struct MockAPI: TargetType {
    
    var baseURL: URL = URL(string: "https://test.net")!
    var path: String = ""
    let method: Moya.Method = .get
    let sampleData: Data
    var task: Task = .requestPlain
    let headers: [String : String]? = nil
    var validationType: ValidationType = .successAndRedirectCodes
}

struct MockNetwork: Networkable {
    
    let provider: MoyaProvider<MultiTarget>
    let target: TargetType
    
    init(target: TargetType, provider: MoyaProvider<MultiTarget>) {
        self.target = target
        self.provider = provider
    }
    
    func request(_ target: MultiTarget, completion: @escaping Completion) {
        provider.request(.init(self.target), completion: completion)
    }
    
}

class MockUserDefaultRepository: UserDefaultRepositoryProtocol {
    
    let userDefaults = UserDefaults(suiteName: "MockUserDefaultRepository")!
    
    init() {}
    
    func data(forKey key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }
    
    func object<T>(forKey key: String) -> T? where T : Decodable {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func setData(_ data: Data, forKey key: String) {
        userDefaults.setValue(data, forKey: key)
    }
    
    func setObject<T>(object: T, forKey key: String) throws where T : Encodable {
        let data = try JSONEncoder().encode(object)
        setData(data, forKey: key)
    }
    
}
