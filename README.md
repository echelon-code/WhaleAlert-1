# 🐋 WhaleAlert

[![Version](https://img.shields.io/cocoapods/v/WhaleAlert.svg?style=flat)](https://cocoapods.org/pods/WhaleAlert)
[![License](https://img.shields.io/cocoapods/l/WhaleAlert.svg?style=flat)](https://cocoapods.org/pods/WhaleAlert)
[![Platform](https://img.shields.io/cocoapods/p/WhaleAlert.svg?style=flat)](https://cocoapods.org/pods/WhaleAlert)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

WhaleAlert is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WhaleAlert'
```

## Usage

#### Initialize with WhaleAlert API key
```swift
// NOTE: Delegate is optional and can be left nil if you'd rather receive block-based responses
let whaleAlert: WhaleAlert = WhaleAlert(apiKey: "your-api-key", delegate: self)
```

#### Get network/blockchain status
```swift
// Delegate based
whaleAlert.getStatus()

// WhaleAlertProtocol
func whaleAlertDidReceiveStatus(_ status: Status?, _ error: WhaleAlertError?) {
    // Do something with `status` object.
}

// Block based
whaleAlert.getStatus { (status, error) in
    // Do something with `status` object.
}
```

#### Get transaction by hash and blockchain
```swift
// Delegate based
whaleAlert.getTransaction(withHash: "some-hash", fromBlockchain: .bitcoin)

// WhaleAlertProtocol
func whaleAlertDidReceiveTransactions(_ transactions: [Transaction]?, _ error: WhaleAlertError?) {
    // Do something with `transactions` object.
}

// Block based
whaleAlert.getTransaction(withHash: "some-hash", fromBlockchain: .bitcoin) { (transactions, error) in
    // Do something with `transactions` object.
}
```

#### Get all transactions after start date
```swift
// Delegate based
let pastHour: Date = Date().addingTimeInterval(-3600)
whaleAlert.getAllTransactions(fromDate: pastHour)

// WhaleAlertProtocol
func whaleAlertDidReceiveTransactions(_ transactions: [Transaction]?, _ error: WhaleAlertError?) {
    // Do something with `transactions` object.
}

// Block based (`fromDate` is required, all other parameters are optional.)
whaleAlert.getAllTransactions(fromDate: pastHour, toDate: nil, cursor: nil, minUSDValue: nil, limit: 100, currency: "usd") { (transactions, error) in
    // Do something with `transactions` object.          
}
```

## Author

Ryan Cohen, notryancohen@gmail.com

## License

WhaleAlert is available under the MIT license. See the LICENSE file for more info.
