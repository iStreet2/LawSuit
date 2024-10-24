//
//  SubscriptionPlanView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 23/10/24.
//

import SwiftUI

struct SubscriptionPlanView: View {
	
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var planManager: PlanManager
	@EnvironmentObject var navigationViewModel: NavigationViewModel
	@EnvironmentObject var dataViewModel: DataViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Solo")
				.font(.title2)
				.foregroundStyle(.wine)
				.bold()
				.padding(.horizontal)
			
			Text("A experiência completa do Arqion.")
				.foregroundStyle(.secondary)
				.padding(.horizontal)
			
			HStack(alignment: .bottom, spacing: 0) {
				Text("R$49,90")
					.font(.largeTitle)
					.bold()
					
				Text("/mês")
					.foregroundStyle(.secondary)
			}
			.padding(.horizontal)
			.padding(.top, 1)
			
			VStack(alignment: .leading, spacing: 11) {
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("Clientes cadastrados ")
						Text("ilimitados").bold()
					}
					Spacer()
				}
				
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("Processos ")
						Text("ilimitados").bold()
					}
				}
				
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("Processos monitorados ")
						Text("ilimitados").bold()
					}
				}
				
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("Armazenamento: ")
						Text("Local").bold()
					}
				}
				
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("Integração com ")
						Text("Contatos ").bold()
						Text("e ")
						Text("Spotlight").bold()
					}
				}
				
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("Notas ").bold()
						Text("em processos")
					}
				}
				
				HStack {
					Image(systemName: "checkmark")
						.foregroundStyle(.wine).bold()
					HStack(spacing: 0) {
						Text("Template ").bold()
						Text("de solicitação de documentos")
					}
				}
			}
			.padding()
			.background(.secondary.opacity(0.1))
	
			HStack {
				Spacer()
				
				VStack {
					if planManager.isNotSoloPlan() {
						Button {
							planManager.updatePlan(to: .solo, for: dataViewModel.context)
						} label: {
							Text(planManager.isFreePlan() ? "Aprimorar para o plano Solo" : "Continuar com o plano Solo")
								.tint(.black)
						}
						.padding(.top, 8)
						.buttonStyle(.borderedProminent)
						.tint(.black)
					} else {
						Text("Seu plano atual")
							.bold()
							.padding(.top, 12)
					}
					
					if navigationViewModel.selectedView != .plans {
						Button {
							dismiss()
						} label: {
							Text("Continuar Free")
						}
					}
				}
				
				Spacer()
			}
			
		}
		.padding(.vertical)
		.background(.white)
		.frame(width: 307)
		.fixedSize(horizontal: true, vertical: true)
	}
}

#Preview {
	SubscriptionPlanView()
}
