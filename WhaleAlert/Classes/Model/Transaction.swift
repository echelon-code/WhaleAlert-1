//
//  Transaction.swift
//  WhaleAlert
//
//  Created by Ryan Cohen on 9/9/19.
//

import Foundation

struct TransactionResponseData: Codable {
    let result: String
    let count: Int
    let cursor: String?
    let transactions: [Transaction]?
}

public struct Transaction: Codable {
    public let blockchain: String
    public let symbol: String
    public let id: String
    public let transactionType: String
    public let hash: String
    public let fromWallet: Wallet
    public let toWallet: Wallet
    public let timestamp: Int
    public let amount: Double
    public let amountUsd: Double
    public let transactionCount: Int
    
    enum CodingKeys: String, CodingKey {
        case blockchain, symbol, id, hash, timestamp, amount
        case fromWallet = "from"
        case toWallet = "to"
        case transactionType = "transaction_type"
        case amountUsd = "amount_usd"
        case transactionCount = "transaction_count"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        blockchain = try container.decode(String.self, forKey: .blockchain)
        symbol = try container.decode(String.self, forKey: .symbol)
        id = try container.decode(String.self, forKey: .id)
        hash = try container.decode(String.self, forKey: .hash)
        timestamp = try container.decode(Int.self, forKey: .timestamp)
        transactionType = try container.decode(String.self, forKey: .transactionType)
        transactionCount = try container.decode(Int.self, forKey: .transactionCount)
        fromWallet = try container.decode(Wallet.self, forKey: .fromWallet)
        toWallet = try container.decode(Wallet.self, forKey: .toWallet)
        
        // Amount value somtimes returns as integer
        if let value = try? container.decode(Int.self, forKey: .amount) {
            amount = Double(value)
        } else {
            amount = try container.decode(Double.self, forKey: .amount)
        }
        
        // Amount USD value somtimes returns as integer
        if let value = try? container.decode(Int.self, forKey: .amountUsd) {
            amountUsd = Double(value)
        } else {
            amountUsd = try container.decode(Double.self, forKey: .amountUsd)
        }
    }
}

public struct Wallet: Codable {
    public let address: String
    public let ownerType: String
    public let owner: String?
    
    enum CodingKeys: String, CodingKey {
        case address, owner
        case ownerType = "owner_type"
    }
}
