//
//  LawsuitNetworkingService.swift
//  LawSuit
//
//  Created by Giovanna Micher on 09/09/24.
//

import Foundation

func montarURL(numeroProcesso: String) -> URLComponents {
    var urlComponents = URLComponents()
    
    do {
        let (justica, tribunal) = try obterJusticaETribunalDoProcesso(lawsuitNumber: numeroProcesso)
        let endpoint = try obterEndpointDoProcesso(digitoJusticaResponsavel: justica, digitoTribunal: tribunal)

        urlComponents.scheme = "https"
        urlComponents.host = "api-publica.datajud.cnj.jus.br"
        urlComponents.path = endpoint
    } catch {
        print("Erro na hora de montar a url")
    }
    
    return urlComponents
}

struct LawsuitNetworkingService {

    func fetchLawsuitData(fromProcessNumber numeroProcesso: String) async throws -> Result<[String: Any], Error> {
        guard let url = montarURL(numeroProcesso: numeroProcesso).url else {
            throw LawsuitRequestError.couldNotCreateURL
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethod.post.rawValue
        request.addValue("APIKey cDZHYzlZa0JadVREZDJCendQbXY6SkJlTzNjLV9TRENyQk1RdnFKZGRQdw==", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody: [String: Any] = [
            "query": [
                "match": [
                    "numeroProcesso": numeroProcesso
                ]
            ]
        ]
        
        do {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
                print("Erro ao criar o corpo da solicitação")
                return .failure(LawsuitRequestError.couldNotCreateRequestBody)
            }
            request.httpBody = httpBody
            
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    return .failure(LawsuitRequestError.serverError(httpResponse.statusCode))
                }
            }

            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return .failure(LawsuitRequestError.couldNotTransformDataError)
            }
            print(json)
            
            //navego pelas chaves para chegar no array de processos (q está dentro de _source)
            guard let hits = json["hits"] as? [String: Any],
               let hitsArray = hits["hits"] as? [[String: Any]] else {
                return .failure(LawsuitRequestError.jsonNavigationError)
            }
            
            let lawsuitData = try JSONSerialization.data(withJSONObject: hitsArray.compactMap { $0["_source"] }, options: [])
            print(lawsuitData)
            
        } catch {
            return .failure(LawsuitRequestError.errorRequest(error: error.localizedDescription))
        }
        
        return .success(["alal":"ahahah"])
    }
    
    func obterUltimaMovimentacao() {
        
    }
    
    
}
