//
//  Pin.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 

import SwiftMultihash

/** Pinning an object will ensure a local copy is not garbage collected. */
public class Pin : ClientSubCommand {
    
    var parent: IpfsApiClient?
    
    public func add(hash: Multihash, completionHandler: ([Multihash]) -> Void) throws {
        
        try parent!.fetchJson("pin/add?stream-channels=true&arg=\(b58String(hash))") {
            result in
            
            guard let objects = result.object?["Pinned"]?.array else {
                throw IpfsApiError.PinError("Pin.add error: No Pinned objects in JSON data.")
            }
            
            let multihashes = try objects.map { try fromB58String($0.string!) }
            
            completionHandler(multihashes)
        }
    }
    
    /** List objects pinned to local storage */
    public func ls(completionHandler: ([Multihash : JsonType]) -> Void) throws {
        
        /// The default is .Recursive
        try self.ls(.Recursive) {
            result in
            
            ///turn the result into a [Multihash : AnyObject]
            var multihashes: [Multihash : JsonType] = [:]
            if let hashes = result.object {
                for (k,v) in hashes {
                    multihashes[try fromB58String(k)] = v
                }
            }
            
            completionHandler(multihashes)
        }
    }
    
    public func ls(pinType: PinType, completionHandler: (JsonType) throws -> Void) throws {
        
        try parent!.fetchJson("pin/ls?stream-channels=true&t=" + pinType.rawValue) {
            result in
            
            guard let objects = result.object?["Keys"] else {
                throw IpfsApiError.PinError("Pin.ls error: No Keys Dictionary in JSON data.")
            }
            
            try completionHandler(objects)
        }
    }
    
    public func rm(hash: Multihash, completionHandler: ([Multihash]) -> Void) throws {
        try self.rm(hash, recursive: true, completionHandler: completionHandler)
    }
    
    public func rm(hash: Multihash, recursive: Bool, completionHandler: ([Multihash]) -> Void) throws {
        
        try parent!.fetchJson("pin/rm?stream-channels=true&r=\(recursive)&arg=\(b58String(hash))") {
            result in
            
            guard let objects = result.object?["Pinned"]?.array else {
                throw IpfsApiError.PinError("Pin.rm error: No Pinned objects in JSON data.")
            }
            
            let multihashes = try objects.map { try fromB58String($0.string!) }
            
            completionHandler(multihashes)
        }
    }
    
}