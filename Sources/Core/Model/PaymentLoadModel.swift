//
//  PaymentLoadModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/11/24.
//

import Foundation

public struct PaymentLoadModel: Codable {
   public  let pidx: String?
    public let totalAmount: Int64
    public  let status: String?
    public  let transactionId: String?
    public  let fee: Int64
    public  let refunded: Bool
    public  let purchaseOrderId: String?
    public  let purchaseOrderName: String?
    public  let extraMerchantParams: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case pidx
        case totalAmount = "total_amount"
        case status
        case transactionId = "transaction_id"
        case fee
        case refunded
        case purchaseOrderId = "purchase_order_id"
        case purchaseOrderName = "purchase_order_name"
        case extraMerchantParams = "extra_merchant_params"
    }
    
    // Custom decoding to handle extraMerchantParams as [String: Any]
   public  init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pidx = try container.decodeIfPresent(String.self, forKey: .pidx)
        totalAmount = try container.decodeIfPresent(Int64.self, forKey: .totalAmount) ?? 0
        status = try container.decodeIfPresent(String.self, forKey: .status)
        transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId)
        fee = try container.decodeIfPresent(Int64.self, forKey: .fee) ?? 0
        refunded = try container.decodeIfPresent(Bool.self, forKey: .refunded) ?? false
        purchaseOrderId = try container.decodeIfPresent(String.self, forKey: .purchaseOrderId)
        purchaseOrderName = try container.decodeIfPresent(String.self, forKey: .purchaseOrderName)
        
        // Decode extraMerchantParams manually
        if let params = try? container.decodeIfPresent([String: AnyCodable].self, forKey: .extraMerchantParams) {
            extraMerchantParams = params.mapValues { $0.value }
        } else {
            extraMerchantParams = nil
        }
    }
    
    // Custom encoding to handle extraMerchantParams as [String: Any]
   public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(pidx, forKey: .pidx)
        try container.encode(totalAmount, forKey: .totalAmount)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(transactionId, forKey: .transactionId)
        try container.encode(fee, forKey: .fee)
        try container.encode(refunded, forKey: .refunded)
        try container.encodeIfPresent(purchaseOrderId, forKey: .purchaseOrderId)
        try container.encodeIfPresent(purchaseOrderName, forKey: .purchaseOrderName)
        
        // Encode extraMerchantParams manually
        if let params = extraMerchantParams {
            let encodableParams = params.mapValues { AnyCodable($0) }
            try container.encode(encodableParams, forKey: .extraMerchantParams)
        }
    }
}
