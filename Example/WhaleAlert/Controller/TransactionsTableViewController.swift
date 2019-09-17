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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Transactions"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCellId", for: indexPath) as! TransactionTableViewCell
        
        let transaction = transactions[indexPath.row]
        cell.setup(withTransaction: transaction)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
