//
//  Callbacks.swift
//  WhaleAlert
//
//  Created by Ryan Cohen on 9/9/19.
//

import Foundation

public struct Callbacks {
    public typealias WhaleAlertStatusCallback = (_ status: Status?, _ error: WhaleAlertError?) -> ()
    public typealias WhaleAlertTransactionsCallback = (_ transaction: [Transaction]?, _ error: WhaleAlertError?) -> ()
}
