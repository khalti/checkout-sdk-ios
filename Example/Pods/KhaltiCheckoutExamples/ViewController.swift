//
//  ViewController.swift
//  KhaltiCheckoutExamples
//
//  Created by Mac on 6/6/24.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the button
               let button = UIButton(type: .system)
               button.setTitle("Click Me", for: .normal)
               button.backgroundColor = .systemBlue
               button.setTitleColor(.white, for: .normal)
               button.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout

               // Add the button to the view
               view.addSubview(button)

               // Set up Auto Layout constraints
               NSLayoutConstraint.activate([
                   button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   button.widthAnchor.constraint(equalToConstant: 200),
                   button.heightAnchor.constraint(equalToConstant: 50)
               ])
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    

    @objc func buttonTapped() {
        Khalti.init(config: KhaltiPayConfig(publicKey:"live_public_key_979320ffda734d8e9f7758ac39ec775f", pIdx:"EKatER7gGM4ayxk3U2ijmK",environment:Environment.TEST), onPaymentResult: (_,__){
            
        }, onMessage: (){
            
        }, onReturn: (){
            
        })

      }

}

