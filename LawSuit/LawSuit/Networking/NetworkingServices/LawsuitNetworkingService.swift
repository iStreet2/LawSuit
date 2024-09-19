//
//  LawsuitNetworkingService.swift
//  LawSuit
//
//  Created by Giovanna Micher on 09/09/24.
//

import Foundation
import CoreData
import SwiftUI


class LawsuitNetworkingService {
            
    var updateManager: UpdateManager

    init(updateManager: UpdateManager) {
        self.updateManager = updateManager
    }
    
    func fetchLawsuitUpdatesData(fromLawsuit lawsuit: Lawsuit) async throws -> Result<[Update], Error> {

        guard let url = setupURL(numeroProcesso: lawsuit.number ?? "").url else {
            throw LawsuitRequestError.couldNotCreateURL
        }
        
        let request = try createURLRequest(url: url, numeroProcesso: lawsuit.number)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            try validadeResponse(response: response)
            
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return .failure(LawsuitRequestError.couldNotTransformDataError)
            }
            
            if let updates = try filterLawsuitResponse(json: json, lawsuit: lawsuit) {
                return .success(updates)

            } else {
                return .failure(LawsuitRequestError.couldNotGetUpdatesFromConvertion)
            }
        } catch {
            return .failure(LawsuitRequestError.errorRequest(error: error.localizedDescription))
        }
    }
    
    private func setupURL(numeroProcesso: String) -> URLComponents {
        var urlComponents = URLComponents()
        
        do {
            let (justica, tribunal) = try NetworkingManager.shared.obterJusticaETribunalDoProcesso(lawsuitNumber: numeroProcesso)
            let endpoint = try NetworkingManager.shared.obterEndpointDoProcesso(digitoJusticaResponsavel: justica, digitoTribunal: tribunal)
            
            urlComponents.scheme = "https"
            urlComponents.host = "api-publica.datajud.cnj.jus.br"
            urlComponents.path = endpoint
        } catch {
            print("Erro na hora de montar a url")
        }
        
        return urlComponents
    }
    
    private func createURLRequest(url: URL, numeroProcesso: String?) throws -> URLRequest {
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
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
            print("Erro ao criar o corpo da solicitação")
            throw LawsuitRequestError.couldNotCreateRequestBody
        }
        request.httpBody = httpBody
        return request
    }

    private func validadeResponse(response: URLResponse) throws {
        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else {
                throw LawsuitRequestError.serverError(httpResponse.statusCode)
            }
        }
    }
    
    private func filterLawsuitResponse(json: [String: Any], lawsuit: Lawsuit) throws -> [Update]? {
        //navego pelas chaves para chegar no array de processos (q está dentro de _source)
        guard let hits = json["hits"] as? [String: Any],
              let hitsArray = hits["hits"] as? [[String: Any]],
              let firstHit = hitsArray.last,
              let source = firstHit["_source"] as? [String: Any] else {
            throw LawsuitRequestError.jsonNavigationError
        }
        
        if let movimentos = source["movimentos"] as? [[String: Any]] {
            return try returnUpdatesFromFetch(movimentos: movimentos, lawsuit: lawsuit)
        }

        return nil
    }
    
    private func returnUpdatesFromFetch(movimentos: [[String: Any]], lawsuit: Lawsuit) throws -> [Update] {
        var updates: [Update] = []
        
        //Salvo os movimentos (updates)
            for movimento in movimentos {
                guard let nomeMovimento = movimento["nome"] as? String,
                      let dataHoraString = movimento["dataHora"] as? String else {
                    throw LawsuitRequestError.couldNotGetMovementInfo
                }
                
                let dataHora = dataHoraString.convertToDate()
                
                //Cria uma nova movimentação para cada movimento na API e salva no core data
                let update = updateManager.createUpdate(name: nomeMovimento, date: dataHora, lawsuit: lawsuit)
                updates.append(update)
            }
        
        return updates
    }
    
}


enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}
