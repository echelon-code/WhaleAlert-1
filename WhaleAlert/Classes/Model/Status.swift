//
//  Status.swift
//  WhaleAlert
//
//  Created by Ryan Cohen on 9/9/19.
//

import Foundation

public struct Status: Codable {
    public let result: String
    public let blockchains: [Blockchain]
}

public struct Blockchain: Codable {
    public enum StatusEnum: String, Codable {
        case connected
    }
    
    public let name: String
    public let symbols: [String]
    public let status: StatusEnum
}
