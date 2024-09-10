//
//  TribunalSuperior.swift
//  LawSuit
//
//  Created by Giovanna Micher on 09/09/24.
//

import Foundation

enum TribunalSuperior {
    case trabalho
    case eleitoral
    case justica
    case militar
    
    var path: String {
        switch self {
        case .trabalho:
            return "api_publica_tst/_search"
        case .eleitoral:
            return "api_publica_tse/_search"
        case .justica:
            return "api_publica_stj/_search"
        case .militar:
            return "api_publica_stm/_search"
        }
    }
}

enum JusticaFederal {
    case primeiraRegiao
    case segundaRegiao
    case terceiraRegiao
    case quartaRegiao
    case quintaRegiao
    case sextaRegiao
    
    var path: String {
        switch self {
        case .primeiraRegiao:
            return ""
        case .segundaRegiao:
            return ""
        case .terceiraRegiao:
            return ""
        case .quartaRegiao:
            return ""
        case .quintaRegiao:
            return ""
        case .sextaRegiao:
            return ""
        }
    }
}

enum JusticaEstadual {
    case tribunalSaoPaulo
    //MARK: - Terminar de mapear
    //    case tribunalAcre
    //    case tribunalAlagoas
    
    var path: String {
        switch self {
        case .tribunalSaoPaulo:
            return "api_publica_tjsp/_search"
        }
    }
}
