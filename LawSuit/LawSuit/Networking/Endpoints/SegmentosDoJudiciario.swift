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

func obterJusticaETribunalDoProcesso(lawsuitNumber: String) throws -> (justicaRes: String, tribu: String)  {
//    let splittedLawsuitNumber = lawsuitNumber.split(separator: ".")
//    
//    guard splittedLawsuitNumber.count == 5 else {
//        throw LawsuitNumberError.invalidLawsuitNumber
//    }
//    
    let inicio = lawsuitNumber.index(lawsuitNumber.startIndex, offsetBy: 14)
    let fim = lawsuitNumber.index(lawsuitNumber.startIndex, offsetBy: 16)
    
    let justicaResponsavel = String(lawsuitNumber[lawsuitNumber.index(lawsuitNumber.startIndex, offsetBy: 13)])
    
    let tribunal = String(lawsuitNumber[inicio..<fim])
    
    print("justicaRepsonsavel: \(justicaResponsavel), tribunal: \(tribunal)")
    return (justicaResponsavel, tribunal)
}

func obterEndpointDoProcesso(digitoJusticaResponsavel: String, digitoTribunal: String) throws -> String {
    
    guard let segmentoResponsavel = SegmentosDoJudiciario.from(codigoJustica: digitoJusticaResponsavel, codigoTribunal: digitoTribunal) else {
        throw LawsuitNumberError.couldNotGetEndpointFromEnum
    }
    print(segmentoResponsavel.endpoint)
    return segmentoResponsavel.endpoint
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
            if let tribunal = JusticaEstadual(rawValue: codigoTribunal) {
                return .justicaEstadual(tribunal)
            }
        default:
            return nil
        }
        
        return nil
    }
}
