//
//  KhaltiPaymentControllerViewModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/11/24.
//

import Foundation

class KhaltiPaymentControllerViewModel {
    var khalti:Khalti?
    
    let service = KhaltiAPIService()
    
    
    
    init(khalti:Khalti? = nil) {
        self.khalti = khalti
    }
    
    func getPaymentDetail(onCompletion: @escaping ((PaymentDetailModel)->()), onError: @escaping ((String)->())){
        
        let baseUrl = getBaseUrl()
        let url = baseUrl.appendUrl(url: Url.PAYMENT_DETAIL)
        if let pIdx = khalti?.config.pIdx {
            var params = [String:String]()
            params["pidx"] = pIdx
            service.fetchDetail(urlInString:url,params: params,publicKey: khalti?.config.publicKey ?? "", onCompletion: {(response) in
                onCompletion(response)
                
            }, onError: {(error) in
                if error.errorType != FailureType.noNetwork{
                    onError(error.errorMessage ?? "There was an error setting up your payment. Please try again later.")
                }else{
                    onError(error.errorMessage ?? "No internet Connection")
                }
            })
        }
        
        
        
    }
    
    func verifyPaymentStatus(onCompletion:@escaping((PaymentLoadModel)->()),onError: @escaping ((String)->())){
        let baseUrl = getBaseUrl()
        let url = baseUrl.appendUrl(url: Url.LOOKUP_SDK)
        if let pIdx = khalti?.config.pIdx {
            var params = [String:String]()
            params["pidx"] = pIdx
        
            service.fetchPaymentStatus(url:url,params: params,publicKey: khalti?.config.publicKey ?? "", onCompletion: {(response) in
                onCompletion(response)
            }, onError: {[weak self](error) in
                onError("")
                self?.handleError(error: error, isPayment: true)
                
            })
            
        }
    }
    
    private func handleError(error:ErrorModel,isPayment:Bool){
        let viewModelData = KhaltiPaymentViewDataModel(errorModel:error,isPayment:isPayment )
        DispatchQueue.main.async { [weak self] in
            self?.khalti?.onMessage(viewModelData.returnOnMessagePayload(), self?.khalti)
        }
    }
    
    private func getBaseUrl() ->Url{
        let isProd = khalti?.config.isProd() ?? false
        let baseUrl = isProd ? Url.BASE_KHALTI_URL_PROD: Url.BASE_KHALTI_URL_STAGING
        return baseUrl
    }
}
