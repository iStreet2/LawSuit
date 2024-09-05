//
//  ProcessCell.swift
//  LawSuit
//
//  Created by Giovanna Micher on 28/08/24.
//

import SwiftUI
import CoreData

struct LawsuitCellComponent: View {
    var client: Client
    var lawyer: Lawyer
    var lawsuit: Lawsuit
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(lawsuit.name ?? "Sem nome")
                    .font(.callout)
                    .bold()
                Text(lawsuit.number ?? "Sem número")
                    .font(.callout)
                    .foregroundStyle(Color(.gray))
            }
            .padding(.trailing)
            TagViewComponent(tagType: TagType(s: lawsuit.category ?? "trabalhista")!)
            
            Group {
                if let latestUpdateDate = dataViewModel.coreDataManager.updateManager.getLatestUpdateDate(lawsuit: lawsuit) {
                    Text(formatDate(latestUpdateDate))
                } else {
                    Text("Sem atualizações")
                }
                Spacer()
                Text(client.name)
                Spacer()
                Text(lawyer.name ?? "Sem nome")
            }
            .font(.callout)
            .bold()
        }
        .padding(10)
    }
    
    func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            return formatter.string(from: date)
    }
}
