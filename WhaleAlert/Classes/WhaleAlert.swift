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
    func whaleAlertDidReceiveStatus(_ status: Status?, _ error: WhaleAlertError?)
    
    /// Client did receive response with optional array of `Transaction` objects.
    /// - Parameter transaction: Optional array of `Transaction` objects.
    func whaleAlertDidReceiveTransactions(_ transactions: [Transaction]?, _ error: WhaleAlertError?)
}

public class WhaleAlert {
    
    // MARK: - Attributes
    
    /// Delegate to receive request callbacks.
    public weak var delegate: WhaleAlertProtocol?
    
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
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
    /// Shows the current status of Whale Alert. Response lists all currently tracked blockchains,
    /// currencies and the current status for each blockchain.
    /// If Whale Alert is currently receiving data from a blockchain the status will be listed as 'connected'.
    ///
    /// - Parameter block: Block returning an optional `Status` object.
    public func getStatus(_ block: (Callbacks.WhaleAlertStatusCallback)? = nil) {
        networking.getStatus { status, error  in
            block?(status, error)
            self.delegate?.whaleAlertDidReceiveStatus(status, error)
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
                               block: (Callbacks.WhaleAlertTransactionsCallback)? = nil) {
        networking.getTransaction(withHash: hash, fromBlockchain: blockchain) { transaction, error in
            block?(transaction, error)
            self.delegate?.whaleAlertDidReceiveTransactions(transaction, error)
        }
    }
    
    /// Returns transactions with timestamp after a set start time (excluding) in order in
    /// which they were added to our database. This timestamp is the execution time of the transaction
    /// on its respective blockchain. Some transactions might be reported with a small delay.
    ///
    /// - Parameter start: Unix timestamp for retrieving transactions from timestamp (exclusive).
    ///   Retrieves transactions based on their execution time on the blockchain.
    /// - Parameter end: Unix timestamp for retrieving transactions until timestamp (inclusive).
    /// - Parameter cursor: Pagination key from the previous response. Recommended when retrieving transactions in intervals.
    /// - Parameter minUSDValue: Minimum USD value of transactions returned (value at time of transaction).
    ///   Allowed minimum value varies per plan ($500k for Free, $100k for Personal).
    /// - Parameter limit: Maximum number of results returned. Default 100, max 100.
    /// - Parameter currency: Returns transactions for a specific currency code. Returns all currencies by default.
    /// - Parameter block: Block returning an optional array of `Transaction` objects.
    public func getAllTransactions(fromDate: Date,
                                   toDate: Date? = nil,
                                   cursor: Int? = nil,
                                   minUSDValue: Int? = nil,
                                   limit: Int? = 100,
                                   currency: String? = nil,
                                   block: (Callbacks.WhaleAlertTransactionsCallback)? = nil) {
        
        networking.getAllTransactions(fromDate: fromDate, toDate: toDate, cursor: cursor, minUSDValue: minUSDValue, limit: limit, currency: currency) { transactions, error in
            block?(transactions, error)
            self.delegate?.whaleAlertDidReceiveTransactions(transactions, error)
        }
    }
}
