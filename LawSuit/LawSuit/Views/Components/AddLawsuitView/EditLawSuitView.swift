//
//  EditLawSuitView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 30/08/24.
//

import SwiftUI

struct EditLawSuitView: View {
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    
    
    //MARK: Variáveis de estado
    @State var lawsuitNumber = ""
    @State var lawsuitCourt = ""
    @State var lawsuitParentAuthorName = ""
    @State var lawsuitDefendant = ""
    @State var lawsuitActionDate = Date()
    @State var selectTag = false
    @State var tagType: TagType = .trabalhista
    @ObservedObject var lawsuit: Lawsuit
    @Binding var deleted: Bool
    @State var attributedClient = false
    @State var attributedDefendant = false
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            LabeledTextField(label: "Nº do Processo", placeholder: "sei la", textfieldText: $lawsuitNumber)
            LabeledTextField(label: "Vara", placeholder: "sei la", textfieldText: $lawsuitCourt)
            HStack(alignment: .top, spacing: 70) {
                VStack(alignment: .leading) {
                    EditLawsuitAuthorComponent(button: "Alterar Cliente", label: "Autor", lawsuitParentAuthorName: $lawsuitParentAuthorName, lawsuitDefendant: $lawsuitDefendant, defendantOrClient: "client", attributedClient: $attributedClient, attributedDefendant: $attributedDefendant)
                        .disabled(attributedDefendant)
                    TextField("", text: $lawsuitParentAuthorName)
                        .onChange(of: lawsuitParentAuthorName) { change in
                            //Se o valor do textField mudar para vazio, a lógica de proibir a seleção em algum reseta
                            if lawsuitParentAuthorName == "" {
                                attributedClient = false
                                attributedDefendant = false
                            }
                        }
                    Text("Área")
                        .bold()
                    TagViewComponent(tagType: tagType)
                        .onTapGesture {
                            selectTag.toggle()
                        }
                    Spacer()
                    Button(action: {
                        coreDataViewModel.lawsuitManager.deleteLawsuit(lawsuit: lawsuit)
                        deleted.toggle()
                        dismiss()
                    }, label: {
                        Text("Apagar processo")
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                Spacer()
                VStack(alignment: .leading) {
                    EditLawsuitAuthorComponent(button: "Atribuir Cliente", label: "Réu", lawsuitParentAuthorName: $lawsuitParentAuthorName, lawsuitDefendant: $lawsuitDefendant, defendantOrClient: "defendant", attributedClient: $attributedClient, attributedDefendant: $attributedDefendant)
                        .disabled(attributedClient)
                    TextField("", text: $lawsuitDefendant)
                        .onChange(of: lawsuitDefendant) { change in
                            //Se o valor do textField mudar para vazio, a logica de proibir a seleção em algum reseta
                            if lawsuitDefendant == "" {
                                attributedClient = false
                                attributedDefendant = false
                            }
                        }
                    LabeledDateField(selectedDate: $lawsuitActionDate, label: "Data da distribuição")
                    HStack(spacing: 10) {
                        Spacer()
                        Button(action: {
                            //resetar os valores
                            dismiss()
                        }, label: {
                            Text("Cancelar")
                        })
                        Button(action: {
                            let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
                            fetchRequest.predicate = NSPredicate(format: "name == %@", lawsuitParentAuthorName)
                            do {
                                let fetchedClients = try context.fetch(fetchRequest)
                                if let client = fetchedClients.first {
                                    let category = TagTypeString.string(from: tagType)
                                    coreDataViewModel.lawsuitManager.editLawSuit(lawsuit: lawsuit, number: lawsuitNumber, category: category, defendant: lawsuitDefendant, author: client, actionDate: lawsuitActionDate)
                                    dismiss()
                                } else {
                                    print("Cliente não encontrado")
                                }
                            } catch {
                                print("Erro ao buscar cliente: \(error.localizedDescription)")
                            }
                        }, label: {
                            Text("Salvar")
                        })
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top)
                }
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
        .onAppear {
            lawsuitNumber = lawsuit.number ?? "Sem número"
            lawsuitCourt = lawsuit.court ?? ""
            lawsuitParentAuthorName = lawsuit.parentAuthor?.name ?? ""
            lawsuitDefendant = lawsuit.defendant ?? ""
            lawsuitActionDate = lawsuit.actionDate ?? Date()
            tagType = TagType(s: lawsuit.category ?? "sei la")!
        }
        .padding()
    }
    
}

