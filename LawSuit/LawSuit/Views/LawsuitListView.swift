//
//  LawsuitListView3.swift
//  LawSuit
//
//  Created by Giovanna Micher on 03/09/24.
//

import SwiftUI

struct LawsuitListView: View {
    
    @EnvironmentObject var dataViewModel: DataViewModel

    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    @State var createProcess = false
    @State private var hasFetchedUpdates = false  // Adicionado
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Processos")
                        .font(.title)
                        .bold()
                    Button(action: {
                        createProcess.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(Color(.gray))
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                LawsuitListViewHeaderContent(lawsuits: lawsuits)
            }

        }
//        .onAppear {
//            if !hasFetchedUpdates { //prevenir multiplas chamadas
//                fetchUpdatesForLawsuits()
//                hasFetchedUpdates = true
//            }
//        }
        .sheet(isPresented: $createProcess, content: {
            AddLawsuitView()
        })
        .toolbar {
            ToolbarItem {
                Text("")
            }
        }
    }
    
//    func fetchUpdatesForLawsuits() {
//        for lawsuit in lawsuits {
//            if lawsuit.updates == nil {
//                Task {
//                    dataViewModel.coreDataManager.lawsuitNetworkingViewModel.fetchUpdatesDataFromLawsuit(fromLawsuit: lawsuit)
//
//                    dataViewModel.coreDataManager.lawsuitManager.addUpdates(lawsuit: lawsuit, updates: dataViewModel.coreDataManager.lawsuitNetworkingViewModel.updates)
//                }
//            }
//        }
//        print("fiz o fetch na lawsuitListView")
//    }
}

#Preview {
    LawsuitListView()
}
