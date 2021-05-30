//
//  Environment.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 30/5/2564 BE.
//

import Foundation

struct Environment {
    
    #if TEST
        static let gitHubURL: URL = URL(string: "http://localhost:8080")!
    #else
        static let gitHubURL: URL = URL(string: "https://api.github.com")!
    #endif
}
