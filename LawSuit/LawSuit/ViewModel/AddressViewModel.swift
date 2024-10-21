//
//  AddressViewModel.swift
//  LawSuit
//
//  Created by Emily Morimoto on 09/09/24.
//

import Foundation
import Combine
import SwiftUI


class AddressViewModel: ObservableObject {
    
    @MainActor
    func fetch(for cep: String) async -> AddressAPI? {
        guard let url = URL(string: "https://viacep.com.br/ws/\(cep)/json/") else {
            print("URL inválida")
            return nil
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let places = try JSONDecoder().decode(AddressAPI.self, from: data)
                    return places
                } else {
                    print("Request status code error: \(httpResponse.statusCode) - \(cep)")
                    return nil
                }
            } else {
                print("Response type error")
                return nil
            }
                        
        } catch {
            print(error)
            return nil
        }
    }
}
