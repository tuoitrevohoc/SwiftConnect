//
//  HttpClientExtension.swift
//  AppWork
//
//  Created by Tran Thien Khiem on 7/25/16.
//  Copyright © 2016 Tran Thien Khiem. All rights reserved.
//

import Foundation
import UIKit

/// 
/// can convert from object to dât
///
public protocol DataConvertible {
    
    ///
    /// convert data from object
    /// - parameter data: data represent the object
    init?(data: Data)
}

///
/// extension for observable
///
extension Observable {
    
    ///
    /// subscribe the data request without specifying error 
    ///
    /// - parameter success: callback handler when the action is successful
    public func subscribe(successHandler: @escaping (Data) -> Void) {
        subscribe(successHandler: successHandler, errorHandler: {
            error in
            print("Error \(error)!")
        })
    }
    
    ///
    /// subscribe the data request
    /// - parameter success: callback handler when the action is successful
    /// - parameter error: callback handler when there is an error
    public func subscribe<Result: DataConvertible>
                                 (successHandler: @escaping (Result) -> Void,
                                    errorHandler: @escaping (HttpError) -> Void) {
        subscribe(successHandler: {
            (data: Data) in
            if let result = Result(data: data) {
                successHandler(result)
            }
        }, errorHandler: errorHandler)
    }
    
    ///
    /// subscribe the data request
    /// - parameter success: callback handler when the action is successful
    /// - parameter error: callback handler when there is an error
    public func subscribe<Result: JsonConvertible>
        (successHandler: @escaping (Result) -> Void,
         errorHandler: @escaping (HttpError) -> Void) {
        
        subscribe(successHandler: {
            (data: Data) in
            
                if  let json = try? JSONSerialization.jsonObject(with: data, options: []),
                    let jsonData = json as? [String: AnyObject],
                    let result = try? Result(data: jsonData) {
                    if let result = result {
                        successHandler(result)
                    } else {
                        errorHandler(HttpError.serializeFailed)
                    }
                } else {
                    errorHandler(HttpError.serializeFailed)
                }
            }, errorHandler: errorHandler)
    }
    
    ///
    /// subscribe the data request without specifying error
    ///
    /// - parameter success: callback handler when the action is successful
    public func subscribe<Result: DataConvertible>(successHandler: @escaping (Result) -> Void) {
        subscribe(successHandler: successHandler, errorHandler: {
            error in
            print("Error \(error)!")
        })
    }
}

/// 
/// extension for the request
extension HttpClient {
    
    /// 
    /// get request
    /// 
    /// - parameter path: path to the resource
    /// - returns: the request observer
    public func get(_ path: String) -> Observable {
        return request(method: .Get, path: path, body: nil)
    }
    
    ///
    /// post a request to a path
    ///
    /// - parameter path: path to the resource
    /// - parameter body: body of the request
    /// - returns: the request observer
    public func post(_ path: String, body: Data) -> Observable {
        return request(method: .Post, path: path, body: body)
    }
    
    ///
    /// put a request to a path
    ///
    /// - parameter path: path to the resource
    /// - parameter body: body of the request
    /// - returns: the request observer
    public func put(_ path: String, body: Data) -> Observable {
        return request(method: .Put, path: path, body: body)
    }
    
    ///
    /// put a request to a path
    ///
    /// - parameter path: path to the resource
    /// - parameter body: body of the request
    /// - returns: the request observer
    public func delete(_ path: String) -> Observable {
        return request(method: .Post, path: path, body: nil)
    }
    
    
    /// post a request to a path
    ///
    /// - parameter path: path to the resource
    /// - parameter body: body of the request
    /// - returns: the request observer
    public func post<T: JsonSerializable>(_ path: String, body: T) -> Observable {
        return request(.Post, path: path, body: body)
    }
    
    ///
    /// put a request to a path
    ///
    /// - parameter path: path to the resource
    /// - parameter body: body of the request
    /// - returns: the request observer
    public func put<T: JsonSerializable>(_ path: String, body: T) -> Observable {
        return request(.Post, path: path, body: body)
    }
    
    /// fake http client
    public func request<T: JsonSerializable>(_ method: HttpMethod, path: String, body: T) -> Observable {
        let data = try? JSONSerialization.data(withJSONObject: body.toJson(), options: [])
        return request(method: method, path: path, body: data)
    }
}

///
/// UIImage comforts Data Convertible
extension UIImage: DataConvertible {

}
