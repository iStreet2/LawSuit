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
    @State var attributedAuthor = false
    @Binding var lawsuitNumber: String
    @Binding var lawsuitCourt: String
    @Binding var lawsuitAuthorName: String
    @Binding var lawsuitDefendantName: String
    @Binding var lawsuitActionDate: Date
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
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
                    EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Autor", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "author", attributedAuthor: $attributedAuthor, attributedDefendant: .constant(false))
                    HStack {
                        Text(lawsuitAuthorName)
                        if attributedAuthor {
                            Button {
                                //Retirar esse cliente e retirar o estado de autor selecionado
                                attributedAuthor = false
                                lawsuitAuthorName = ""
                            } label: {
                                Image(systemName: "minus")
                            }
                            .padding(.leading,2)
                        }
                    }
                }
                LabeledTextField(label: "Réu", placeholder: "Adicionar réu ", textfieldText: $lawsuitDefendantName)
            }
        }
        Spacer()
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
                    fetchRequest.predicate = NSPredicate(format: "name == %@", lawsuitAuthorName)
                    do {
                        let fetchedClients = try context.fetch(fetchRequest)
                        if let author = fetchedClients.first {
                            let category = TagTypeString.string(from: tagType)
                            let lawyer = lawyers[0]
                            let defendant = dataViewModel.coreDataManager.entityManager.createAndReturnEntity(name: lawsuitDefendantName)
                            dataViewModel.coreDataManager.lawsuitManager.createLawsuitNonDistribuited(name: "\(lawsuitAuthorName) X \(lawsuitDefendantName)", number: lawsuitNumber, category: category, lawyer: lawyer, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate)
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
            .frame(minWidth: 200, minHeight: 250)
        })
    }
}

