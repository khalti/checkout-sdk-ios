import SwiftUI
import UIKit

@available(iOS 13.0, *)
public struct KhaltiCheckoutView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let khalti: Khalti?
    
    public init(isPresented: Binding<Bool>, khalti: Khalti?) {
        self._isPresented = isPresented
        self.khalti = khalti
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        khalti?.makeViewController() ?? UIViewController()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

@available(iOS 13.0, *)
public struct KhaltiCheckoutSheet: ViewModifier {
    @Binding var isPresented: Bool
    let khalti: Khalti?
    let onDismiss: (() -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .background(
                KhaltiCheckoutFullScreenPresenter(
                    isPresented: $isPresented,
                    khalti: khalti,
                    onDismiss: onDismiss
                )
            )
    }
}

@available(iOS 13.0, *)
public extension View {
    func khaltiCheckoutSheet(
        isPresented: Binding<Bool>,
        khalti: Khalti?,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        modifier(KhaltiCheckoutSheet(
            isPresented: isPresented,
            khalti: khalti,
            onDismiss: onDismiss
        ))
    }
}

@available(iOS 13.0, *)
private struct KhaltiCheckoutFullScreenPresenter: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let khalti: Khalti?
    let onDismiss: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, onDismiss: onDismiss)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.isPresented = $isPresented
        context.coordinator.onDismiss = onDismiss

        if isPresented {
            guard uiViewController.presentedViewController == nil, let khalti else {
                return
            }

            let paymentViewController = khalti.makeViewController()
            paymentViewController.modalPresentationStyle = .fullScreen
            paymentViewController.presentationController?.delegate = context.coordinator
            uiViewController.present(paymentViewController, animated: true)
        } else if uiViewController.presentedViewController != nil {
            uiViewController.dismiss(animated: true)
        }
    }

    final class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var isPresented: Binding<Bool>
        var onDismiss: (() -> Void)?

        init(isPresented: Binding<Bool>, onDismiss: (() -> Void)?) {
            self.isPresented = isPresented
            self.onDismiss = onDismiss
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            isPresented.wrappedValue = false
            onDismiss?()
        }
    }
}
