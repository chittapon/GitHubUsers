//
//  RepositoryListViewController.swift
//  GitHubUsers
//
//  Created by Chittapon Thongchim on 26/5/2564 BE.
//

import UIKit

class RepositoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: RepositoryListViewModelInput!
    lazy var userDetail = viewModel.getUserDetail()
    var repos: [UserRepository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.getRepositoryList()
    }

    private func setup() {
        viewModel.config(output: self)
        tableView.sectionHeaderHeight = 120
        tableView.register(cellType: UserTableViewCell.self)
        tableView.register(cellType: RepositoryTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension RepositoryListViewController: RepositoryListViewModelOutput {

    func displayReposList(repos: [UserRepository]) {
        self.repos = repos
        tableView.reloadData()
    }
    
    func showErrorMessage(_ message: String) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
}

extension RepositoryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RepositoryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let repo = repos[indexPath.row]
        cell.configure(repository: repo)
        return cell
    }
    
}

extension RepositoryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UserTableViewCell = tableView.dequeueReusableCell(for: IndexPath(index: section))
        header.isUserInteractionEnabled = false
        header.configure(viewModel: userDetail)
        return header
    }
}
