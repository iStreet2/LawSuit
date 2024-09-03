//
//  ProcessNameCell.swift
//  LawSuit
//
//  Created by Giovanna Micher on 28/08/24.
//

import SwiftUI

struct LawsuitNameCellComponent: View {
    var lawsuit: Lawsuit
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(lawsuit.name!)
                .font(.callout)
                .bold()
            Text(lawsuit.number!)
                .font(.callout)
                .foregroundStyle(Color(.gray))
        }
        .frame(width: 210, height: 47, alignment: .leading)
        //.border(Color.red)
    }
}

