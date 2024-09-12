//
//  TribunalSuperior.swift
//  LawSuit
//
//  Created by Giovanna Micher on 09/09/24.
//

import Foundation


enum TribunalSuperior: String {
    case trabalho = "/api_publica_tst/_search"
    case eleitoral = "/api_publica_tse/_search"
    case justica = "/api_publica_stj/_search"
    case militar = "/api_publica_stm/_search"
}


enum JusticaFederal {
    case primeiraRegiao
    case segundaRegiao
    case terceiraRegiao
    case quartaRegiao
    case quintaRegiao
    case sextaRegiao
}

enum TribunalDaJusticaEstadual: String {
    case tribunalSaoPaulo = "26"
    //MARK: - Terminar de mapear
    //    case tribunalAcre
    //    case tribunalAlagoas
    
    var endpoint: String {
        switch self {
        case .tribunalSaoPaulo:
            return "/api_publica_tjsp/_search"
        }
    }
}
