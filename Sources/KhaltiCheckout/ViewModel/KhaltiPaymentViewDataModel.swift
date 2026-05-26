//
//  KhaltiPaymentViewDataModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/21/24.
//

import Foundation

class KhaltiPaymentViewDataModel{
    
    private var message:String = ""
    private var messagEvent = OnMessageEvent.Unknown
    private var errorModel:ErrorModel?
    private var statusCode = 0
    private var needsPaymentConfirmation:Bool = false
    
    private var isPayment:Bool = false
    
    init(errorModel:ErrorModel,isPayment:Bool){
        self.errorModel = errorModel
        self.isPayment  = isPayment
    }
    
    
   
    private func getMessageEvent(){
        switch self.errorModel?.errorType {
            case .ServerUnreachable:
                self.messagEvent = OnMessageEvent.NetworkFailure
                self.needsPaymentConfirmation = isPayment
            case .Httpcall:
                self.messagEvent = getEvent()
                
            case .Generic:
                self.messagEvent = OnMessageEvent.Unknown
                self.needsPaymentConfirmation = isPayment
            
            case .ParseError:
                self.messagEvent = getEvent()
                self.needsPaymentConfirmation = isPayment
            case .PaymentFailure:
                self.messagEvent = OnMessageEvent.PaymentLookUpFailure
            case .noNetwork:
                self.messagEvent = OnMessageEvent.NetworkFailure
                self.needsPaymentConfirmation = true
            case nil:
                self.messagEvent =  OnMessageEvent.Unknown
           
        }
    }
    

    private func getEvent () -> OnMessageEvent{
        return isPayment ? OnMessageEvent.PaymentLookUpFailure : OnMessageEvent.ReturnUrlLoadFailure
    }
    
    func returnOnMessagePayload() -> OnMessagePayload{
      return OnMessagePayload(event: self.messagEvent, message: self.message, code: self.statusCode, needsPaymentConfirmation: self.needsPaymentConfirmation)
    }
    
}
