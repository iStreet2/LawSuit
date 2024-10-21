//
//  SettingsView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/10/24.
//

import SwiftUI
import CoreData

struct SettingsView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@EnvironmentObject var dataViewModel: DataViewModel
	@FetchRequest(sortDescriptors: []) var users: FetchedResults<User>
	
	@State var text: String = ""
	@State var isHoveringPicture: Bool = false
	@State var deleteAccountAlertIsPresented: Bool = false
	@State var didCopyEmail: Bool = false
	@State var didSaveChanges: Bool = false
	@State var didDeleteAccount: Bool = false
	
	var body: some View {
		VStack(alignment: .leading) {
			header
			
			HStack {
				imageButton // Desconsiderar o alerta aqui embaixo, apenas precisava que ficasse em outra View
					.alert(isPresented: $didDeleteAccount) {
						Alert(title: Text("Conta deletada com sucesso"), message: nil, dismissButton: .cancel(Text("Ok")))
					}
				
				VStack(alignment: .leading) {
					HStack(alignment: .bottom) {
						LabeledTextField(label: "Nome", placeholder: "Nome", textfieldText: $text)
							.frame(maxWidth: 300)
						
						if didSaveChanges {
							Image(systemName: "checkmark.circle")
								.font(.title)
								.foregroundStyle(.green)
								.padding(.bottom, 7)
						}
					}
					
					emailField
				}
				.padding(.trailing)
			}
			
			Spacer()
			
			deleteAccountButton
				.alert(isPresented: $deleteAccountAlertIsPresented) {
					Alert(title: Text("Tem certeza que deseja deletar sua conta?"),
							message: Text("Esta ação não pode ser desfeita."),
							primaryButton: .destructive(Text("Sim"), action: {
						dataViewModel.deleteUserAccount()
						text = ""
						didDeleteAccount = true
					}),
							secondaryButton: .cancel(Text("Cancelar"))
					)
				}
		}
		.frame(minWidth: 500)
		.onAppear {
			text = users.first?.userName ?? ""
		}
	}
}

#Preview {
	SettingsView()
}

extension SettingsView {
	private var header: some View {
		HStack {
			Text("Editar Perfil")
				.font(.title2)
				.bold()
			
			Spacer()
			
			cancelButton
			
			saveButton
		}
		.padding()
	}
	
	private var imageButton: some View {
		Button {
			
		} label: {
			ZStack {
				Circle() // TODO: Mudar para a foto do usuário
					.frame(width: 100, height: 100)
					.foregroundStyle(.secondary)
					.padding()
				
				
				if isHoveringPicture {
					Circle() // Esse pode deixar, já que é o filtro :thumbs_up:
						.frame(width: 100, height: 100)
						.foregroundStyle(.secondary.opacity(0.3))
						.padding()
					Image(systemName: "pencil")
						.resizable()
						.frame(width: 20, height: 20)
						.foregroundStyle(.white)
				}
			}
			.onHover { _ in
				isHoveringPicture.toggle()
			}
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	private var emailField: some View {
		HStack {
			Text("E-Mail")
				.foregroundStyle(.secondary)
			
			Button {
				let pasteboard = NSPasteboard.general
				pasteboard.clearContents()
				pasteboard.setString(users.first?.email ?? "seu email aqui", forType: .string)
				
				withAnimation(.bouncy(duration: 0.5)) {
					didCopyEmail = true
				}
				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
					withAnimation(.easeOut(duration: 1)) {
						didCopyEmail = false
					}
				}
				
			} label: {
				HStack {
					Text(users.first?.email ?? "seu email aqui")
					Image(systemName: didCopyEmail ? "checkmark.circle" : "rectangle.portrait.on.rectangle.portrait")
						.foregroundStyle(.secondary)
				}
			}
			.buttonStyle(PlainButtonStyle())
			
		}
	}
	
	private var cancelButton: some View { // MARK: O que que esse botão deve fazer? kkkkkkk voltar ao estágio inicial da view/sair né?
		Button {
			dismiss()
			text = users.first?.userName ?? ""
		} label: {
			Text("Cancelar")
				.foregroundStyle(.secondary)
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	private var saveButton: some View {
		Button {
			users.first?.userName = text
			do {
				try dataViewModel.context.save()
				
				withAnimation(.bouncy(duration: 0.5)) {
					didSaveChanges = true
				}
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
					withAnimation(.easeOut(duration: 1)) {
						didSaveChanges = false
					}
				}
				
			} catch {
				print("Couldn't save changes: \(error)")
			}
		} label: {
			Text("Salvar")
				.foregroundStyle(.wine)
				.underline()
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	private var deleteAccountButton: some View {
		HStack {
			Spacer()
			Button(role: .destructive) {
				// TODO: Apagar conta rs
				// Apagar no CoreData
				// Apagar o Sign-In with Apple também?
				deleteAccountAlertIsPresented = true
			} label: {
				Text("Apagar Conta")
			}
			.buttonStyle(.borderedProminent)
			.tint(.red)
		}
		.padding()
	}
}
