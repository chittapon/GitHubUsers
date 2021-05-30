//
//  UserListViewController.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 25/5/2564 BE.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortSegmentControl: UISegmentedControl!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: UserListViewModelInput = UserListViewModel()
    private var users: [UserItemViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.getUserList()
    }
    
    private func setup() {
        viewModel.config(output: self)
        tableView.register(cellType: UserTableViewCell.self)
        tableView.rowHeight = 120
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    private func showRepositoryList(item: UserItemViewModel) {
        let indentifier = String(describing: RepositoryListViewController.self)
        let vc = storyboard?.instantiateViewController(withIdentifier: indentifier) as? RepositoryListViewController
        vc?.viewModel = RepositoryListViewModel(user: item.user)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func favoriteDidTap(_ sender: UISwitch) {
        viewModel.filterFavorite(active: sender.isOn)
    }
    
    @IBAction func sortDidSelect(_ sender: UISegmentedControl) {
        viewModel.sortBy(ascending: sender.selectedSegmentIndex == 0)
    }
}

extension UserListViewController: UserListViewModelOutput {
    
    func displayUserList(users: [UserItemViewModel]) {
        self.users = users
        tableView.reloadData()
    }
    
    func showErrorMessage(_ message: String) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
}

extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(viewModel: users[indexPath.row])
        return cell
    }
    
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = users[indexPath.row]
        showRepositoryList(item: item)
    }
}

extension UserListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchUsers(keyword: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
