//
//  SegmentosDoJudiciario.swift
//  LawSuit
//
//  Created by Giovanna Micher on 09/09/24.
//

import Foundation

enum JusticaResponsavel: Int {
    //case tribunalSuperior = 1
    //case justicaFederal = 3
    case justicaEstadual = 8
}

func obterJusticaETribunalDoProcesso(lawsuitNumber: String) -> (justicaRes: String, tribu: String)? {
    let splittedLawsuitNumber = lawsuitNumber.split(separator: ".")
    
    guard splittedLawsuitNumber.count == 5 else {
        print("retornou erado")
        return nil
    }
    
    let justicaResponsavel = String(splittedLawsuitNumber[2])
    let tribunal = String(splittedLawsuitNumber[3])
    
    return (justicaResponsavel, tribunal)
}



func obterEndpointDoProcesso(digitoJusticaResponsavel: String, digitoTribunal: String) -> String? {
    if let justicaResponsavel = SegmentosDoJudiciario.from(codigoJustica: digitoJusticaResponsavel, codigoTribunal: digitoTribunal) {
        print("endpoint: \(justicaResponsavel.endpoint)")
        return justicaResponsavel.endpoint
    }
    return nil
}

enum SegmentosDoJudiciario {
    
    //case tribunalSuperior(TribunalSuperior)
    //case justicaFederal(JusticaFederal)
    case justicaEstadual(JusticaEstadual)
    
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
            return .justicaEstadual(JusticaEstadual.tribunalSaoPaulo)
        default:
            return nil
        }
    }
   
}
