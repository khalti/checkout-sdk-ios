//
//  KhaltiPayConfig.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation


@objc public class KhaltiPayConfig: NSObject {
    public var publicKey:String
    public var pIdx:String
    public var extra: NSDictionary
    public var environment:Environment = Environment.TEST
    
    @objc public init(publicKey:String,pIdx:String,extra: NSDictionary = [:], environment:Environment) {
        self.publicKey = publicKey
        self.pIdx = pIdx
        self.extra = extra
        self.environment = environment
    }
    
     public func copyWith( publicKey: String? = nil,pIdx:String? = nil, extra: NSDictionary? = nil, environment:Environment? = nil) -> KhaltiPayConfig{
        return KhaltiPayConfig(
            publicKey: publicKey ?? self.publicKey,
            pIdx: pIdx ?? self.pIdx,
            extra: getExtra() ?? self.extra,
            environment : environment ?? self.environment
        )
    }
    
    func getPidx() -> String {
        return self.pIdx
    }
    
    func getExtra() -> NSDictionary {
        let extraWithPidx = NSMutableDictionary(dictionary: extra)
        extraWithPidx["pIdx"] = pIdx
        return extraWithPidx
    }
    
    func getPublicKey() -> String {
        return self.publicKey
    }
    
    func getEnvironment() -> Environment{
        return self.environment
    }
    
    func isProd() -> Bool{
        return self.environment == Environment.PROD
    }
}
