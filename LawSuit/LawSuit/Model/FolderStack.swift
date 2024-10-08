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
    
    func isEmpty() -> Bool {
        if itens.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    func top() -> Folder { //retorna topo
        guard let topElement = itens.last else { fatalError("This stack is empty. Top error") }
        return topElement
    }
    
    mutating func pop() -> Folder { //remove topo e retorna topo
        guard itens.last != nil else { fatalError("This stack is empty. Pop error") }
        return itens.removeLast()
    }
    
    mutating func push(_ folder: Folder) { //colocar
        itens.append(folder)
    }
    
    mutating func reset() { //
        itens.removeAll()
    }
}
