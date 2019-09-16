//
//  Callbacks.swift
//  WhaleAlert
//
//  Created by Ryan Cohen on 9/9/19.
//

import Foundation

public struct Callbacks {
    public typealias WhaleAlertStatusCallback = (_ status: Status?) -> ()
    public typealias WhaleAlertTransactionCallback = (_ transaction: Transaction?) -> ()
    public typealias WhaleAlertAllTransactionsCallback = (_ transactions: [Transaction]?) -> ()
}
