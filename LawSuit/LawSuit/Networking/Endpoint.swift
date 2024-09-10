//
//  Endpoint.swift
//  LawSuit
//
//  Created by Giovanna Micher on 09/09/24.
//

import Foundation

//enum ao inves de string para evitar erros de digitacao

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}


protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get } //get, put, post, delete
    var header: [String: String]? { get } //onde enviamos configuracoes a mais, por exemplo o token
    var body: [String: String]? { get }
}

//para valores que nao mudam muito, vou implementar essa extensao

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api-publica.datajud.cnj.jus.br"
    }
}
