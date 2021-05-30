//
//  Reusable.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 25/5/2564 BE.
//

import UIKit

protocol NibReusable {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension NibReusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    static var nib: UINib? {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) where T: NibReusable {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: NibReusable {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self)")
        }
        return cell
    }
    
}


