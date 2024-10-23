//
//  LawsuitListView3.swift
//  LawSuit
//
//  Created by Giovanna Micher on 03/09/24.
//

import SwiftUI

struct LawsuitListView: View {
    
    //MARK: Variáveis de estado
    @State private var hasFetchedUpdates = false  // Adicionado
    @State var addLawsuit = false
    @State var selectedOption = "Distribuído"
    @State var noInternetAlert: Bool = false
    @Binding var addClient: Bool
    var segmentedControlInfos = ["Distribuído", "Não distribuído"]
    var isLoading: Bool {
        lawsuits.contains { $0.isLoading }
    }
    
    //MARK: ViewModels
    @EnvironmentObject var networkMonitorViewModel: NetworkMonitorViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Processos")
                            .font(.title)
                            .bold()
                        Button(action: {
                            addLawsuit.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundStyle(Color(.gray))
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        if selectedOption == "Distribuído" {
                            Button(action: {
                                
                                if networkMonitorViewModel.isConnected == false {
                                    noInternetAlert.toggle()
                                } else {
                                    
                                    for lawsuit in lawsuits {
                                        
                                        if lawsuit.isDistributed {
                                            dataViewModel.coreDataManager.lawsuitNetworkingViewModel.fetchAndSaveUpdatesFromAPI(fromLawsuit: lawsuit)
                                        }
                                        
                                    }
                                }
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                            })
                            .disabled(isLoading)
                        }
                    }
                    
                    CustomSegmentedControl(selectedOption: $selectedOption, infos: segmentedControlInfos)
                        .padding(.vertical, 10)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)

                if lawsuits.count == 0 {
                    LawsuitsEmptyState(addClient: $addClient, addLawsuit: $addLawsuit)
                } else {
                    LawsuitListViewHeaderContent(lawsuits: lawsuits, lawsuitTypeString: $selectedOption)
                }
            }
  
        }
        .sheet(isPresented: $noInternetAlert, content: {
            NoInternetView()
        })
        .sheet(isPresented: $addLawsuit, content: {
            AddLawsuitView()
        })
        .toolbar {
            ToolbarItem {
                Text("")
            }
        }
    }
}
