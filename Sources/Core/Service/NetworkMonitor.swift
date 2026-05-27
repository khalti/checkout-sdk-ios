//
//  NetworkMonitor.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/19/24.

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .userInitiated)
    
    var isConnected: Bool = false
    var connectionType: NWInterface.InterfaceType?
    private var isMonitoring = false
    
    private init() {
        monitor.pathUpdateHandler = { path in
            print("path called or not")
            print(path)
            self.isConnected = path.status == .satisfied
            self.connectionType = path.availableInterfaces.filter {
                path.usesInterfaceType($0.type)
            }.first?.type
        }
        
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true
        monitor.start(queue: queue)
    }
    
    func removeMonitoring() {
        guard isMonitoring else { return }
        isMonitoring = false
        monitor.cancel()
    }
    
    deinit{
        self.removeMonitoring()
    }
}

