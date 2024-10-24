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

//enes
enum TribunalDaJusticaEstadual: String {
    case tribunalAcre = "01"
    case tribunalAlagoas = "02"
    case tribunalAmazonas = "04"
    case tribunalAmapa = "03"
    case tribunalBahia = "05"
    case tribunalCeara = "06"
    case tribunalDistritoFederal = "07"
    case tribunalEspiritoSanto = "08"
    case tribunalGoias = "09"
    case tribunalMaranhao = "10"
    case tribunalMinasGerais = "13"
    case tribunalMatoGrossoSul = "12"
    case tribunalMatoGrosso = "11"
    case tribunalPara = "14"
    case tribunalParaiba = "15"
    case tribunalPernambuco = "17"
    case tribunalPiaui = "18"
    case tribunalParana = "16"
    case tribunalRioDeJaneiro = "19"
    case tribunalRioGrandeDoNorte = "20"
    case tribunalRondonia = "22"
    case tribunalRoraima = "23"
    case tribunalRioGrandeDoSul = "21"
    case tribunalSantaCatarina = "24"
    case tribunalSergipe = "25"
    case tribunalSaoPaulo = "26"
    case tribunalTocantins = "27"
    
    var endpoint: String {
        switch self {
        case .tribunalAcre:
            return "/api_publica_tjac/_search"
        case .tribunalAlagoas:
            return "/api_publica_tjal/_search"
        case .tribunalAmazonas:
            return "/api_publica_tjam/_search"
        case .tribunalAmapa:
            return "/api_publica_tjap/_search"
        case .tribunalBahia:
            return "/api_publica_tjba/_search"
        case .tribunalCeara:
            return "/api_publica_tjce/_search"
        case .tribunalDistritoFederal:
            return "/api_publica_tjdft/_search"
        case .tribunalEspiritoSanto:
            return "/api_publica_tjes/_search"
        case .tribunalGoias:
            return "/api_publica_tjgo/_search"
        case .tribunalMaranhao:
            return "/api_publica_tjma/_search"
        case .tribunalMinasGerais:
            return "/api_publica_tjmg/_search"
        case .tribunalMatoGrossoSul:
            return "/api_publica_tjms/_search"
        case .tribunalMatoGrosso:
            return "/api_publica_tjmt/_search"
        case .tribunalPara:
            return "/api_publica_tjpa/_search"
        case .tribunalParaiba:
            return "/api_publica_tjpb/_search"
        case .tribunalPernambuco:
            return "/api_publica_tjpe/_search"
        case .tribunalPiaui:
            return "/api_publica_tjpi/_search"
        case .tribunalParana:
            return "/api_publica_tjpr/_search"
        case .tribunalRioDeJaneiro:
            return "/api_publica_tjrj/_search"
        case .tribunalRioGrandeDoNorte:
            return "/api_publica_tjrn/_search"
        case .tribunalRondonia:
            return "/api_publica_tjro/_search"
        case .tribunalRoraima:
            return "/api_publica_tjrr/_search"
        case .tribunalRioGrandeDoSul:
            return "/api_publica_tjrs/_search"
        case .tribunalSantaCatarina:
            return "/api_publica_tjsc/_search"
        case .tribunalSergipe:
            return "/api_publica_tjse/_search"
        case .tribunalSaoPaulo:
            return "/api_publica_tjsp/_search"
        case .tribunalTocantins:
            return "/api_publica_tjto/_search"
        }
    }
}
