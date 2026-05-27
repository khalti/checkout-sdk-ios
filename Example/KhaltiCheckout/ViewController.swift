//
//  ViewController.swift
//  KhaltiCheckout
//
//  Created by bikash giri on 05/13/2024.
//  Copyright (c) 2024 bikash giri. All rights reserved.
//

import UIKit
import KhaltiCheckout

class ViewController: UIViewController {
    var khalti:Khalti?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        khalti = Khalti.init(config: KhaltiPayConfig(publicKey:"4aa1b684f4de4860968552558fc8487d", pIdx:"8mBsbuzGYDWveAZkMn4Q2F",environment:Environment.TEST), onPaymentResult: {[weak self] (paymentResult,khalti) in
            print("Demo | onPaymentResult", paymentResult)
            khalti?.close()
            
            self?.showSuccessAlert(title: "Success", message: paymentResult.message ?? "Success")
            
            
        }, onMessage: {[weak self](onMessageResult,khalti) in
            
            //Handle onMessage callback here
            //if needsPaymentConfiramtion true then verify payment status
            
            self?.showSuccessAlert(title: "", message: onMessageResult.message)
            
            let shouldVerify = onMessageResult.needsPaymentConfirmation
        
            if shouldVerify {
                khalti?.verify()
            }else{
                khalti?.close()
            }
            
            
        }, onReturn: {(khalti) in
            // called when payment is success
        })
        setUpView()
    }
    
    private func setUpView() {
        
        // ScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
        
        // Container View
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        // ImageView
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "seru")
        containerView.addSubview(imageView)
        
        // CustomTextFieldView for Public Key
        let publicKeyTextView = CustomTextFieldView(placeHolder: "Public Key")
        publicKeyTextView.translatesAutoresizingMaskIntoConstraints = false
        publicKeyTextView.addText(text: khalti?.config.publicKey ?? "")
        publicKeyTextView.textChanged = { text in
            self.khalti?.config.publicKey = text
            // Handle text changes here
        }
        containerView.addSubview(publicKeyTextView)
        
        // CustomTextFieldView for PIDX
        let pIdxTextView = CustomTextFieldView(placeHolder: "PIDX")
        pIdxTextView.translatesAutoresizingMaskIntoConstraints = false
        pIdxTextView.addText(text: khalti?.config.pIdx ?? "")
        pIdxTextView.textChanged = { text in
            self.khalti?.config.pIdx = text
            // Handle text changes here
        }
        containerView.addSubview(pIdxTextView)
        
        let segmentTitleLabel = UILabel()
        segmentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentTitleLabel.text = "Environment"
        segmentTitleLabel.textColor = .black
        containerView.addSubview(segmentTitleLabel)

    
        
        // CustomRadioButton
        let customRadioButton = CustomRadioButton(selectedEnvironment: self.khalti?.config.environment ?? Environment.TEST)
        customRadioButton.translatesAutoresizingMaskIntoConstraints = false
        customRadioButton.backgroundColor = .white
        customRadioButton.onSelected = { [weak self] env in
            self?.khalti?.config.environment = env
            
        }
        containerView.addSubview(customRadioButton)
