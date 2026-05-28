//
//  KhaltiPayConfig.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation

@objc public class KhaltiPayConfig: NSObject {
    public var publicKey: String
    public var pIdx: String
    public var paymentUrl: String
    public var environment: Environment = Environment.TEST

    public init(
        publicKey: String,
        pIdx: String,
        paymentUrl: String = "",
        environment: Environment
    ) {
        self.publicKey = publicKey
        self.pIdx = pIdx
        self.paymentUrl = paymentUrl
        self.environment = environment
    }

    public func copyWith(
        publicKey: String? = nil,
        pIdx: String? = nil,
        paymentUrl: String? = nil,
        environment: Environment? = nil
    ) -> KhaltiPayConfig {
        return KhaltiPayConfig(
            publicKey: publicKey ?? self.publicKey,
            pIdx: pIdx ?? self.pIdx,
            paymentUrl: paymentUrl ?? self.paymentUrl,
            environment: environment ?? self.environment
        )
    }

    func getPidx() -> String {
        return self.pIdx
    }

    func getPublicKey() -> String {
        return self.publicKey
    }

    func getEnvironment() -> Environment {
        return self.environment
    }

    func isProd() -> Bool {
        return self.environment == Environment.PROD
    }
}
