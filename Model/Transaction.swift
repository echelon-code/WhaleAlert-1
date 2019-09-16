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
    let transactions: [Transaction]
}

public struct Transaction: Codable {
    let blockchain: String
    let symbol: String
    let transactionType: String
    let hash: String
    let from: From
    let to: To
    let timestamp: Int
    let amount: Int
    let amountUsd: Double
    let transactionCount: Int
    
    enum CodingKeys: String, CodingKey {
        case blockchain, symbol, hash, from, to, timestamp, amount
        case transactionType = "transaction_type"
        case amountUsd = "amount_usd"
        case transactionCount = "transaction_count"
    }
}

public struct From: Codable {
    let address: String
    let owner: String
    let ownerType: String
    
    enum CodingKeys: String, CodingKey {
        case address, owner
        case ownerType = "owner_type"
    }
}

public struct To: Codable {
    let address: String
    let ownerType: String
    
    enum CodingKeys: String, CodingKey {
        case address
        case ownerType = "owner_type"
    }
}
