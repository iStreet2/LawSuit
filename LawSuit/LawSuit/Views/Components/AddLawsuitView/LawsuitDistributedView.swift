//
//  ProcessDistributedView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 27/08/24.
//

import SwiftUI

struct LawsuitDistributedView: View {
    
    //MARK: Variáveis de Ambiente
    @Environment(\.dismiss) var dismiss
    
    @State var textInput = ""
    @State var tagType: TagType = .civel
    @State var selectTag = false
    
    //MARK: Variáveis de estado
    @Binding var lawsuitNumber: String
    @Binding var lawsuitCourt: String
    @Binding var lawsuitAuthorName: String
    @Binding var lawsuitDefendantName: String
    @Binding var lawsuitActionDate: Date
    
    @State var attributedAuthor = false
    @State var attributedDefendant = false
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawyers: FetchedResults<Lawyer>
    
    var body: some View {
        VStack{
            LabeledTextField(label: "Nº do processo", placeholder: "Nº do processo", textfieldText: $lawsuitNumber)
        }
        VStack{
            LabeledTextField(label: "Vara", placeholder: "Vara", textfieldText: $lawsuitCourt)
        }
        HStack(alignment: .top){
            VStack(alignment: .leading){
                //MARK: Caso usuário não selecionou nada ainda
                if !attributedDefendant {
                    EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Autor", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "author", attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                }
                //MARK: Caso usuário atribuir cliente para o réu
                if attributedDefendant {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Autor")
                                .bold()
                        }
                    }
                    TextField("", text: $lawsuitAuthorName)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                }
                HStack {
                    //MARK: Caso o usuário tenha adicionado um cliente no autor
                    if attributedAuthor {
                        Text("\(lawsuitAuthorName)")
                        Button {
                            withAnimation {
                                //Retirar esse cliente e retirar o estado de autor selecionado
                                attributedAuthor = false
                                lawsuitAuthorName = ""
                            }
                        } label: {
                            Image(systemName: "minus")
                        }
                        .padding(.leading, 5)
                    }
                }
                .frame(width: 200, alignment: .leading)
                
                Text("Área")
                    .padding(.top)
                    .bold()
                TagViewComponent(tagType: tagType)
                    .onTapGesture {
                        selectTag.toggle()
                    }
            }
            Spacer()
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    //MARK: Se o usuário não selecionou nada
                    if !attributedAuthor {
                        EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Réu", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "defendant", attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                    }
                    //MARK: Caso o usuário tenha adicionado um cliente no autor
                    if attributedAuthor {
                        VStack(alignment: .leading){
                            HStack{
                                Text("Réu")
                                    .bold()
                            }
                        }
                        TextField("", text: $lawsuitDefendantName)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                    }
                    HStack {
                        //MARK: Caso o usuário tenha adicionado um cliente no réu
                        if attributedDefendant {
                            Text(lawsuitDefendantName)
                            Button {
                                withAnimation {
                                    //Retirar esse cliente e retirar o estado de autor selecionado
                                    attributedDefendant = false
                                    lawsuitDefendantName = ""
                                }
                            } label: {
                                Image(systemName: "minus")
                            }
                            .padding(.leading,2)
                        }
                    }
                    .frame(width: 200, alignment: .leading)
                    
                }
                LabeledDateField(selectedDate: $lawsuitActionDate, label: "Data da distribuição")
                    .padding(.top)
            }
        }
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Cancelar")
            }
            Button {
                
                //MARK: Se o cliente foi atribuido ao autor
                if attributedAuthor {
                    if let author = dataViewModel.coreDataManager.clientManager.fetchFromName(name: lawsuitAuthorName) {
                        let category = TagTypeString.string(from: tagType)
                        let lawyer = lawyers[0]
                        let defendant = dataViewModel.coreDataManager.entityManager.createAndReturnEntity(name: lawsuitDefendantName)
                        dataViewModel.coreDataManager.lawsuitManager.createLawsuit(name: "\(lawsuitAuthorName) X \(lawsuitDefendantName)", number: lawsuitNumber, court: lawsuitCourt, category: category, lawyer: lawyer, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate)
                        dismiss()
                    } else {
                        print("Client not found")
                    }
                }
                
                //MARK: Se o cliente foi atribuido ao réu
                else if attributedDefendant {
                    if let defendant = dataViewModel.coreDataManager.clientManager.fetchFromName(name: lawsuitDefendantName) {
                        let category = TagTypeString.string(from: tagType)
                        let lawyer = lawyers[0]
                        let author = dataViewModel.coreDataManager.entityManager.createAndReturnEntity(name: lawsuitAuthorName)
                        dataViewModel.coreDataManager.lawsuitManager.createLawsuit(name: "\(lawsuitAuthorName) X \(lawsuitDefendantName)", number: lawsuitNumber, court: lawsuitCourt, category: category, lawyer: lawyer, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate)
                        dismiss()
                    } else {
                        print("Client not found")
                    }
                }
            } label: {
                Text("Criar")
            }
            .buttonStyle(.borderedProminent)
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
