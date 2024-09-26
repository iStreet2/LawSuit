//
//  NetworkingManager.swift
//  LawSuit
//
//  Created by Giovanna Micher on 12/09/24.
//

import Foundation

struct NetworkingManager {
    
    static var shared = NetworkingManager()
    
    func removeCharactersFromLawsuitNumber(lawsuitNumber: String) -> String {
        let lawsuitNumberWithoutSpecialCharacters = lawsuitNumber.replacingOccurrences(of: ".-", with: "")
        return lawsuitNumberWithoutSpecialCharacters
    }
    
    func obterJusticaETribunalDoProcesso(lawsuitNumber: String) throws -> (justicaRes: String, tribu: String)  {
        
        guard lawsuitNumber.count == 20 else {
            throw LawsuitNumberError.invalidLawsuitNumber
        }
        
        let inicio = lawsuitNumber.index(lawsuitNumber.startIndex, offsetBy: 14)
        let fim = lawsuitNumber.index(lawsuitNumber.startIndex, offsetBy: 16)
        
        let justicaResponsavel = String(lawsuitNumber[lawsuitNumber.index(lawsuitNumber.startIndex, offsetBy: 13)])
        
        let tribunal = String(lawsuitNumber[inicio..<fim])
        
        print("justicaResponsavel: \(justicaResponsavel), tribunal: \(tribunal)")
        return (justicaResponsavel, tribunal)
    }

    func obterEndpointDoProcesso(digitoJusticaResponsavel: String, digitoTribunal: String) throws -> String {
        
        guard let segmentoResponsavel = SegmentosDoJudiciario.from(codigoJustica: digitoJusticaResponsavel, codigoTribunal: digitoTribunal) else {
            throw LawsuitNumberError.couldNotGetEndpointFromEnum
        }
        print(segmentoResponsavel.endpoint)
        return segmentoResponsavel.endpoint
    }
}
