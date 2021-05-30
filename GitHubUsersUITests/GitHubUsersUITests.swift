//
//  GitHubUsersUITests.swift
//  GitHubUsersUITests
//
//  Created by Chittapon Thongchim on 24/5/2564 BE.
//

import XCTest
import Swifter

class GitHubUsersUITests: XCTestCase {

    var app: XCUIApplication!
    var server: HttpServer = HttpServer()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDown() {
        super.tearDown()
        server.stop()
    }

    func test_show_users_list() throws {
        server = HttpServer()
        server["/users"] = { request in
            let json = jsonFromFile(name: "mock_users.json")
            return .ok(.json(json))
        }
        
        try server.start()

        app = XCUIApplication()
        app.launch()
        
        XCTAssert(app.cells.firstMatch.identifier == "UserTableViewCell")
    }

    func test_show_error_message_on_user_list() throws {
        
        server = HttpServer()
        server["/users"] = { request in
            return .badRequest(nil)
        }
        
        try server.start()

        app = XCUIApplication()
        app.launch()
        
        XCTAssert(app.alerts.firstMatch.waitForExistence(timeout: 5))
    }
    
    func test_search_users() throws {
        
        let searchText = "chittapon"
        
        server = HttpServer()
        server["/users/"] = { request in
            let json = jsonFromFile(name: "mock_users.json")
            return .ok(.json(json))
        }
        
        server["/search/users"] = { request in
            let json = jsonFromFile(name: "mock_search_users.json")
            return .ok(.json(json))
        }
        
        try server.start()

        app = XCUIApplication()
        app.launch()
        
        app.searchFields.element.tap()
        app.searchFields.firstMatch.typeText(searchText)
        
        let targetCell = app.cells.staticTexts[searchText]
        XCTAssert(targetCell.waitForExistence(timeout: 5))
    }
    
    func test_show_repository_list() throws {
        
        let userName = "chittapon"
        
        server = HttpServer()
        server["/users/"] = { request in
            let json = jsonFromFile(name: "mock_users.json")
            return .ok(.json(json))
        }
        
        server["/search/users"] = { request in
            let json = jsonFromFile(name: "mock_search_users.json")
            return .ok(.json(json))
        }
        
        server["/users/\(userName)/repos"] = { request in
            let json = jsonFromFile(name: "mock_repos.json")
            return .ok(.json(json))
        }
        
        try server.start()

        app = XCUIApplication()
        app.launch()
        
        app.searchFields.element.tap()
        app.searchFields.firstMatch.typeText(userName)
        
        let userCell = app.cells.staticTexts[userName]
        userCell.tap()
        
        XCTAssert(app.cells["RepositoryTableViewCell"].waitForExistence(timeout: 5))
    }
}


func jsonFromFile(name: String) -> Any {
    let url = Bundle(for: GitHubUsersUITests.self).url(forAuxiliaryExecutable: name)!
    let data = try! Data(contentsOf: url)
    return try! JSONSerialization.jsonObject(with: data, options: [])
}
