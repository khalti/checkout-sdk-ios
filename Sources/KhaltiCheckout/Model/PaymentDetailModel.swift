//
//  PaymentDetailModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/11/24.
//

import Foundation

struct PaymentDetailModel: Codable {
    let returnUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case returnUrl = "return_url"
    }
}

