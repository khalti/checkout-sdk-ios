//
//  KhaltiGlobal.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/10/24.
//

import Foundation

class KhaltiGlobal {
    
    static var shared = KhaltiGlobal()
    static var khaltiConfig:KhaltiPayConfig?
    static var khalti:Khalti?
    
    static func setKhaltiPayconfig(config:KhaltiPayConfig){
        self.khaltiConfig = config
    }
    
    static func setKhalti(khalti:Khalti){
        self.khalti = khalti
    }
    
    static func getKhalti(khalti:Khalti) -> Khalti?{
        return self.khalti
        
    }
    
    
    
    static func getKhaltiPayconfig() -> KhaltiPayConfig?
    {
        return self.khaltiConfig;
    }
    
}
