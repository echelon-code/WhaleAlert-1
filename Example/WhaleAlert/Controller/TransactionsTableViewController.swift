//
//  TransactionsTableViewController.swift
//  WhaleAlert_Example
//
//  Created by Ryan Cohen on 9/17/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WhaleAlert

class TransactionsTableViewController: UITableViewController {
    
    // MARK: - Attributes
    
    var transactions: [Transaction] = []
    
    private var sortAscending: Bool = true
    
    // MARK: - UI Functions -
    
    private func setupUI() {
        let sortBarButtonItem: UIBarButtonItem = .init(title: "Sort", style: .plain, target: self, action: #selector(tappedSortBarButtonItem))
        navigationItem.rightBarButtonItem = sortBarButtonItem
    }
    
    private func reloadTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
    
    // MARK: - Functions -
    
    private func sortByPrice(ascending: Bool) {
        ascending ? transactions.sort { $0.amountUsd < $1.amountUsd } : transactions.sort { $0.amountUsd > $1.amountUsd }
        reloadTableViewData()
    }
    
    // MARK: - Actions -
    
    @objc
    private func tappedSortBarButtonItem() {
        sortByPrice(ascending: sortAscending)
        sortAscending = !sortAscending
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tappedSortBarButtonItem()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Transaction\(transactions.count > 1 ? "s" : "")"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCellId", for: indexPath) as! TransactionTableViewCell
        
        let transaction = transactions[indexPath.row]
        cell.setup(withTransaction: transaction)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
