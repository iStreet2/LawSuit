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
//    @State var clientMock: ClientMock = ClientMock()
//    @State var lawsuit: ProcessMock = ProcessMock()
    
    //MARK: Variáveis de estado
    @State var lawsuitNumber = ""
    @State var lawsuitCourt = ""
    @State var lawsuitParentAuthorName = ""
    @State var lawsuitDefandent = ""
    @State var lawsuitActionDate = Date()
    
    //MARK: ViewModels
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context

    
    var body: some View {
        VStack(alignment: .leading){
            Text("Novo Processo")
                .bold()
                .font(.title)
            VStack(alignment: .leading) {
                SegmentedControlComponent(
                    selectedOption: $lawsuitTypeString, infos: ["Distribuído","Não Distribuído"])
                .frame(width: 150)
                .padding(.leading)
            }
            if lawsuitType == .distributed {
                LawsuitDistributedView(lawsuitNumber: $lawsuitNumber, lawsuitCourt: $lawsuitCourt, lawsuitParentAuthorName: $lawsuitParentAuthorName, lawsuitDefendant: $lawsuitDefandent, lawsuitActionDate: $lawsuitActionDate)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if lawsuitType == .notDistributed {
                LawsuitNotDistributedView(lawsuitNumber: $lawsuitNumber, lawsuitCourt: $lawsuitCourt, lawsuitParentAuthorName: $lawsuitParentAuthorName, lawsuitDefendant: $lawsuitDefandent, lawsuitActionDate: $lawsuitActionDate)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(width: 400, height: 300)
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
