//
//  ViewController.swift
//  WhaleAlert
//
//  Created by Ryan Cohen on 09/09/2019.
//  Copyright (c) 2019 Ryan Cohen. All rights reserved.
//

import UIKit
import WhaleAlert

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    // MARK: - Attributes
    
    private lazy var whaleAlert: WhaleAlert = {
        return WhaleAlert(apiKey: "your-api-key", delegate: self)
    }()
    
    private var transactions: [Transaction] = []
    private var status: Status?
    
    // MARK: - IBAction
    
    @IBAction private func getStatus() {
        whaleAlert.getStatus()
    }
    
    @IBAction private func getTransaction() {
        whaleAlert.getTransaction(withHash: "4410c8d14ff9f87ceeed1d65cb58e7c7b2422b2d7529afc675208ce2ce09ed7d", fromBlockchain: .bitcoin)
    }
    
    @IBAction private func getAllTransactions() {
        let pastHour: Date = Date().addingTimeInterval(-3600)
        whaleAlert.getAllTransactions(fromDate: pastHour)
    }
    
    // MARK: - Private Functions
    
    private func setupUI() {
        buttonStackView.subviews.forEach {
            $0.layer.cornerRadius = 4.0
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TransactionsTableViewController
        destinationViewController.transactions = transactions
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - WhaleAlertProtocol

extension ViewController: WhaleAlertProtocol {
    
    func whaleAlertDidReceiveStatus(_ status: Status?) {
        if let status = status {
            self.status = status
            
            var enabledBlockchains: [String] = []
            for blockchain in status.blockchains {
                enabledBlockchains.append(blockchain.name)
            }
            showAlert(title: "Success", message: "Enabled blockchains: \(enabledBlockchains.joined(separator: ", ")).")
        } else {
            showAlert(title: "Error", message: "No status found.")
        }
        
        debugPrint("whaleAlertDidReceiveStatus: \(String(describing: status)).")
    }
    
    func whaleAlertDidReceiveTransactions(_ transactions: [Transaction]?) {
        if let transactions = transactions {
            self.transactions = transactions
            
            DispatchQueue.main.async { [weak self] in
                self?.performSegue(withIdentifier: "kSegueToTransactions", sender: nil)
            }
        } else {
            showAlert(title: "Error", message: "No transaction(s) found.")
        }
        
        debugPrint("whaleAlertDidReceiveTransaction(s): \(String(describing: transactions)).")
    }
}
