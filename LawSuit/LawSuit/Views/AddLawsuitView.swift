//
//  NewProcessView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 23/08/24.
//

import SwiftUI
import CoreData

enum LawsuitType: String {
    case distributed = "Distribuído"
    case notDistributed = "Não Distribuído"
}

struct AddLawsuitView: View {
    
    //MARK: Variáveis de estado
    @State var lawsuitType: LawsuitType = .distributed
    @State var lawsuitTypeString: String = ""
    @State var lawsuitNumber = ""
    @State var lawsuitCourt = ""
    @State var lawsuitAuthorName = ""
    @State var lawsuitDefandentName = ""
    @State var lawsuitActionDate = Date()

    
    //MARK: ViewModels
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context

    
    var body: some View {
        VStack(alignment: .leading){
            Text("Novo Processo")
                .bold()
                .font(.title)
            VStack(alignment: .leading) {
                CustomSegmentedControl(
                    selectedOption: $lawsuitTypeString, infos: ["Distribuído","Não Distribuído"])
            }
            if lawsuitType == .distributed {
                LawsuitDistributedView(lawsuitNumber: $lawsuitNumber, lawsuitCourt: $lawsuitCourt, lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefandentName, lawsuitActionDate: $lawsuitActionDate)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if lawsuitType == .notDistributed {
                LawsuitNotDistributedView(lawsuitNumber: $lawsuitNumber, lawsuitCourt: $lawsuitCourt, lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefandentName, lawsuitActionDate: $lawsuitActionDate)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(height: 300)
        .padding()
        .onAppear {
            lawsuitTypeString = lawsuitType.rawValue
        }
        .onChange(of: lawsuitTypeString, perform: { newValue in
            if newValue == "Distribuído" {
                lawsuitType = .distributed
            } else {
                lawsuitType = .notDistributed
            }
        })
    }
}
