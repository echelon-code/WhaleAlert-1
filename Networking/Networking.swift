//
//  Networking.swift
//  WhaleAlert
//
//  Created by Ryan Cohen on 9/9/19.
//

import Foundation

protocol NetworkingProtocol: AnyObject {
    
    /// Client did receive response with optional `Data` and `Error` objects.
    /// - Parameter data: Optional `Data` objects.
    /// - Parameter error: Optional `Error` object.
    func didReceiveData(_ data: Data?, error: Error?)
}

class Networking {
    
    // MARK: - Attributes
    
    /// Networking delegate.
    weak var delegate: NetworkingProtocol?
    
    /// User private API key.
    private let apiKey: String?
    
    enum Endpoint: CustomStringConvertible {
        case base
        case status
        case transaction(String, String)
        case allTransactions
        
        static let baseURL: String = "https://api.whale-alert.io/v1"
        
        var description: String {
            switch self {
            case .base:
                return Endpoint.baseURL
            case .status:
                return "\(Endpoint.baseURL)/status"
            case .transaction(let blockchain, let hash):
                return "\(Endpoint.baseURL)/transaction/\(blockchain)/\(hash)"
            case .allTransactions:
                return "\(Endpoint.baseURL)/transactions"
            }
        }
    }
    
    enum NetworkingError: Error {
        case missingAPIKey
        case missingResponse
        case other(String)
    }
    
    // MARK: - Initialization
    
    /// Initializes networking helper with personal API key.
    /// - Parameter apiKey: WhaleAlert API key.
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - Functions
    
    /// Get the current status of Whale Alert.
    /// - Parameter block: Block returning an optional `Status` object.
    func getStatus(_ block: @escaping Callbacks.WhaleAlertStatusCallback) {
        request(.status) { (status: Status?, error: Error?) in
            block(status)
        }
    }
    
    /// Returns the transaction from a specific blockchain by hash.
    /// - Parameter hash: Transaction hash.
    /// - Parameter blockchain: `BlockchainType` value.
    /// - Parameter block: Block returning an optional `Transaction` object.
    func getTransaction(withHash hash: String,
                        fromBlockchain blockchain: WhaleAlert.BlockchainType,
                        block: @escaping Callbacks.WhaleAlertTransactionCallback) {
        
        request(.transaction(hash, blockchain.rawValue)) { (transaction: Transaction?, error: Error?) in
            block(transaction)
        }
    }
    
    /// Returns transactions with timestamp after a set start time.
    /// - Parameter block: Block returning an optional array of `Transaction` objects.
    func getAllTransactions(_ block: @escaping Callbacks.WhaleAlertAllTransactionsCallback) {
        request(.allTransactions) { (transactions: [Transaction]?, error: Error?) in
            block(transactions)
        }
    }
}

// MARK: - Helper

extension Networking {
    
    private func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (_ object: T?, _ error: NetworkingError?) -> ()) {
        guard let apiKey = apiKey else {
            completion(nil, .missingAPIKey)
            return
        }
        
        var request: URLRequest = URLRequest(url: URL(string: endpoint.description)!)
        request.setValue(apiKey, forHTTPHeaderField: "X-WA-API-KEY")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, .missingResponse)
                return
            }
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                guard let jsonObject = jsonObject else {
                    completion(nil, nil)
                    return
                }
                
                if let result = jsonObject["result"] as? String, let message = jsonObject["message"] as? String {
                    completion(nil, .other("Result: \(result) | Message: \(message)."))
                }
            }
            
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(object, nil)
            } catch {
                debugPrint("Error decoding JSON object for \(String(describing: endpoint)): \(error.localizedDescription)")
                completion(nil, .other(error.localizedDescription))
            }
        }.resume()
    }
}
