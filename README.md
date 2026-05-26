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


### How to use?
Go to the [documentation to install checkout-iOS](https://docs.khalti.com/checkout/ios/).

## License

KhaltiCheckout is available under the MIT license. See the LICENSE file for more info.
