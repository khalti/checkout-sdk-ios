//
//  KhaltiApi.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/6/24.
//

import Foundation
import Network
import UIKit

protocol KhaltiApiServiceProtocol {
    func handleRequest<T: Codable>(request: URLRequest, onSuccess: @escaping (T) -> (), onError: @escaping (ErrorModel) -> ())
}

class KhaltiAPIService {
    
    private func createHttpBody(body:[String:String]) ->Data?{
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            debugPrint("Error converting parameters to JSON")
            return nil
        }
        return jsonData
    }
    
    
    private func createRequest(for url:URL,body:[String:String],publicKey:String) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        request.httpBody = createHttpBody(body: body)
        request.httpMethod = "POST"
        request.setValue("Key \(publicKey)", forHTTPHeaderField: "Authorization")
        request.setValue(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, forHTTPHeaderField: "checkout-version")
        request.setValue("iOS", forHTTPHeaderField: "checkout-platform")
        request.setValue(UIDevice.current.model, forHTTPHeaderField: "checkout-device-model")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forHTTPHeaderField: "merchant-package-name")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "checkout-os-version")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func fetchDetail(urlInString:String,params:[String:String],publicKey:String,onCompletion: @escaping ((PaymentDetailModel)->()), onError: @escaping ((ErrorModel)->())) {
        
        guard let url = URL(string:urlInString) else {
            onError(ErrorModel(errorType:FailureType.Httpcall))
            return
        }
        
        let request = self.createRequest(for: url,body: params,publicKey: publicKey)
        self.handleRequest(request: request, onSuccess: {(model:PaymentDetailModel)in
            onCompletion(model)
        }, onError: {(error) in
            onError(error)
        })
        
    }
    
    
    func fetchPaymentStatus(url:String,params:[String:String],publicKey:String,onCompletion: @escaping ((PaymentLoadModel)->()), onError: @escaping ((ErrorModel)->())) {
        
        guard let url = URL(string: url) else {
            
            return
        }
        
        
        let request = self.createRequest(for: url,body: params,publicKey:publicKey)
        
        self.handleRequest(request: request, onSuccess: {(model:PaymentLoadModel)in
            onCompletion(model)
        }, onError: {(error) in
            onError(error)
        })
        
    }
    
}

extension KhaltiAPIService:KhaltiApiServiceProtocol{
    
    func handleRequest<T:Codable>(request: URLRequest, onSuccess: @escaping (T) -> (), onError: @escaping (ErrorModel) -> ()) {
        let monitor = NetworkMonitor.shared

        let isConnected = monitor.isConnected
        if isConnected{
            debugPrint("===========================================================")
            debugPrint("Request Url:")
            debugPrint (request.url ?? "url empty")
            debugPrint(request.allHTTPHeaderFields ?? "empty header")
            
            print("===========================================================")
            if let bodyData = request.httpBody {
                if let bodyString = String(data: bodyData, encoding: .utf8) {
                    
                    debugPrint("===========================================================")
                    debugPrint("Request httpBody:")
                    debugPrint(bodyString)
                    debugPrint("===========================================================")
                } else {
                    debugPrint("Request does not contain a httpBody.")
                }
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    
                    guard let data = data else {
                        onError(ErrorModel(errorType:FailureType.Generic))
                        
                        return
                    }
                    
                    // Ensure response is an HTTPURLResponse and check the status code
                    guard let httpResponse = response as? HTTPURLResponse else {
                        onError(ErrorModel(errorType:FailureType.Httpcall))
                        return
                    }
                    
                    let statusCode = httpResponse.statusCode
                    print(statusCode)
                    
                    // Handle different status codes
                    switch statusCode {
                        case 200...299:
                            do {
                                let decoder = JSONDecoder()
                                let decodedObject:T = try decoder.decode(T.self, from: data)
                                onSuccess(decodedObject)
                            } catch let decodingError {
                                debugPrint("===========================================================")
                                debugPrint(decodingError)
                                debugPrint("===========================================================")
                                onError(ErrorModel(statusCode: statusCode, errorType:FailureType.ParseError))
                            }
                            //                        return
                            break
                        case 400...499:
                            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                                onError(ErrorModel(statusCode:statusCode,errorType:FailureType.Httpcall))
                                
                                return
                            }
                            if let dict = json as? [String:Any] {
                                onError(ErrorModel(statusCode:statusCode,errorType:FailureType.Httpcall,errorMessage:dict["detail"] as? String ?? "Not Found"))
                            }
                            if let error = error {
                                debugPrint("Client error with status code: \(statusCode)")
                                onError(ErrorModel(statusCode:statusCode,errorType:FailureType.Httpcall,errorMessage:error.localizedDescription))
                                return
                            }
                            
                            
                        case 500...599:
                        debugPrint("Server error with status code: \(statusCode)")
                            onError(ErrorModel(statusCode: statusCode, errorType:FailureType.ServerUnreachable))
                            return
                        default:
                        debugPrint("Unexpected status code: \(statusCode)")
                            onError(ErrorModel(statusCode: statusCode, errorType:FailureType.Generic))
                            return
                    }
                    
                    debugPrint("===========================================================")
                    debugPrint("Received JSON data:", String(data: data, encoding: .utf8) ?? "Invalid UTF-8 data")
                    debugPrint("===========================================================")
                    
                    //                onError(ErrorModel(statusCode: statusCode, errorType:FailureType.Generic,errorMessage: errorMessage))
                    
                }
                task.resume()
            }
        }
        else{
            onError(ErrorModel(errorType:FailureType.noNetwork,errorMessage:"No Internet Connection"))
        }
       
        
    }
    
    
}
