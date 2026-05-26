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
    @objc public var openInKhalti:Bool = false
    public var environment:Environment = Environment.TEST
    
   @objc public init(publicKey:String,pIdx:String,openInKhalti:Bool = false,environment:Environment) {
        self.publicKey = publicKey
        self.pIdx = pIdx
        self.openInKhalti = openInKhalti
        self.environment = environment
    }
    
     public func copyWith( publicKey: String? = nil,pIdx:String? = nil,openInKhalti:Bool? = false,environment:Environment? = nil) -> KhaltiPayConfig{
        return KhaltiPayConfig(
            publicKey: publicKey ?? self.publicKey,
            pIdx: pIdx ?? self.pIdx,
            openInKhalti: openInKhalti ?? self.openInKhalti,
            environment : environment ?? self.environment
        )
    }
    
    
    
    
    
    func getPidx() -> String {
        return self.pIdx
    }
    
    func getPublicKey() -> String {
        return self.publicKey
    }
    func getOpenInKhalti() -> Bool{
        return self.openInKhalti
    }
    func getEnvironment() -> Environment{
        return self.environment
    }
    
    func isProd() -> Bool{
        return self.environment == Environment.PROD
    }
    
    
    
}

