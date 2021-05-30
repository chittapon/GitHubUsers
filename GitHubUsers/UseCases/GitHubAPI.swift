//
//  GitHubAPI.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 24/5/2564 BE.
//

import Foundation
import Moya

struct GitHubAPI: TargetType {
    
    let baseURL: URL = Environment.gitHubURL
    var path: String
    var method: Moya.Method
    var sampleData: Data
    var task: Task
    let headers: [String : String]? = ["Accept": "application/vnd.github.v3+json"]
    let validationType: ValidationType = .successAndRedirectCodes
    
    static func userList() -> GitHubAPI {
        return .init(path: "/users",
                     method: .get,
                     sampleData: Data(),
                     task: .requestPlain)
    }
    
    static func search(keyword: String) -> GitHubAPI {
        return .init(path: "/search/users",
                     method: .get,
                     sampleData: Data(),
                     task: .requestParameters(parameters: ["q": keyword], encoding: URLEncoding.default))
    }
    
    static func repoList(userName: String) -> GitHubAPI {
        return .init(path: "/users/\(userName)/repos",
                     method: .get,
                     sampleData: Data(),
                     task: .requestPlain)
    }
}
