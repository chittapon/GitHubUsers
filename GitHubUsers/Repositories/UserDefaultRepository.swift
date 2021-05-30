//
//  UserDefaultRepository.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 26/5/2564 BE.
//

import Foundation

protocol UserDefaultRepositoryProtocol {
    func data(forKey key: String) -> Data?
    func object<T: Decodable>(forKey key: String) -> T?
    func setData(_ data: Data, forKey key: String)
    func setObject<T: Encodable>(object: T, forKey key: String) throws
}

class UserDefaultRepository: UserDefaultRepositoryProtocol {
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
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
