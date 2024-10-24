//
//  NetworkMonitor.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 26/08/24.
//

import Foundation
import CoreData
import Network

final class NetworkMonitorViewModel: ObservableObject {
        
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    private var debounceWorkItem: DispatchWorkItem?
    
    @Published var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
//                if self?.isConnected == true {
//                    self?.triggerSyncToCloudWithDebounce()
//                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
    
//    private func triggerSyncToCloudWithDebounce() {
//        debounceWorkItem?.cancel()
//        
//        let workItem = DispatchWorkItem { [weak self] in
//            print("Mandando os dados para a nuvem após o debounce")
//            self?.isConnected = true
//        }
//        
//        debounceWorkItem = workItem
//        workerQueue.asyncAfter(deadline: .now() + 1.0, execute: workItem)
//    }
}