//        
        let feeLabel = UILabel()
        feeLabel.font = .systemFont(ofSize: 22)
        feeLabel.text = "Rs. 22"
        feeLabel.translatesAutoresizingMaskIntoConstraints = false
        feeLabel.textColor = .black.withAlphaComponent(0.8)
        
        containerView.addSubview(feeLabel)
        
        let dayLabel = UILabel()
        dayLabel.text = "1 day Fee"
        dayLabel.font = .systemFont(ofSize: 12)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textColor = .black.withAlphaComponent(0.8)
        
        containerView.addSubview(dayLabel)
        
        let merchantLabel = UILabel()
        merchantLabel.text = "This is a demo application developed by some merchant"
        merchantLabel.font = .systemFont(ofSize: 12)
        
        merchantLabel.translatesAutoresizingMaskIntoConstraints = false
        merchantLabel.textColor = .black.withAlphaComponent(0.8)
        
        containerView.addSubview(merchantLabel)
        
        // Button
        let button = UIButton(type: .system)
        button.setTitle("Pay Rs. 22", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.1)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25 // Adjust the corner radius as needed
        button.clipsToBounds = true
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(button)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // Constraints for ScrollView and Container View
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        // Constraints for ImageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 70),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        // Constraints for PublicKeyTextView
        NSLayoutConstraint.activate([
            publicKeyTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            publicKeyTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            publicKeyTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            publicKeyTextView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        // Constraints for PIdxTextView
        NSLayoutConstraint.activate([
            pIdxTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            pIdxTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            pIdxTextView.topAnchor.constraint(equalTo: publicKeyTextView.bottomAnchor, constant: 20),
            pIdxTextView.heightAnchor.constraint(equalToConstant: 70),
        ])
               
        NSLayoutConstraint.activate([
            segmentTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            segmentTitleLabel.topAnchor.constraint(equalTo: pIdxTextView.bottomAnchor, constant: 30),
        ])
        
        
        // Constraints for CustomRadioButton
        NSLayoutConstraint.activate([
            customRadioButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            customRadioButton.topAnchor.constraint(equalTo: segmentTitleLabel.bottomAnchor, constant: 15),
            customRadioButton.widthAnchor.constraint(equalToConstant: 110),
        ])
        
        
        // Constraints for feeLabel
        NSLayoutConstraint.activate([
            feeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            feeLabel.topAnchor.constraint(equalTo: customRadioButton.bottomAnchor, constant: 40),
            
        ])
        
        // Constraints for dayLabel
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            dayLabel.topAnchor.constraint(equalTo: feeLabel.bottomAnchor, constant: 15),
            
        ])
        
        
        // Constraints for Button
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            button.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 150),
//            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -150),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        // Constraints for merchantLabel
        NSLayoutConstraint.activate([
            merchantLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            merchantLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 40),
//            merchantLabel.widthAnchor.constraint(equalToConstant: 150),
            merchantLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -150),
//            merchantLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    
    @objc func buttonTapped() {
        
        khalti?.open(viewController: self)
        
        
    }
    
    @objc func showSuccessAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}





class CustomTextFieldView: UIView,UITextFieldDelegate {
    var placeHolder:String?
    var textChanged: ((String) -> Void)?
    
    
    // First UITextField
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.backgroundColor = UIColor.blue.withAlphaComponent(0.1) // Set
        
        return textField
    }()
    
    // Second UITextField
    let label:  UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        
        label.font = UIFont.systemFont(ofSize: 14) // Adjust font size if necessary
        return label
    }()
    
    init(placeHolder:String){
        super.init(frame: .zero)
        self.placeHolder = placeHolder
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    func addText(text:String){
        textField.text = text
    }
    
    private func setupUI() {
        
        addSubview(label)
        addSubview(textField)
        textField.delegate = self
        
        label.text = placeHolder
        NSLayoutConstraint.activate([
            // Constraints for firstTextField
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            
            // Constraints for secondTextField
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textChanged?(textField.text ?? "")
    }
    
}




class CustomRadioButton: UIView {
    
    var onSelected: ((Environment) -> Void)?
    var selectedEnvironment: Environment = Environment.TEST // Initialize with an empty string or any default value
    
    // Radio Button 1
    lazy var prodButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  PROD  ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
    
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // Radio Button 2
    lazy var testButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  TEST  ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    init(selectedEnvironment: Environment) {
        self.selectedEnvironment = selectedEnvironment
        super.init(frame: .zero)
        setupUI()
        radioButtonTapped(testButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    @objc private func radioButtonTapped(_ sender: UIButton) {
        if sender == prodButton {

            
            prodButton.backgroundColor = .blue.withAlphaComponent(0.3)
            prodButton.layer.cornerRadius = 5
            
            
            testButton.backgroundColor = .blue.withAlphaComponent(0.1)
testButton.layer.cornerRadius = 0
            
            selectedEnvironment = Environment.PROD
        } else if sender == testButton {
                        
            testButton.backgroundColor = .blue.withAlphaComponent(0.3)
            testButton.layer.cornerRadius = 5
            
            
            prodButton.backgroundColor = .blue.withAlphaComponent(0.1)
            prodButton.layer.cornerRadius = 0
            
            selectedEnvironment = Environment.TEST
        }
        onSelected?(selectedEnvironment)
    }
    
    private func setupUI() {
 
        
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        addSubview(prodButton)
        addSubview(testButton)
        
        NSLayoutConstraint.activate([
    
            prodButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            prodButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            prodButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0),
            
            // Constraints for testButton
            testButton.leadingAnchor.constraint(equalTo:prodButton.trailingAnchor,constant: 2),
            testButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            testButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0),

        ])
        
        
    }
}

