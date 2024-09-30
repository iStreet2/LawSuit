//
//  LawsuitCellComponent2.swift
//  LawSuit
//
//  Created by Giovanna Micher on 03/09/24.
//

import Foundation
import SwiftUI

struct LawsuitCellComponent: View {
    @ObservedObject var client: Client
    @ObservedObject var lawyer: Lawyer
    @ObservedObject var lawsuit: Lawsuit
    @EnvironmentObject var dataViewModel: DataViewModel
    
    //MARK: CoreData
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        
        GeometryReader { geo in
            HStack {
                VStack(alignment: .leading) {
                    Text(lawsuit.name)
                        .lineLimit(1)
                        .font(.callout)
                        .bold()
                    Text(lawsuit.number)
                        .lineLimit(1)
                        .font(.callout)
                        .foregroundStyle(Color(.gray))
                }
                .frame(width: geo.size.width * 0.27, height: 47, alignment: .leading)
                
                Spacer()
                TagViewComponent(tagType: TagType(s: lawsuit.category)!)
                    .frame(width: geo.size.width * 0.12, height: 47, alignment: .leading)
                Spacer()
                
                Group {
                    if lawsuit.isLoading {
                        ProgressView()
                            .scaleEffect(0.5, anchor: .center)
                            .frame(width: geo.size.width * 0.17, height: 30)
                    } else {
                        if let latestUpdateDate = dataViewModel.coreDataManager.updateManager.getLatestUpdateDate(lawsuit: lawsuit)?.convertToString() {
                            Text(latestUpdateDate)
                                .frame(width: geo.size.width * 0.17, height: 47, alignment: .leading)
                        } else {
                            Text("Sem atualizações")
                                .frame(width: geo.size.width * 0.17, height: 47, alignment: .leading)
                        }
                    }

                    Text(client.name)
                        .lineLimit(1)
                        .frame(width: geo.size.width * 0.17, height: 47, alignment: .leading)
                    Text(lawyer.name ?? "Sem nome")
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, minHeight: 47, alignment: .leading)
                }
                .font(.callout)
                .bold()
                
            }
            .padding(.horizontal, 20)
        }
        .frame(minWidth: 777)
        .frame(height: 47)
    }
}
