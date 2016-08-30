//
//  TestBasicHttpClient.swift
//  AppWork
//
//  Created by Tran Thien Khiem on 7/25/16.
//  Copyright © 2016 Tran Thien Khiem. All rights reserved.
//

import XCTest
import SwiftConnect

class TestBasicHttpClient: XCTestCase {
    

    ///
    /// test able to create a basic http client
    ///
    func testBasicHttpClient_Creation() {
        _ = BasicHttpClient(endPoint: "http://www.swiftify.com/")
    }
    
    ///
    /// test able to get pet
    ///
    func testBasicHttpClient_GetPet() {
        
        let resultReturned = expectation(description: "Request should return result")
        
        var client = BasicHttpClient(endPoint: "http://petstore.swagger.io")
        
        client.headers["Accept"] = "application/json"
        
        client.get("/v2/pet/1")
            .subscribe(
                successHandler: {
                    (data: Data) in
                    print("\(data)")
                    resultReturned.fulfill()
                },
                errorHandler: {
                    error in
                    XCTFail("Request should not be failed")
                })
        
        // wait for request to finished
        waitForExpectations(timeout: 30.0, handler: nil)
        
    }
}
