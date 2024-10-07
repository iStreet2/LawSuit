//
//  LawsuitViewModel.swift
//  LawSuit
//
//  Created by Emily Morimoto on 04/10/24.
//

import Foundation
import SwiftUI

class LawsuitViewModel: ObservableObject {
    
    @Published var tagType: TagType = .trabalhista
    
        //Atualiza o Lawsuit
        func updateLawsuitCategory(lawsuit: Lawsuit) {
            lawsuit.category = tagType.rawValue
        }
}
