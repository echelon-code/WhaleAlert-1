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
        debugPrint("whaleAlertDidReceiveStatus: \(String(describing: status)).")
    }
    
    func whaleAlertDidReceiveTransactions(_ transactions: [Transaction]?) {
        debugPrint("whaleAlertDidReceiveTransaction(s): \(String(describing: transactions)).")
    }
}
