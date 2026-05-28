//
//  ExtraModel.swift
//  KhaltiCheckout
//
//  Created by Yuvraj Bashyal on 27/05/2026.
//

public struct ExtraModel: Codable {
    public let returnUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case returnUrl = "return_url"
    }

    public init(returnUrl: String?) {
        self.returnUrl = returnUrl
    }
}
