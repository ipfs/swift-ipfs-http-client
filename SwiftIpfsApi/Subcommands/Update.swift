//
//  Update.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details.

public class Update : ClientSubCommand {
    
    var parent: IpfsApiClient?

    @discardableResult
    public func check(_ completionHandler: @escaping (JsonType) -> Void) throws -> CancellableRequest {
        try parent!.fetchJson("update/check", completionHandler: completionHandler )
    }

    @discardableResult
    public func log(_ completionHandler: @escaping (JsonType) -> Void) throws -> CancellableRequest {
        try parent!.fetchJson("update/log", completionHandler: completionHandler )
    }
}
