//
//  UserTableViewCell.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 25/5/2564 BE.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var gitURLLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var viewModel: UserItemViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessibilityIdentifier = String(describing: UserTableViewCell.self)
    }

    func configure(viewModel: UserItemViewModel){
        self.viewModel = viewModel
        userImageView.kf.setImage(with: viewModel.avatarURL)
        userNameLabel.text = viewModel.name
        gitURLLabel.text = viewModel.gitURL
        favoriteButton.isSelected = viewModel.isFavorite
    }
    
    @IBAction func favoriteDidSelect(_ sender: UIButton) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        viewModel.setFavorite(isFavorite: favoriteButton.isSelected)
    }
}
