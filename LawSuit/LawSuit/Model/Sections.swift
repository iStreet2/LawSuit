//
//  Sections.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 27/08/24.
//

import Foundation

enum Sections: Identifiable, CaseIterable, Hashable {
    
    case clients
    case lawsuits
    
    var id: String {
        switch self {
        case .clients:
            "clients"
        case .lawsuits:
            "lawsuits"
        }
    }
    
    var displayName: String {
        switch self {
        case .clients:
            "Clientes"
        case .lawsuits:
            "Processos"
        }
    }
    
    var iconName: String {
        switch self {
        case .clients:
            "person.2"
        case .lawsuits:
            "briefcase"
        }
    }
    
    static var allCases: [Sections] {
        [.clients, .lawsuits]
    }
    
    static func == (lhs: Sections, rhs: Sections) -> Bool {
        lhs.id == rhs.id
    }
    
}
