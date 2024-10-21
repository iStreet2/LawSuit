//
//  LawsuitListView3.swift
//  LawSuit
//
//  Created by Giovanna Micher on 03/09/24.
//

import SwiftUI

struct LawsuitListView: View {
    
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    @State var addLawsuit = false
    @State private var hasFetchedUpdates = false  // Adicionado
    
    //MARK: ViewModels
    @EnvironmentObject var dataViewModel: DataViewModel
    @ObservedObject var shortCutsViewModel = ShortCutsViewModel.shared
    
    var isLoading: Bool {
        lawsuits.contains { $0.isLoading }
    }
    
    var body: some View {
        
        NavigationStack {
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
                    Button(action: {
                        for lawsuit in lawsuits {
                            dataViewModel.coreDataManager.lawsuitNetworkingViewModel.fetchAndSaveUpdatesFromAPI(fromLawsuit: lawsuit)
                        }
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                    .disabled(isLoading)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                if lawsuits.count == 0 {
                    LawsuitsEmptyState(addLawsuit: $addLawsuit)
                } else {
                    LawsuitListViewHeaderContent(lawsuits: lawsuits)
                }
            }
        }
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
