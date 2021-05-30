//
//  Network.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 24/5/2564 BE.
//

import Moya

protocol Networkable {
    var provider: MoyaProvider<MultiTarget> { get }
    func request(_ target: MultiTarget, completion: @escaping Completion)
}

class Network: Networkable {
    
    let provider: MoyaProvider<MultiTarget>
    
    init() {
        let config = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let logger = NetworkLoggerPlugin(configuration: config)
        provider = .init(plugins: [logger])
    }
    
    func request(_ target: MultiTarget, completion: @escaping Completion) {
        provider.request(target, completion: completion)
    }
    
}
