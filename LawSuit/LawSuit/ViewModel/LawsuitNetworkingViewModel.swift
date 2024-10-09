//
//  LawsuitNetworkingViewModel.swift
//  LawSuit
//
//  Created by Giovanna Micher on 12/09/24.
//

import Foundation
import SwiftUI

class LawsuitNetworkingViewModel: ObservableObject {
    
    var updateManager: UpdateManager
    var lawsuitManager: LawsuitManager
    private let lawsuitService: LawsuitNetworkingServiceProtocol
    
    init(updateManager: UpdateManager, lawsuitManager: LawsuitManager, lawsuitService: LawsuitNetworkingServiceProtocol) {
        self.updateManager = updateManager
        self.lawsuitManager = lawsuitManager
        self.lawsuitService = lawsuitService
    }
    
    func fetchAndSaveUpdatesFromAPI(fromLawsuit lawsuit: Lawsuit) {
        if lawsuit.isLoading == true {
            print("loading ignored")
            lawsuit.isLoading = false
            return
        }
        lawsuit.isLoading = true
        Task {
            do {
                let result = try await lawsuitService.fetchLawsuitUpdatesData(fromLawsuit: lawsuit)
                switch result {
                case .success(let updatesFromAPI):
                    print("Antes da iteracao: \(String(describing: lawsuit.updates.count)) movimentacoes para o processo \(lawsuit.number)")
                    let existingUpdates = lawsuit.updates
                    let newUpdates = updatesFromAPI.filter { updateFromAPI in
                        !existingUpdates.contains(where: { $0.date == updateFromAPI.date })
                        // newUpdates são updates que não são iguais aos do array de updates existente
                    }
                    
                    if lawsuit.updates.count == 0 {
                        for update in updatesFromAPI {
                            await MainActor.run {
                                self.lawsuitManager.appendUpdate(lawsuit: lawsuit, update: update)
                            }
                        }
                        print("Array de updates estava vazio e adicionou \(updatesFromAPI.count) novos updates para o processo \(lawsuit.number)")
                        
                    } else if !newUpdates.isEmpty {
                        for newUpdate in newUpdates {
                            await MainActor.run {
                                self.lawsuitManager.appendUpdate(lawsuit: lawsuit, update: newUpdate)
                            }
                        }
                        print("Adicionou \(newUpdates.count) novos updates para o processo \(lawsuit.number)")
                        
                    } else {
                        print("Já tinha updates no lawsuit e não há updates novos vindos da api para o processo \(lawsuit.number)")
                    }
                    print("Depois da iteracao: \(String(describing: lawsuit.updates.count)) movimentacoes para o processo \(lawsuit.number)")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            } catch {
                print("Erro no Task:\(error.localizedDescription)")
            }
            lawsuit.isLoading = false
        }
    }
    
    func getLatestUpdateDate(fromLawsuit lawsuit: Lawsuit) -> String? {
        return updateManager.getLatestUpdateDate(lawsuit: lawsuit)
    }
}
