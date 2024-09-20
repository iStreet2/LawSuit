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
    
    //fazer: chamada da funcao salva duplicado kkkk fodae
    func fetchAndSaveUpdatesFromAPI(fromLawsuit lawsuit: Lawsuit) {
        
        Task {
            do {
                let result = try await lawsuitService.fetchLawsuitUpdatesData(fromLawsuit: lawsuit)
                switch result {
                case .success(let updatesFromAPI):
                    print("Antes da iteracao: \(lawsuit.updates?.count) movimentacoes para o processo \(lawsuit.number ?? "")")
                    let existingUpdates = lawsuit.updates ?? []
                    let newUpdates = updatesFromAPI.filter { updateFromAPI in
                        !(existingUpdates.contains(where: { ($0 as AnyObject).date == updateFromAPI.date }))
                        //newUpdates são updates que não são iguais aos do array de updates existente
                    }
                    
                    if lawsuit.updates?.count == 0 {
                        for update in updatesFromAPI {
                            lawsuitManager.appendUpdate(lawsuit: lawsuit, update: update)
                        }
                        print("Array de updates estava vazio e adicionou \(updatesFromAPI.count) novos updates para o processo \(lawsuit.number ?? "")")
                    } else if !newUpdates.isEmpty {
                        for newUpdate in newUpdates {
                            lawsuitManager.appendUpdate(lawsuit: lawsuit, update: newUpdate)
                        }
                        print("Adicionou \(newUpdates.count) novos updates para o processo \(lawsuit.number ?? "ha")")
                    } else {
                        print("Já tinha updates no lawsuit e não há updates novos vindos da api para o processo \(lawsuit.number ?? "ha")")
                    }
                    
                    print("Depois da iteracao: \(lawsuit.updates?.count) movimentacoes para o processo \(lawsuit.number)")
 
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
