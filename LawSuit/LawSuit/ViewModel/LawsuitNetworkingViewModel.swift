//
//  LawsuitNetworkingViewModel.swift
//  LawSuit
//
//  Created by Giovanna Micher on 12/09/24.
//

import Foundation
import SwiftUI

class LawsuitNetworkingViewModel: ObservableObject {
        
    private let lawsuitService: LawsuitNetworkingService
    private let lawsuitManager: LawsuitManager
    
    init(lawsuitService: LawsuitNetworkingService, lawsuitManager: LawsuitManager) {
        self.lawsuitService = lawsuitService
        self.lawsuitManager = lawsuitManager
    }

    func fetchAndSaveUpdatesFromAPI(fromLawsuit lawsuit: Lawsuit) {
        Task {
            do {
                let result = try await lawsuitService.fetchLawsuitUpdatesData(fromLawsuit: lawsuit)
                switch result {
                case .success(let updates):   
                    lawsuitManager.addUpdates(lawsuit: lawsuit, updates: updates)
                    print("recebeu \(updates.count) updates para o objeto \(lawsuit.number ?? "ha")")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getLatestUpdateDate(fromLawsuit lawsuit: Lawsuit, updateManager: UpdateManager) -> Date? {
        return updateManager.getLatestUpdateDate(lawsuit: lawsuit)
    }

}
