//
//  higherCourtsEndpoint.swift
//  LawSuit
//
//  Created by Giovanna Micher on 09/09/24.
//

import Foundation

enum JusticaResponsavel: Int {
    case tribunalSuperior = 1
    case justicaFederal = 2
    case justicaEstadual = 3
}

let justicaResponsavel = "1"
let tribunal = "01"
let lawsuitNumber = "NNNNNNN-DD.AAAA.\(justicaResponsavel).\(tribunal).OOOO"


struct Processo {
    let numero: String
    let ano: String
    let responsavel: JusticaResponsavel
    let vara: String
    let numeroDaVara: String
    
    init?(codigo: String) {
        let splited = codigo.split(separator: ".")
        
        guard splited.count != 5 else {
            return nil
        }
        
        numero = String(splited[0])
        
        return nil
    }
}

enum SegmentosDoJudiciario {
    
    case tribunalSuperior(TribunalSuperior)
    case justicaFederal(JusticaFederal)
    case justicaEstadual(JusticaEstadual)
    
    //MARK: - Terminar de mapear
    //    case justicaDoTrabalho
    //    case justicaEleitoral
    //    case justicaMilitar
}

//var seg: SegmentosDoJudiciario = .justicaEstadual(.tribunalSaoPaulo)
