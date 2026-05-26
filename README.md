# KhaltiCheckout

## Installation

### Swift Package Manager

KhaltiCheckout is available through [Swift Package Manager](https://swift.org/package-manager/). To install it:

#### Using Xcode:
1. Go to **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/khalti/checkout-sdk-ios.git`
3. Select the version you want to use
4. Add the package to your target

#### Using Package.swift:
Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/khalti/checkout-sdk-ios.git", from: "2.0.0")
]
```

## Requirements

- iOS 12.0+
- Swift 5.0+
- Xcode 12.0+

## Usage

Import KhaltiCheckout in your Swift file:

```swift
import KhaltiCheckout
```

### Basic Implementation

```swift
import UIKit
import KhaltiCheckout

class ViewController: UIViewController {
    
    func initiatePayment() {
        let config = KhaltiPayConfig(
            publicKey: "your_public_key_here",
            pIdx: "your_payment_idx_here",
            openInKhalti: false,
            environment: .TEST // Use .PROD for production
        )
        
        let khalti = Khalti(
            config: config,
            onPaymentResult: { result, khalti in
                // Handle payment result
                print("Payment Status: \(result.status ?? "Unknown")")
            },
            onMessage: { message, khalti in
                // Handle messages/errors
                print("Message: \(message.message)")
            },
            onReturn: { khalti in
                // Handle return from payment page
                print("Returned from payment page")
            }
        )
        
        // Open payment page
        khalti.open(viewController: self)
    }
}
```


<p align="center">
<img src="https://raw.githubusercontent.com/khalti/khalti-flutter-sdk/master/assets/khalti_logo.png" height="100" alt="Khalti Payment Gateway" />
</p>

<p align="center">
<strong>Khalti Payment Gateway</strong><br>
<small>iOS SDK</small>
</p>

<p align="center">
<a href="https://docs.khalti.com/"><img src="https://img.shields.io/badge/Khalti-Docs-blueviolet" alt="Khalti Docs"></a>
<a href="https://github.com/khalti/checkout-sdk-ios/blob/master/LICENSE"><img src="https://img.shields.io/badge/MIT-informational" alt="BSD-3 License"></a>
<a href="https://github.com/khalti/checkout-sdk-ios/issues"><img src="https://img.shields.io/github/issues/khalti/checkout-sdk-ios" alt="GitHub issues"></a>
<a href="https://khalti.com"><img src="https://img.shields.io/website?url=https%3A%2F%2Fdocs.khalti.com" alt="Website"></a>
<a href="https://github.com/khalti/checkout-sdk-ios/releases"><img alt="GitHub Release Date" src="https://img.shields.io/github/release-date/khalti/checkout-sdk-ios"></a>
<a href="https://www.facebook.com/khalti.official"><img src="https://img.shields.io/badge/follow--000?style=social&logo=facebook" alt="Follow Khalti in Facebook"></a>
<a href="https://www.instagram.com/khaltiofficial"><img src="https://img.shields.io/badge/follow--000?style=social&logo=instagram" alt="Follow Khalti in Instagram"></a>
<a href="https://twitter.com/intent/follow?screen_name=khaltiofficial"><img src="https://img.shields.io/twitter/follow/khaltiofficial?style=social" alt="Follow Khalti in Twitter"></a>
<a href="https://www.youtube.com/channel/UCrXM4HqK9th3E2a04Z9Lh-Q"><img src="https://img.shields.io/youtube/channel/subscribers/UCrXM4HqK9th3E2a04Z9Lh-Q?label=Subscribe&style=social" alt="Subscribe Youtube Channel"></a>
</p>

---

### About
Khalti is a payment gateway, digital wallet and API provider system for various online services for Nepal.

With this package, you can accepts payments from:
- Khalti users.
- eBanking users of our partner banks.
- Mobile banking users of our mobile banking partner banks.
- SCT/VISA card holders.
- connectIPS users.

Using Khalti Payment Gateway, you do not need to integrate with individual banks.

### Features
- Multiple Payment Options for Customers
- Highly secure and Easy Integrations
- Customers can make wallet payments without leaving your platform.
- Secured Transaction uses 2 step authentication i.e Khalti Pin and Khalti Password. Transaction Processing is disabled on multiple request for wrong Khalti Pin.
- Merchant Dashboard to view transactions, issue refunds, filter and download reports etc.
- Multi User System
- Realtime Balance updates in Merchant Dashboard on every successful payments made by customers
- Amount collected in Merchant Dashboard can we deposited/transferred to bank accounts anytime


### How to use?
Go to the [documentation to install checkout-iOS](https://docs.khalti.com/checkout/ios/).

## License

KhaltiCheckout is available under the MIT license. See the LICENSE file for more info.
