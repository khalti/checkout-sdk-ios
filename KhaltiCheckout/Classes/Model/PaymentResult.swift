//
//  PaymentResult.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//
import Foundation

  public class PaymentResult: NSObject {
    private var status:String?
    private var payload:PaymentLoadModel?
      private var message:String?
    
     init(status:String?, message:String?=nil,payload:PaymentLoadModel?) {
        self.status = status
        self.payload = payload
        
    }
}
