
//
//  KhaltiWebViewController.swift
//  Khalti
//
//  Created by Mac on 2/20/24.
//

import UIKit
import WebKit
extension Notification.Name {
    static let notificationAction = Notification.Name("close")
    static let notificationType = Notification.Name("verify")
}

protocol KhaltiPaymentViewControllerProtocol{
    func fetchPaymentDetail()
    func verifyPaymentStatus()
}

class KhaltiPaymentViewController: UIViewController {
    var khalti:Khalti?
    private var wkWebView: WKWebView = WKWebView()
    private var request:URLRequest?
    private var onReceived: ((String) -> Void)?
    private var loadingView = CustomLoadingView()
    private var viewModel:KhaltiPaymentControllerViewModel?
    private let dialogView = CustomDialogView()
    var returnUrl:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        let monitor = NetworkMonitor.shared
        
        monitor.startMonitoring()
    
        print(monitor.isConnected)
        viewModel = KhaltiPaymentControllerViewModel(khalti:khalti)
        self.view.backgroundColor = .white
        addNavigationBar()
        createPaymentWebView()
        setupLoadingView()
        self.fetchPaymentDetail()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .notificationAction, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .notificationType, object: nil)
        // Do any additional setup after loading the view.
    }
    

    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 150),
            loadingView.heightAnchor.constraint(equalToConstant: 100)
        ])
        loadingView.isHidden = true
    }
    
    
    @objc func handleNotification(notification: Notification) {
        if notification.name == Notification.Name.notificationType {
            self.verifyPaymentStatus()
        }else{
            self.dismiss(animated: true)
        }
    }

    
    private func showCustomDialog(message:String,onTapped:@escaping () -> Void){
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dialogView)
        
        NSLayoutConstraint.activate([
            dialogView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dialogView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dialogView.widthAnchor.constraint(equalToConstant: 300),
            dialogView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        dialogView.configure(message: message, buttonTitle: "OK") {
            onTapped()
            // Dismiss the dialog
            
        }
        
    }
    
    deinit {
        // Remove observer
        NotificationCenter.default.removeObserver(self, name: .notificationAction, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .notificationType, object: nil)
//        NetworkMonitor.shared.removeMonitoring()
    }
    
    @objc func backButtonTapped() {
       
        self.dismiss(animated: true)
        khalti?.onMessage(OnMessagePayload(event: OnMessageEvent.KPGDisposed, message: "Khalti payment page disposed"),khalti)
       
    }
    
    func getPaymentUrl() -> URL?{
        let config = self.khalti?.config
        let urlEnv = (config?.isProd() ?? false) ?  Url.BASE_PAYMENT_URL_PROD : Url.BASE_PAYMENT_URL_STAGING
        
        let url = URL(string:urlEnv.rawValue)?.appendQueryParams([URLQueryItem(name: "pidx", value: config?.pIdx ?? "")])
        
        return url
    }
    
    
    func loadRequest() {
        // To clear Cache of WkWebView
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {
                if let myRequest = self.request {
                    self.wkWebView.load(myRequest)
                    
                }else{
                    self.stopLoadingView()
                    self.khalti?.onMessage(OnMessagePayload(event: OnMessageEvent.ReturnUrlLoadFailure, message: "Error while creating Url"),self.khalti)
                }
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // Change status bar color to light
    }
    
    
    
    func createPaymentWebView(){
        
        wkWebView.frame = view.bounds
        wkWebView.center = view.center
        wkWebView.isOpaque = false
        
        // Initialize WKWebView with a configuration
        let configuration = WKWebViewConfiguration()
        wkWebView = WKWebView(frame: .zero, configuration: configuration)
        
        
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wkWebView)
        
        wkWebView.navigationDelegate = self
        
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        
    }
    
    private func loadUrl(){
        if let url = getPaymentUrl(){
            //        request = URLRequest(url: url)
            request = URLRequest(url:url)
            
            loadRequest()
            
        }
    }
    
    func addNavigationBar(){
        let statusBarView = UIView()
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        statusBarView.backgroundColor = UIColor(hex: 0xE8F0F7)
        view.addSubview(statusBarView)
        
        NSLayoutConstraint.activate([
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationBar.backgroundColor = UIColor(hex: 0xE8F0F7)
        navigationBar.barTintColor = UIColor(hex: 0xE8F0F7)

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        
        let navigationItem = UINavigationItem(title: "Payment Gateway")
        
        if #available(iOS 13.0, *) {
            let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
            backButton.tintColor = .black
            navigationItem.leftBarButtonItem = backButton
        } else {
            let backButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(backButtonTapped))
            backButton.tintColor = .black
            navigationItem.leftBarButtonItem = backButton
        }

        navigationBar.items = [navigationItem]
    }

    
    private  func stopLoadingView(){
        self.loadingView.stopLoading()
    }
    
    
    private  func startLoadingView(){
        self.loadingView.startLoading()
    }
    
}


extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - WebView Delegates function

extension KhaltiPaymentViewController :WKNavigationDelegate, WKUIDelegate{
    // WKNavigationDelegate methods to handle errors
    
    func webView(_ webView:WKWebView, didFailProvisionalNavigation: WKNavigation!, withError error: any Error){
        
        self.stopLoadingView()
        self.khalti?.onMessage(OnMessagePayload(event: OnMessageEvent.ReturnUrlLoadFailure, message:error.localizedDescription,code: nil, needsPaymentConfirmation: true),self.khalti)
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        self.stopLoadingView()
        if let httpResponse = navigationResponse.response as? HTTPURLResponse {
            
            if let returnUrl ,(httpResponse.url?.description ?? "") .contains(returnUrl) {
                self.khalti?.onReturn?(khalti)
                self.verifyPaymentStatus()
                
            }
        }
        decisionHandler(.allow)
    }
    
}


extension KhaltiPaymentViewController:KhaltiPaymentViewControllerProtocol{
    func fetchPaymentDetail(){
        self.startLoadingView()
        
        self.viewModel?.getPaymentDetail(onCompletion: { [weak self ] response in
            self?.returnUrl = response.returnUrl
            DispatchQueue.main.async {
                
                self?.loadUrl()
                
            }
            
        }, onError: {[weak self] msg in
            
            DispatchQueue.main.async{
                self?.stopLoadingView()
                self?.showCustomDialog(message: msg,onTapped: {
                    self?.dialogView.removeFromSuperview()
                }
                )
            }
            
        }
        )
        
        
    }
    
    func verifyPaymentStatus() {
        self.startLoadingView()
        viewModel?.verifyPaymentStatus(onCompletion: { [weak self ] response in
            DispatchQueue.main.async {
                self?.stopLoadingView()
                self?.khalti?.onPaymentResult(PaymentResult(status: response.status, payload: response), self?.khalti!)
                
            }
            
        }, onError: {[weak self] msg in
            DispatchQueue.main.async {
                self?.stopLoadingView()
                
            }
            
        }
        )
        
    }
}
