# KhaltiCheckout

## Installation

### Swift Package Manager

KhaltiCheckout is available through [Swift Package Manager](https://swift.org/package-manager/). To install it:

#### Using Xcode:
1. Go to **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/khalti/checkout-sdk-ios.git`
3. Select the version you want to use
4. Add the `KhaltiCheckout` package product to your target

#### Using Package.swift:
Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/khalti/checkout-sdk-ios.git", from: "2.0.0")
]
```

Then add the `KhaltiCheckout` product to your target:

```swift
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "KhaltiCheckout", package: "checkout-sdk-ios")
        ]
    )
]
```

## Requirements

- UIKit: iOS 12.0+
- SwiftUI: iOS 13.0+
- Swift 5.0+
- Xcode 12.0+

## Usage

Import `KhaltiCheckout` in UIKit or SwiftUI files:

```swift
import KhaltiCheckout
```

### UIKit Implementation

```swift
import UIKit
import KhaltiCheckout

class ViewController: UIViewController {
    
    func initiatePayment() {
        let config = KhaltiPayConfig(
            publicKey: "your_public_key_here",
            pIdx: "your_payment_idx_here",
            paymentUrl: "your_payment_url_here",
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

### SwiftUI Implementation

```swift
import SwiftUI
import KhaltiCheckout

struct ContentView: View {
    @State private var showKhalti = false
    @State private var khalti: Khalti?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Khalti Payment")
                .font(.title)
            
            Button("Pay with Khalti") {
                setupKhalti()
                showKhalti = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .khaltiCheckoutSheet(
            isPresented: $showKhalti,
            khalti: khalti,
            onDismiss: {
                print("Payment completed or dismissed")
            }
        )
    }
    
    func setupKhalti() {
        let config = KhaltiPayConfig(
            publicKey: "your_public_key_here",
            pIdx: "your_payment_idx_here",
            paymentUrl: "your_payment_url_here",
            environment: .TEST // Use .PROD for production
        )
        
        khalti = Khalti(
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
    }
}
```


### How to use?
Go to the [documentation to install checkout-iOS](https://docs.khalti.com/checkout/ios/).

## License

KhaltiCheckout is available under the MIT license. See the LICENSE file for more info.
