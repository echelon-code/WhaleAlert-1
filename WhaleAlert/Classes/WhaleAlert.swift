//
//  WhaleAlert.swift
//  WhaleAlert
//
//  Created by Ryan Cohen on 9/9/19.
//

import Foundation

public protocol WhaleAlertProtocol: AnyObject {
    
    /// Client did receive response with optional `Status` object.
    /// - Parameter status: Optional `Status` object.
    func whaleAlertDidReceiveStatus(_ status: Status?)
    
    /// Client did receive response with optional `Transaction` object.
    /// - Parameter transaction: Optional `Transaction` object.
    func whaleAlertDidReceiveTransaction(_ transaction: Transaction?)
    
    /// Client did receive response with optional array of `Transaction` objects.
    /// - Parameter transactions: Optional array of `Transaction` objects.
    func whaleAlertDidReceiveAllTransactions(_ transactions: [Transaction]?)
}

public class WhaleAlert {
    
    // MARK: - Attributes
    
    /// Delegate to receive request callbacks.
    weak var delegate: WhaleAlertProtocol?
    
    /// Networking helper.
    private let networking: Networking
    
    /// Supported blockchains.
    public enum BlockchainType: String {
        case bitcoin, ethereum, ripple, stellar, neo, eos, tron
    }
    
    // MARK: - Initialization
    
    /// Initialize with API key.
    ///
    /// - Parameters:
    ///   - apiKey: WhaleAlert API key.
    ///   - delegate: Delegate to receive request callbacks.
    public init(apiKey: String, delegate: WhaleAlertProtocol?) {
        self.networking = Networking(apiKey: apiKey)
    }
    
    // MARK: - Functions
    
    /// Shows the current status of Whale Alert. Response lists all currently tracked blockchains,
    /// currencies and the current status for each blockchain.
    /// If Whale Alert is currently receiving data from a blockchain the status will be listed as 'connected'.
    ///
    /// - Parameter block: Block returning an optional `Status` object.
    public func getStatus(_ block: (Callbacks.WhaleAlertStatusCallback)? = nil) {
        networking.getStatus { (status) in
            if let block = block {
                block(status)
                return
            }
            
            self.delegate?.whaleAlertDidReceiveStatus(status)
        }
    }
    
    /// Returns the transaction from a specific blockchain by hash.
    /// If a transaction consists of multiple OUTs, it is split into multiple transactions,
    /// provided the corresponding OUT is of high enough value (>= $10 USD).
    ///
    /// - Parameters:
    ///   - hash: The hash of the transaction to return.
    ///   - blockchain: The blockchain to search for the specific hash.
    ///   - block: Block returning an optional `Transaction` object.
    public func getTransaction(withHash hash: String, fromBlockchain blockchain: BlockchainType,
                               block: (Callbacks.WhaleAlertTransactionCallback)? = nil) {
        
        networking.getTransaction(withHash: hash, fromBlockchain: blockchain) { (transaction) in
            if let block = block {
                block(transaction)
                return
            }
            
            self.delegate?.whaleAlertDidReceiveTransaction(transaction)
        }
    }
    
    /// Returns transactions with timestamp after a set start time (excluding) in order in
    /// which they were added to our database. This timestamp is the execution time of the transaction
    /// on its respective blockchain. Some transactions might be reported with a small delay.
    ///
    /// - Parameter block: Block returning an optional array of `Transaction` objects.
    public func getAllTransactions(_ block: (Callbacks.WhaleAlertAllTransactionsCallback)? = nil) {
        networking.getAllTransactions { (transactions) in
            if let block = block {
                block(transactions)
                return
            }
            
            self.delegate?.whaleAlertDidReceiveAllTransactions(transactions)
        }
    }
}
