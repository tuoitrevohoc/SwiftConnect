//
//  Http.swift
//  AppWork
//
//  Created by Tran Thien Khiem on 7/25/16.
//  Copyright © 2016 Tran Thien Khiem. All rights reserved.
//

import Foundation

///
/// the http error
///
public enum HttpError: Int {
    case notFound = 404
    case forbidden = 401
    case serializeFailed
    case invalidUrl
}

///
/// the http request 
///
public enum HttpMethod: String {
    case Get
    case Post
    case Put
    case Delete
    case Head
}

///
/// the obserable object
///
public protocol Observable {
    
    ///
    /// subscribe the data request
    /// 
    /// - parameter successHandler: callback handler when the action is successful
    /// - parameter errorHandler: call back handler when the action is failure
    func subscribe(successHandler: @escaping (Data) -> Void,
                     errorHandler: @escaping (HttpError) -> Void)
    
}
///
/// the http client that is configurable
///
public protocol ConfigurableHttpClient {
    
    /// the end point
    var endPoint: String { get set }
    
    /// the headers set
    var headers: [String: String] { get set }
}

///
/// protocol for Http Client
///
public protocol HttpClient: ConfigurableHttpClient {
    
    /// 
    /// execute a http request
    ///
    /// - parameter method: the method of the request - like .Get .Post .Put
    /// - parameter path: path to the resource
    /// - parameter body: body of the request
    /// - returns: an observable object that observes the request result
    func request(method: HttpMethod, path: String, body: Data?) -> Observable
}
