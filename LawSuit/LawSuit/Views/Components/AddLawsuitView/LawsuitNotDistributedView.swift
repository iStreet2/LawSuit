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
    @State var missingInformation = false
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
			 TagViewPickerComponentV1(currentTag: $tagType)
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
			 VStack {
				 Spacer()
				 HStack {
					 Button {
						 dismiss()
					 } label: {
						 Text("Cancelar")
					 }
					 Spacer()
					 Button {
						 if areFieldsFilled() {
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
								 print("aaa")
							 }
						 } else {
							 missingInformation = true
						 }
					 } label: {
						 Text("Criar")
					 }
					 .buttonStyle(.borderedProminent)
					 .alert(isPresented: $missingInformation) {
						 Alert(title: Text("Informações Faltando"),
								 message: Text("Por favor, preencha todos os campos antes de criar um novo processo."),
								 dismissButton: .default(Text("Ok")))
					 }
				 }
				 .padding(.vertical, 5)
			 }
		 }

    }
	
    func areFieldsFilled() -> Bool {
        return !lawsuitAuthorName.isEmpty &&
        !lawsuitDefendantName.isEmpty
    }
}

#Preview {
	LawsuitNotDistributedView(lawsuitNumber: .constant("34567898765"), lawsuitCourt: .constant("fghcvnbjgyutfgh"), lawsuitAuthorName: .constant("AuTHOR NAAAME"), lawsuitDefendantName: .constant("Defendant Name Here"), lawsuitActionDate: .constant(Date.now))

		.environmentObject(DataViewModel())
}
