//
//  LawsuitNetworkingService.swift
//  LawSuit
//
//  Created by Giovanna Micher on 09/09/24.
//

import Foundation
import CoreData
import SwiftUI


struct LawsuitNetworkingService {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchLawsuitUpdatesData(fromLawsuit lawsuit: Lawsuit) async throws -> Result<Lawsuit, Error> {
        
        let updateManager = UpdateManager(context: context)
        
        guard let url = montarURL(numeroProcesso: lawsuit.number ?? "").url else {
            throw LawsuitRequestError.couldNotCreateURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethod.post.rawValue
        request.addValue("APIKey cDZHYzlZa0JadVREZDJCendQbXY6SkJlTzNjLV9TRENyQk1RdnFKZGRQdw==", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody: [String: Any] = [
            "query": [
                "match": [
                    "numeroProcesso": lawsuit.number
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
            
            //navego pelas chaves para chegar no array de processos (q está dentro de _source)
            guard let hits = json["hits"] as? [String: Any],
                  let hitsArray = hits["hits"] as? [[String: Any]],
                  let firstHit = hitsArray.first,
                  let source = firstHit["_source"] as? [String: Any] else {
                return .failure(LawsuitRequestError.jsonNavigationError)
            }
            
            //Salvo os movimentos (updates)
            if let movimentos = source["movimentos"] as? [[String: Any]] {
                for movimento in movimentos {
                    guard let nomeMovimento = movimento["nome"] as? String,
                          let dataHoraString = movimento["dataHora"] as? String else {
                        throw LawsuitRequestError.couldNotGetMovementInfo
                    }
                    
                    let dataHora = dataHoraString.convertToDate()
                    
                    //Cria uma nova movimentação para cada movimento na API
                    updateManager.createUpdate(name: nomeMovimento, date: dataHora, lawsuit: lawsuit)
                }
            }
            
            // Salva o contexto com o Lawsuit e seus Updates
            updateManager.saveContext()
           
            return .success(lawsuit)
            
        } catch {
            return .failure(LawsuitRequestError.errorRequest(error: error.localizedDescription))
        }
    }
    
    private func montarURL(numeroProcesso: String) -> URLComponents {
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
}


enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}
