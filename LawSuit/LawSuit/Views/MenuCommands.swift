//
//  Commands.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 22/10/24.
//

import SwiftUI

struct MenuCommands: Commands {
    
    @State private var isClientSelected = false // Simulação do estado do cliente selecionado
    
    @ObservedObject var shortCutsViewModel: ShortCutsViewModel
    
    var body: some Commands {
        // Menu "Arquivo"
        CommandMenu("Arquivo") {
            Button("Criar Cliente") {
                shortCutsViewModel.addClient.toggle()
            }
            .keyboardShortcut("n", modifiers: .command)

            Button("Criar Processo") {
                // Ação para criar processo
            }
            .keyboardShortcut("n", modifiers: [.command, .shift])

            Button("Criar Pasta") {
                // Ação para criar pasta (só habilitada quando um cliente está selecionado)
            }
            .keyboardShortcut("n", modifiers: [.command, .option])
            .disabled(!isClientSelected) // Desabilitar se nenhum cliente estiver selecionado

            Button("Importar Documento") {
                // Ação para importar documento (só habilitada quando um cliente está selecionado)
            }
            .keyboardShortcut("i", modifiers: .command)
            .disabled(!isClientSelected) // Desabilitar se nenhum cliente estiver selecionado

            Button("Pesquisar") {
                // Ação para pesquisa
            }
            .keyboardShortcut(.space, modifiers: [.command, .option])

            Button("Enviar E-mail") {
                // Ação para enviar e-mail (só habilitada quando um cliente está selecionado)
            }
            .keyboardShortcut("e", modifiers: [.command, .shift])
            .disabled(!isClientSelected) // Desabilitar se nenhum cliente estiver selecionado
        }

        // Menu "Visualizar"
        CommandMenu("Visualizar") {
            Button("Aba Cliente") {
                // Ação para mudar para a aba de clientes
            }
            .keyboardShortcut("1", modifiers: .control)

            Button("Aba Processos") {
                // Ação para mudar para a aba de processos
            }
            .keyboardShortcut("2", modifiers: .control)

            Button("Ocultar/Mostrar Barra de Clientes") {
                // Ação para ocultar ou mostrar a barra lateral de clientes
            }
            .keyboardShortcut("h", modifiers: [.command, .option])

            Button("Ver Processos do Cliente") {
                // Ação para ver processos do cliente
            }
            .keyboardShortcut("1", modifiers: .command)

            Button("Ver Documentos do Cliente") {
                // Ação para ver documentos do cliente
            }
            .keyboardShortcut("2", modifiers: .command)

            Button("Visualização em Grid") {
                // Ação para alterar para visualização em grid
            }
            .keyboardShortcut("1", modifiers: [.command, .shift])

            Button("Visualização em Lista") {
                // Ação para alterar para visualização em lista
            }
            .keyboardShortcut("2", modifiers: [.command, .shift])
        }
    }
}
