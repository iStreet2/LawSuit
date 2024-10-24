//
//  SegmentosDoJudiciario.swift
//  LawSuit
//
//  Created by Giovanna Micher on 09/09/24.
//

import Foundation

enum SegmentosDoJudiciario {
    
    //case tribunalSuperior(TribunalSuperior)
    //case justicaFederal(JusticaFederal)
    case justicaEstadual(TribunalDaJusticaEstadual)
    
    //MARK: - Terminar de mapear
    //    case justicaDoTrabalho
    //    case justicaEleitoral
    //    case justicaMilitar
    
    var endpoint: String {
        switch self {
        case .justicaEstadual(let tribunal):
            return tribunal.endpoint
        }
    }
    
    static func from(codigoJustica: String, codigoTribunal: String) -> SegmentosDoJudiciario? {
        switch codigoJustica {
        case "8":
            if let tribunal = TribunalDaJusticaEstadual(rawValue: codigoTribunal) {
                return .justicaEstadual(tribunal)
            }
        
        default:
            return nil
        }
        
        return nil
    }
}
