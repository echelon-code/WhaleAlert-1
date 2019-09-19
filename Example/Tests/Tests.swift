import XCTest
@testable import WhaleAlert

class Tests: XCTestCase {
    
    var whaleAlert: WhaleAlert!
    
    override func setUp() {
        super.setUp()
        whaleAlert = WhaleAlert(apiKey: "", delegate: nil)
    }
    
    override func tearDown() {
        whaleAlert = nil
        super.tearDown()
    }
    
    func testWhaleAlertGetStatus() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should retrieve list of connected blockchains.")
        //{
        //    "result": "success",
        //    "blockchain_count": 5,
        //    "blockchains": [
        //        {
        //            "name": "ethereum",
        //            "symbols": [
        //                "ae",
        //                "agi",
        //                "aion",
        //                "aoa",
        //                "appc",
        //                "bat"
        //            ],
        //            "status": "connected"
        //        },
        //        {
        //            "name": "ripple",
        //            "symbols": [
        //                "xrp"
        //            ],
        //            "status": "connected"
        //        }
        //    ]
        //}
        whaleAlert.getStatus { (status) in
            guard let status = status else {
                XCTFail("Status object was nil.")
                return
            }
            
            XCTAssertEqual(status.result, "success")
            XCTAssertNotNil(status.blockchains)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWhaleAlertGetTransactionByHash() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should retrieve a transaction by its hash.")
        //{
        //  "result": "success",
        //  "count": 1,
        //  "transactions": [
        //    {
        //      "blockchain": "ethereum",
        //      "symbol": "eth",
        //      "transaction_type": "transfer",
        //      "hash": "0015286d8642f0e0553b7fefa1c168787ae71173cbf82ec2f2a1b2e0ffee72b2",
        //      "from": {
        //        "address": "d24400ae8bfebb18ca49be86258a3c749cf46853",
        //        "owner": "gemini",
        //        "owner_type": "exchange"
        //      },
        //      "to": {
        //        "address": "07ee55aa48bb72dcc6e9d78256648910de513eca",
        //        "owner_type": "unknown"
        //      },
        //      "timestamp": 1549908368,
        //      "amount": 42000,
        //      "amount_usd": 5110718.5,
        //      "transaction_count": 1
        //    }
        //  ]
        //}
        let billionDollarHash: String = "4410c8d14ff9f87ceeed1d65cb58e7c7b2422b2d7529afc675208ce2ce09ed7d"
        whaleAlert.getTransaction(withHash: billionDollarHash, fromBlockchain: .bitcoin) { (transactions) in
            guard let transactions = transactions, let firstTransaction = transactions.first else {
                XCTFail("Transaction(s) were nil.")
                return
            }
            
            XCTAssertEqual(firstTransaction.blockchain, "bitcoin")
            XCTAssertEqual(firstTransaction.symbol, "btc")
            XCTAssertEqual(firstTransaction.hash, billionDollarHash)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWhaleAlertGetTransactionsFromPastHour() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "Should retrieve a list of transactions from the past hour.")
        //{
        //  "result": "success",
        //  "cursor": "2bc7efa-2bc7efa-5c66c095",
        //  "count": 4,
        //  "transactions": [
        //    {
        //      "blockchain": "ethereum",
        //      "symbol": "eth",
        //      "transaction_type": "transfer",
        //      "hash": "f11c10e44880f0b282fbc40390cd4f50a4d6e6662cc6a3847d57032c79c7e256",
        //      "from": {
        //        "address": "3bcf29647e479473dd18dff467a066fcb5a597a0",
        //        "owner_type": "Unknown"
        //      },
        //      "to": {
        //        "address": "5e032243d507c743b061ef021e2ec7fcc6d3ab89",
        //        "owner": "bittrex",
        //        "owner_type": "Exchange"
        //      },
        //      "timestamp": 1550237833,
        //      "amount": 144.24371,
        //      "amount_usd": 17721.047,
        //      "transaction_count": 1
        //    },
        //  ]
        //}
        let now: Date = Date()
        let pastHour: Date = now.addingTimeInterval(-3600)
        whaleAlert.getAllTransactions(fromDate: pastHour, toDate: now) { (transactions) in
            guard let transactions = transactions, let firstTransaction = transactions.first else {
                XCTFail("Transaction(s) were nil.")
                return
            }
            
            XCTAssertGreaterThan(firstTransaction.amount, 0.0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
}
