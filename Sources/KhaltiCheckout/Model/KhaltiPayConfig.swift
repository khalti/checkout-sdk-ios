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
    public var paymentUrl: String
    public var extraWithPidx: NSDictionary
    public var extra: NSDictionary {
        extraWithPidx
    }
    public var environment:Environment = Environment.TEST
    
    @objc public init(publicKey:String,pIdx:String,extra: NSDictionary = [:], paymentUrl: String, environment:Environment) {
        let extraWithPidx = NSMutableDictionary(dictionary: extra)
        extraWithPidx["pIdx"] = pIdx

        self.publicKey = publicKey
        self.pIdx = pIdx
        self.extraWithPidx = extraWithPidx
        self.paymentUrl = paymentUrl
        self.environment = environment
        super.init()
    }
    
     public func copyWith( publicKey: String? = nil,pIdx:String? = nil, extra: NSDictionary? = nil, environment:Environment? = nil) -> KhaltiPayConfig{
        return KhaltiPayConfig(
            publicKey: publicKey ?? self.publicKey,
            pIdx: pIdx ?? self.pIdx,
            extra: getExtra(extra: extra),
            paymentUrl: paymentUrl ?? self.paymentUrl,
            environment : environment ?? self.environment
        )
    }
    
    func getPidx() -> String {
        return self.pIdx
    }
    
    func getExtra(extra: NSDictionary?) -> NSDictionary {
        let extraWithPidx = NSMutableDictionary(dictionary: extra ?? [:])
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
