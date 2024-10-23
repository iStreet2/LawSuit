//
//  ShortCutsViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 21/10/24.
//

import Foundation


class ShortCutsViewModel: ObservableObject {
    
    @Published var addClient = false
    @Published var addLawsuit = false
    @Published var newFolder = false
    @Published var newFile = false
    @Published var searth = false
    @Published var sendEmail = false
    
    @Published var goToClients = false
    @Published var goToLawsuits = false
    @Published var showClientsSideBar = false
    @Published var showClientLawsuits = false
    @Published var showClientDocuments = false
    @Published var isShowingGridView = false
    
    
}
