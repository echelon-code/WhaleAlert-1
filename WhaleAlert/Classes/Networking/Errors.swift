//
//  Errors.swift
//  Pods-WhaleAlert_Example
//
//  Created by Ryan Cohen on 7/11/20.
//

import Foundation

public enum WhaleAlertError: Error, CustomStringConvertible {
    /// API key was not set.
    case missingAPIKey
    /// There was no data in the response body from the network.
    case missingResponse
    /// Your request was not valid.
    case badRequest
    /// No valid API key was provided.
    case unauthorized
    /// Access to this resource is restricted for the given caller.
    case forbidden
    /// The requested resource does not exist.
    case notFound
    /// An unsupported format was requested.
    case notAcceptable
    /// You have exceeded the allowed number of calls per minute. Lower call frequency or upgrade your plan for a higher rate limit.
    case tooManyRequests
    /// There was a problem with the API host server. Try again later.
    case serverError
    /// API is temporarily offline for maintenance. Try again later.
    case serviceUnavailable
    /// Other error condition with description.
    case other(String)
    
    public var description: String {
        switch self {
        case .missingAPIKey:
            return "Missing API key."
        case .missingResponse:
            return "Missing response from API."
        case .badRequest:
            return "Bad request."
        case .unauthorized:
            return "No valid API key was provided."
        case .forbidden:
            return "Access to this resource is restricted for the given caller."
        case .notFound:
            return "The requested resource does not exist."
        case .notAcceptable:
            return "Request is not in an acceptable format."
        case .tooManyRequests:
            return "You have exceeded the allowed number of calls per minute. Lower call frequency or upgrade your plan for a higher rate limit."
        case .serverError:
            return "There was a problem with the API host server. Try again later."
        case .serviceUnavailable:
            return "API is temporarily offline for maintenance. Try again later."
        case .other(let reason):
            return "Other reason: \(reason)"
        }
    }
    
    /// Initialize networking
    /// - Parameter statusCode: HTTP status code.
    init?(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 406:
            self = .notAcceptable
        case 429:
            self = .tooManyRequests
        case 500:
            self = .serverError
        case 503:
            self = .serviceUnavailable
        default:
            return nil
        }
    }
}
