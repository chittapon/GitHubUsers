//
//  RepositoryTableViewCell.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 26/5/2564 BE.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell, NibReusable {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessibilityIdentifier = String(describing: RepositoryTableViewCell.self)
    }
    
    func configure(repository: UserRepository){
        textLabel?.text = repository.name
        detailTextLabel?.text = repository.description
    }
}
