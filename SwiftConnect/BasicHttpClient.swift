//
//  BasicHttpClient.swift
//  AppWork
//
//  Created by Tran Thien Khiem on 7/25/16.
//  Copyright © 2016 Tran Thien Khiem. All rights reserved.
//

import Foundation


///
/// the http request
///
public struct HttpRequest: Observable {
    
    ///
    /// the url session
    var session: URLSession
    
    ///
    /// the method
    ///
    var method: HttpMethod
    
    ///
    /// the path
    ///
    var path: String
    
    ///
    /// the headers
    ///
    var headers: [String: String]
    
    ///
    /// the request body
    ///
    var body: Data?
    
    ///
    /// subscribe the data request
    /// - parameter successHandler: callback handler when the action is successful
    /// - parameter errorHandler: callback handler when there is an error
    public func subscribe(successHandler: @escaping (Data) -> Void,
                            errorHandler: @escaping (HttpError) -> Void) {
        
        if let url = URL(string: path) {
            let request = NSMutableURLRequest(url: url)
            
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            request.httpMethod = method.rawValue
            
            if let body = body {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = body
            }
        
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                
                self.runOnMain {
                    if let error = error {
                        if let httpError = HttpError(rawValue: error._code) {
                            errorHandler(httpError)
                        } else {
                            errorHandler(.notFound)
                        }
                    } else if let data = data {
                        successHandler(data)
                    }
                }
            })
            
            task.resume()
            
            
        } else {
            errorHandler(.invalidUrl)
        }
    }
    
    ///
    /// run the block on main thread
    func runOnMain(_ block: @escaping () -> (Void)) {
        OperationQueue.main.addOperation(block)
    }
}

///
/// the basic http client
///
public struct BasicHttpClient: HttpClient {
    
    /// the endpoint
    public var endPoint = String()
    
    /// configuration headers
    public var headers = [String : String]()
    
    /// the url session
    public var session: URLSession
    
    /// initialize the client
    public init(endPoint configuredEnpoint: String) {
        endPoint = configuredEnpoint

        let defaultConfiguration = URLSessionConfiguration.default
        session = URLSession(configuration: defaultConfiguration)
    }
    
    /// fake http client
    public func request(method: HttpMethod, path: String, body: Data?) -> Observable {
        let fullPath = "\(endPoint)\(path)"
        let request = HttpRequest(session: session, method: method, path: fullPath, headers: headers, body: body)
        return request
    }
}
