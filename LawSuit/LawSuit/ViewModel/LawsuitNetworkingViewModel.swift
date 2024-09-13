//
//  LawsuitNetworkingViewModel.swift
//  LawSuit
//
//  Created by Giovanna Micher on 12/09/24.
//

import Foundation

struct LawsuitNetworkingViewModel {
    
    let lawsuitService: LawsuitNetworkingService
    
    let updateManager: UpdateManager
    
    func getLawsuitUpdates(fromLawsuit lawsuit: Lawsuit) async throws -> Lawsuit? {
        let result = try await lawsuitService.fetchLawsuitUpdatesData(fromLawsuit: lawsuit)
        
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func getLatestUpdateDate(fromLawsuit lawsuit: Lawsuit) -> Date? {
        return updateManager.getLatestUpdateDate(lawsuit: lawsuit)
    }

}
