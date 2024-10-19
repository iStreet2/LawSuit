//
//  LawsuitListView3.swift
//  LawSuit
//
//  Created by Giovanna Micher on 03/09/24.
//

import SwiftUI

struct LawsuitListView: View {
    
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    @State var createProcess = false
    @State private var hasFetchedUpdates = false  // Adicionado
    @EnvironmentObject var dataViewModel: DataViewModel
    var segmentedControlInfos = ["Distribuído", "Não distribuído"]
    @State var selectedOption = "Distribuído"
    
    var isLoading: Bool {
        lawsuits.contains { $0.isLoading }
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
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
                        
                        Spacer()
                        Button(action: {
                            for lawsuit in lawsuits {
                                
                                if lawsuit.isDistributed {
                                    dataViewModel.coreDataManager.lawsuitNetworkingViewModel.fetchAndSaveUpdatesFromAPI(fromLawsuit: lawsuit)
                                }
                                
                            }
                        }, label: {
                            Image(systemName: "arrow.clockwise")
                        })
                        .disabled(isLoading)
                    }
                    
                    CustomSegmentedControl(selectedOption: $selectedOption, infos: segmentedControlInfos)
                        .padding(.vertical, 10)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                LawsuitListViewHeaderContent(lawsuits: lawsuits, lawsuitTypeString: $selectedOption)
            }
  
        }
        .sheet(isPresented: $createProcess, content: {
            AddLawsuitView()
        })
        .toolbar {
            ToolbarItem {
                Text("")
            }
        }
    }
}
