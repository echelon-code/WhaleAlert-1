//
//  TransactionTableViewCell.swift
//  WhaleAlert_Example
//
//  Created by Ryan Cohen on 9/17/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WhaleAlert

class TransactionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var transactionSymbolAndAmountLabel: UILabel!
    @IBOutlet weak var transactionAmountUSDLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    
    // MARK: - Functions
    
    func setup(withTransaction transaction: Transaction) {
        DispatchQueue.main.async { [weak self] in
            let transactionSymbolUppercased: String = transaction.symbol.uppercased()
            let transactionAmount: String = "\(transaction.amount)"
            self?.transactionSymbolAndAmountLabel.text = "\(transactionAmount) \(transactionSymbolUppercased)"
            
            let currencyFormatter: NumberFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            
            if let formattedCurrencyAmount = currencyFormatter.string(from: NSNumber(value: transaction.amountUsd)) {
                self?.transactionAmountUSDLabel.text = formattedCurrencyAmount
            }
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            
            let date: Date = Date(timeIntervalSince1970: TimeInterval(exactly: transaction.timestamp)!)
            self?.transactionDateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    // MARK: - Private Functions
    
    private func setupUI() {
        self.selectionStyle = .none
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}
