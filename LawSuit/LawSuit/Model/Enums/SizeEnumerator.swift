//
//  SizeEnumerator.swift
//  LawSuit
//
//  Created by Emily Morimoto on 28/08/24.
//

import Foundation

enum SizeEnumerator {
    case big
    case small
    
    var size: (width: CGFloat, height: CGFloat) {
        switch self {
        case .big:
            return (width: 700, height: 200)
        case .small:
            return (width: 260, height: 200)
        }
    }
}
