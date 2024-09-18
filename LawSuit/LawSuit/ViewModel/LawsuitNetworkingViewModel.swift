//
//  LawsuitNetworkingViewModel.swift
//  LawSuit
//
//  Created by Giovanna Micher on 12/09/24.
//

import Foundation
import SwiftUI

class LawsuitNetworkingViewModel: ObservableObject {
    
    @Published var updates: [Update] = []
            
    private let lawsuitService: LawsuitNetworkingService
    
    init(lawsuitService: LawsuitNetworkingService) {
        self.lawsuitService = lawsuitService
    }

    func fetchUpdatesDataFromLawsuit(fromLawsuit lawsuit: Lawsuit) {
        Task {
            do {
                let result = try await lawsuitService.fetchLawsuitUpdatesData(fromLawsuit: lawsuit)
                switch result {
                case .success(let updatesFromAPI):
                    updates = updatesFromAPI
                    print("recebeu o array de updates para o objeto \(lawsuit.number ?? "ha")")
                    //print("updates: \(updates)")
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
