//
//  JsonConvertible.swift
//  AppWork
//
//  Created by Tran Thien Khiem on 7/26/16.
//  Copyright © 2016 Tran Thien Khiem. All rights reserved.
//

import Foundation

///
/// JsonConvertible - can convert the object
/// from a json object
public protocol JsonConvertible {

    ///
    /// initialize the object from 
    /// an dictionary
    ///
    /// - parameter data: data of string
    init?(data: [String: Any]) throws
}


///
/// can convert to json
///
public protocol JsonSerializable {
    
    /// can convert this object to json
    func toJson() -> [String: Any]
}

///
enum ParseError: Error {
    case notValid
}

///
extension Data {
    /// convert to a json object
    func jsonObject() -> [String: AnyObject]? {
        let result = try? JSONSerialization.jsonObject(with: self, options: [])
        return result as? [String: AnyObject]
    }
}

/// convert to json
extension Array {
    
    /// convert an array 
    public func toJson() -> [Any] {
        var data = [Any]()
        for item in self {
            if let serializableObject = item as? JsonSerializable {
                data.append(serializableObject.toJson())
            }
        }

        return data
    }
    
}

///
/// extension to Dictionary
extension Dictionary {
    
    /// get a value of key
    func get<T>(_ key: Key) throws -> T {
        if let data = self[key] as? T {
            return data
        }
        
        throw ParseError.notValid
    }
    
    /// get an array
    func getList<T: JsonConvertible>(_ key: Key) -> [T] {
        var result = [T]()
        
        if let array = self[key] as? [AnyObject] {
            for item in array {
                if let data = item as? [String: AnyObject],
                   let object = try? T(data: data),
                   let instance = object {
                    result.append(instance)
                }
            }
        }
        
        return result
    }
    
    /// get an array
    func getList<T>(_ key: Key) -> [T] {
        var result = [T]()
        
        if let array = self[key] as? [AnyObject] {
            for item in array {
                if let data = item as? T {
                    result.append(data)
                }
            }
        }
        
        return result
    }
    
    /// get a value of key
    func get<T: JsonConvertible>(_ key: Key) throws -> T {
        if let data = self[key] as? [String: AnyObject],
           let object = try? T(data: data),
           let instance = object {
            return instance
        } else {
            throw ParseError.notValid
        }
    }
    
    /// get a value of key
    func get<T: JsonConvertible>(_ key: Key, default defaultValue: T? = nil) -> T? {
        var result: T? = defaultValue
        
        if let data = self[key] as? [String: AnyObject],
            let object = try? T(data: data),
            let instance = object {
            result = instance
        }
        
        return result
    }

    
    
    /// get a value of key
    func get<T>(_ key: Key, default defaultValue: T) -> T {
        var result = defaultValue
        
        if let data = self[key] as? T {
            result = data
        }
        
        return result
    }
    
    /// put
    mutating func put(_ key: Key, value: Value?) {
        if let value = value {
            self[key] = value
        }
    }
}
