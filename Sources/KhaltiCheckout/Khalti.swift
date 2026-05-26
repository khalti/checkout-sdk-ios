//
//  Khalti.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation
import UIKit

public typealias OnPaymentResult = ((PaymentResult, Khalti?) -> ())
public typealias OnMessageResult = (OnMessagePayload, Khalti?) -> ()
public typealias OnReturn = (Khalti?) -> ()

@objc public class Khalti: NSObject {
    @objc public var config: KhaltiPayConfig
    @objc public var onPaymentResult: OnPaymentResult
    @objc public var onMessage: OnMessageResult
    @objc public var onReturn: OnReturn?

    @objc public init(
        config: KhaltiPayConfig,
        onPaymentResult: @escaping OnPaymentResult,
        onMessage: @escaping OnMessageResult,
        onReturn: OnReturn? = nil
    ) {
        self.config = config
        self.onPaymentResult = onPaymentResult
        self.onMessage = onMessage
        self.onReturn = onReturn
    }

    func getConfig() -> KhaltiPayConfig {
        return self.config
    }

    @objc public func open(viewController: UIViewController) {
        let vc = KhaltiPaymentViewController()
        vc.khalti = self
        vc.modalPresentationStyle = .fullScreen

        viewController.present(vc, animated: false)
    }

    @objc public func close() {
        NotificationCenter.default.post(name: .notificationAction, object: nil)
    }

    @objc public func verify() {
        NotificationCenter.default.post(name: .notificationType, object: nil)
    }
}
