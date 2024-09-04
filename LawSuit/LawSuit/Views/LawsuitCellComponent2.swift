//
//  LawsuitCellComponent2.swift
//  LawSuit
//
//  Created by Giovanna Micher on 03/09/24.
//

import SwiftUI

struct LawsuitCellComponent2: View {
    var client: Client
    var lawyer: Lawyer
    var lawsuit: Lawsuit
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack {
            VStack {
                VStack(alignment: .leading) {
                    Text(lawsuit.name ?? "Sem nome")
                        .font(.callout)
                        .bold()
                    Text(lawsuit.number ?? "Sem número")
                        .font(.callout)
                        .foregroundStyle(Color(.gray))
                }
                .frame(width: 210, height: 47, alignment: .leading)
            }
            TagViewComponent(tagType: TagType(s: lawsuit.category ?? "trabalhista")!)
                .frame(width: 120, height: 47, alignment: .leading)

            Group {
                if let latestUpdateDate = coreDataViewModel.updateManager.getLatestUpdateDate(lawsuit: lawsuit) {
                    Text(formatDate(latestUpdateDate))
                } else {
                    Text("Sem atualizações")
                }
                Text(client.name)
                    .frame(width: 140, height: 47, alignment: .leading)
                Text(lawyer.name ?? "Sem nome")
                    .frame(width: 140, height: 47, alignment: .leading)
            }
            .frame(width: 140, height: 47, alignment: .leading)
            .font(.callout)
            .bold()
           
        }
        .padding(.horizontal, 20)
    }
    
    func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            return formatter.string(from: date)
    }
}
