//
//  UpdateManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import Foundation

class UpdateManager {
    
    func getLatestUpdateDate(lawsuit: Lawsuit) -> String? {
        let updatesArray = sortUpdates(lawsuit: lawsuit)
        return updatesArray.first?.date
    }
    
    func sortUpdates(lawsuit: Lawsuit) -> [Update] {
        let updatesArray = lawsuit.updates.sorted {
            ($0.date) > ($1.date) // do maior para o menor
        }
        return updatesArray
    }
}
