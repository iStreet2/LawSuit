//
//  Stack.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import Foundation


struct FolderStack: Identifiable, Hashable {
    
    public var id = UUID()
    private var itens: [Folder] = []
    
    func getItens() -> [Folder] {
        return itens
    }
    
    func count() -> Int {
        return itens.count
    }
    
    func top() -> Folder {
        guard let topElement = itens.last else { fatalError("This stack is empty. Top error") }
        return topElement
    }
    
    mutating func pop() -> Folder {
        guard itens.last != nil else { fatalError("This stack is empty. Pop error") }
        return itens.removeLast()
    }
    
    mutating func push(_ folder: Folder) {
        itens.append(folder)
    }
}
