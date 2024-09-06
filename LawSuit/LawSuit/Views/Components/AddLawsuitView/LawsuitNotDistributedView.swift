//
//  ProcessNotDistributedView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 27/08/24.
//

import SwiftUI

struct LawsuitNotDistributedView: View {
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    
    //MARK: Variáveis de estado
    @State var selectTag = false
    @State var tagType: TagType = .civel
    @Binding var lawsuitNumber: String
    @Binding var lawsuitCourt: String
    @Binding var lawsuitParentAuthorName: String
    @Binding var lawsuitDefendant: String
    @Binding var lawsuitActionDate: Date
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawyers: FetchedResults<Lawyer>
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Área")
                .bold()
            TagViewComponent(tagType: tagType)
                .onTapGesture {
                    selectTag.toggle()
                }
            HStack(spacing: 70) {
                VStack(alignment: .leading) {
                    EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Autor", lawsuitParentAuthorName: $lawsuitParentAuthorName, lawsuitDefendant: $lawsuitDefendant, defendantOrClient: "client", attributedClient: .constant(true), attributedDefendant: .constant(false))
                    Text(lawsuitParentAuthorName)
                }
                LabeledTextField(label: "Réu", placeholder: "Adicionar réu ", textfieldText: $lawsuitDefendant)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancelar")
                    }
                    Button {
                        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
                        fetchRequest.predicate = NSPredicate(format: "name == %@", lawsuitParentAuthorName)
                        do {
                            let fetchedClients = try context.fetch(fetchRequest)
                            if let client = fetchedClients.first {
                                let category = TagTypeString.string(from: tagType)
                                //MARK: Advogado temporário
                                let lawyer = lawyers[0]
                                coreDataViewModel.lawsuitManager.createLawsuitNonDistribuited(name: "\(lawsuitParentAuthorName) X \(lawsuitDefendant)", number: lawsuitNumber, category: category, lawyer: lawyer, defendant: lawsuitDefendant, author: client, actionDate: lawsuitActionDate)
                                dismiss()
                            } else {
                                print("Cliente não encontrado")
                            }
                        } catch {
                            print("Erro ao buscar cliente: \(error.localizedDescription)")
                        }
                    } label: {
                        Text("Criar")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .border(.red)
            .padding(.vertical, 5)
        }
        .sheet(isPresented: $selectTag, content: {
            VStack {
                Spacer()
                TagViewPickerComponentV1(currentTag: $tagType)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        selectTag.toggle()
                    }, label: {
                        Text("Salvar")
                    })
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
        })
    }
}


