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
                return Self.baseURL
            case .status:
                return "\(Self.baseURL)/status"
            case .transaction(let blockchain, let hash):
                return "\(Self.baseURL)/transaction/\(blockchain)/\(hash)"
            case .allTransactions:
                return "\(Self.baseURL)/transactions"
            }
        }
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
        request(.status) { (status: Status?, error: WhaleAlertError?) in
            block(status, error)
        }
    }
    
    /// Returns the transaction from a specific blockchain by hash.
    /// - Parameter hash: Transaction hash.
    /// - Parameter blockchain: `BlockchainType` value.
    /// - Parameter block: Block returning an optional `Transaction` object.
    func getTransaction(withHash hash: String,
                        fromBlockchain blockchain: WhaleAlert.BlockchainType,
                        block: @escaping Callbacks.WhaleAlertTransactionsCallback) {
        
        request(.transaction(blockchain.rawValue, hash)) { (transactionResponseData: TransactionResponseData?, error: WhaleAlertError?) in
            block(transactionResponseData?.transactions, error)
        }
    }
    
    /// Returns transactions with timestamp after a set start time.
    /// - Parameter block: Block returning an optional array of `Transaction` objects.
    func getAllTransactions(fromDate: Date,
                            toDate: Date? = nil,
                            cursor: Int? = nil,
                            minUSDValue: Int? = nil,
                            limit: Int? = 100,
                            currency: String? = nil,
                            block: @escaping Callbacks.WhaleAlertTransactionsCallback) {
        
        let parameters: [String: Any?] = [
            "start": Int(fromDate.timeIntervalSince1970),
            "end": (toDate != nil) ? Int(toDate!.timeIntervalSince1970) : nil,
            "cursor": cursor,
            "min_value": minUSDValue,
            "limit": limit,
            "currency": currency
        ]
        
        request(.allTransactions, parameters: parameters) { (transactionResponseData: TransactionResponseData?, error: WhaleAlertError?) in
            block(transactionResponseData?.transactions, error)
        }
    }
}

// MARK: - Helper

extension Networking {
    
    private func request<T: Decodable>(_ endpoint: Endpoint, parameters: [String: Any?]? = nil, completion: @escaping (_ object: T?, _ error: WhaleAlertError?) -> ()) {
        guard let apiKey = apiKey else {
            completion(nil, .missingAPIKey)
            return
        }
        
        let urlString: String = "\(endpoint.description)?api_key=\(apiKey)"
        var urlComponents: URLComponents = URLComponents(string: urlString)!
        
        if let parameters = parameters {
            let cleanedParameters = parameters.compactMapValues({ $0 })
            
            for parameter in cleanedParameters {
                let queryItem: URLQueryItem = URLQueryItem(name: parameter.key, value: String(describing: parameter.value))
                urlComponents.queryItems?.append(queryItem)
            }
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: urlComponents.url!)) { (data, response, error) in
            guard let data = data else {
                completion(nil, .missingResponse)
                return
            }
            
            if let httpResponseStatusCode = (response as? HTTPURLResponse)?.statusCode, httpResponseStatusCode != 200 {
                completion(nil, WhaleAlertError(statusCode: httpResponseStatusCode))
            }
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
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
