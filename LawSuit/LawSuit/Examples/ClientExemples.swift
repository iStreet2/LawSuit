//
//  DocsExemples.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import Foundation


struct ClientExemples {
    
    static func docExemples() -> Client {
    
        let context = CoreDataViewModel().context
        
        var clientNames: [Client] = []
        
        let client = Client(context: context)
        client.name = "Abigail da Silva"
        clientNames.append(client)
        
        print(client)
        
        return client
        
    }
}

