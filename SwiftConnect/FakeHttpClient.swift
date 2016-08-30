//
//  FakeHttpClient.swift
//  AppWork
//
//  Created by Tran Thien Khiem on 7/25/16.
//  Copyright © 2016 Tran Thien Khiem. All rights reserved.
//

import UIKit


///
/// define a fake request definition
///
struct FakeRequestDefinition {
    
    /// method of the request
    var method: HttpMethod
    
    /// path to the resource
    var path: String
    
    /// the result of the request
    var result: Any

}


/// promise
struct FakeObservable: Observable {
    
    /// the result of the request
    var result: Any?
    
    ///
    /// subscribe the data request
    ///
    /// - parameter successHandler: callback handler when the action is successful
    /// - parameter errorHandler: call back handler when the action is failure
    func subscribe<Result>(successHandler: @escaping (Result) -> Void,
                   errorHandler: @escaping (HttpError) -> Void) {
        if let result = result as? Result {
            successHandler(result)
        } else {
            errorHandler(.notFound)
        }
        
    }
}

/// 
/// a fake http client object
///
public struct FakeHttpClient: HttpClient {

    /// the endpoint
    public var endPoint = String()
    
    /// configuration headers
    public var headers = [String : String]()
    
    /// fake request definitions
    private var requestDefinitions = [FakeRequestDefinition]()
    
    /// initialize the client
    public init() {
    }
    
    /// define the request. Next request to this definition will return the fake request
    /// - parameter method: the expected method
    /// - parameter path: path to the resource
    /// - parameter result: the result for the request
    public mutating func add(_ method: HttpMethod, path: String, result: Any) {
        requestDefinitions.append(FakeRequestDefinition(method: method, path: path, result: result))
    }
    
    ///
    /// get the definition 
    /// - parameter method: the expected method
    /// - parameter path: the expected path of resource
    ///
    func definition(_ method: HttpMethod, path: String) -> FakeRequestDefinition? {
        
        var result: FakeRequestDefinition?
        
        for definition in requestDefinitions {
            if definition.method == method
                && definition.path == path {
                result = definition
            }
        }
        
        return result
    }
    
    /// fake http client
    public func request(method: HttpMethod,
                        path: String,
                        body: Data?) -> Observable {
        var observable = FakeObservable()
        
        if let definition = definition(method, path: path) {
            observable = FakeObservable(result: definition.result)
        }
        
        return observable
    }
}
