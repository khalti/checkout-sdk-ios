//
//  PaymentResult.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//
import Foundation

@objc public class PaymentResult:NSObject {
    public var status:String?
    public var payload:PaymentLoadModel?
    public var message:String?
    
    init(status:String?, message:String?=nil,payload:PaymentLoadModel?) {
        self.status = status
        self.payload = payload
        
    }
    
    @objc public func getMessage() -> String?{
        return self.message
    }
    
}
