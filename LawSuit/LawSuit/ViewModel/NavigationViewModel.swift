//
//  NavigationViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 04/09/24.
//

import Foundation


class NavigationViewModel: ObservableObject {
    
    @Published var selectedClient: Client? = nil
    @Published var isClientSelected: Bool = false
    @Published var dismissLawsuitView = false
    
}
