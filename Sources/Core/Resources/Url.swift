//
//  Url.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation
enum Url:String {
    case BASE_KHALTI_URL_PROD = "https://khalti.com/api/v2/"
    case BASE_KHALTI_URL_STAGING = "https://dev.khalti.com/api/v2/"
    case BASE_PAYMENT_URL_PROD = "https://pay.khalti.com/"
    case BASE_PAYMENT_URL_STAGING = "https://test-pay.khalti.com/"
    
    case PAYMENT_DETAIL = "epayment/detail/"
    case LOOKUP_SDK = "epayment/lookup-sdk/"
    
    func appendUrl(url:Url) -> String{
        return self.rawValue + url.rawValue
    }
    

    
    
}
