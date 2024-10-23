//
//  AppDelegate.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 16/09/24.
//

import Foundation
import SwiftUI
import CoreSpotlight
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any NSUserActivityRestoring]) -> Void) -> Bool {
        
        if userActivity.activityType == CSSearchableItemActionType {
            print("Application Summoned via Spotlight")
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                print(uniqueIdentifier)
                NotificationCenter.default.post(name: NSNotification.Name("HandleSpotlightSearch"), object: uniqueIdentifier)
            }
        }
        return true
        
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Acessa o menu principal
        if let mainMenu = NSApplication.shared.mainMenu {
            // Lista de títulos de menus que queremos remover
            let menusToRemove = ["File", "Edit"]
            
            // Filtra os menus que queremos remover
            for menuTitle in menusToRemove {
                if let menuItem = mainMenu.items.first(where: { $0.title == menuTitle }) {
                    mainMenu.removeItem(menuItem)
                }
            }
        }
    }
    
//    func applicationDidBecomeActive(_ notification: Notification) {
//        setupMenuBar()
//    }
    
//    private func setupMenuBar() {
//        let mainMenu = NSMenu(title: "Arqion")
//        
//        // Cria o menu "App" com as opções padrão (Sobre, Sair, etc.)
//        let appMenuItem = NSMenuItem()
//        let appMenu = NSMenu(title: "Arqion")
//        
//        appMenu.addItem(withTitle: "Sobre Arqion", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
//        appMenu.addItem(NSMenuItem.separator())
//        appMenu.addItem(withTitle: "Sair de Arqion", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
//        
//        appMenuItem.submenu = appMenu
//        mainMenu.addItem(appMenuItem)
//        
//        // Cria o menu "Arquivo" com as ações customizadas
//        let arquivoMenuItem = NSMenuItem()
//        let arquivoMenu = NSMenu(title: "Arquivo")
//        
//        arquivoMenu.addItem(criarClienteItem())
//        arquivoMenu.addItem(criarProcessoItem())
//        arquivoMenu.addItem(criarPastaItem())
//        arquivoMenu.addItem(importarDocumentoItem())
//        arquivoMenu.addItem(NSMenuItem.separator()) // Separador entre seções de ações
//        arquivoMenu.addItem(pesquisarItem())
//        arquivoMenu.addItem(enviarEmailItem())
//        
//        arquivoMenuItem.submenu = arquivoMenu
//        mainMenu.addItem(arquivoMenuItem)
//        
//        // Cria o menu "Visualizar" com ações de visualização
//        let visualizarMenuItem = NSMenuItem()
//        let visualizarMenu = NSMenu(title: "Visualizar")
//        
//        visualizarMenu.addItem(visualizarAbaClienteItem())
//        visualizarMenu.addItem(visualizarAbaProcessosItem())
//        visualizarMenu.addItem(NSMenuItem.separator()) // Separador
//        visualizarMenu.addItem(ocultarMostrarBarraClientesItem())
//        visualizarMenu.addItem(verProcessosClienteItem())
//        visualizarMenu.addItem(verDocumentosClienteItem())
//        visualizarMenu.addItem(NSMenuItem.separator()) // Separador
//        visualizarMenu.addItem(gridViewItem())
//        visualizarMenu.addItem(listViewItem())
//        
//        visualizarMenuItem.submenu = visualizarMenu
//        mainMenu.addItem(visualizarMenuItem)
//        
//        // Define o menu principal da aplicação
//        NSApplication.shared.mainMenu = mainMenu
//    }
//    func criarClienteItem() -> NSMenuItem {
//        return NSMenuItem(title: "Criar Cliente", action: #selector(newClient), keyEquivalent: "n")
//    }
//    
//    func criarProcessoItem() -> NSMenuItem {
//        let addLawsuitItem = NSMenuItem(title: "Criar Processo", action: #selector(newLawsuit), keyEquivalent: "n")
//        addLawsuitItem.keyEquivalentModifierMask = [.command,.shift]
//        return addLawsuitItem
//    }
//    
//    func criarPastaItem() -> NSMenuItem {
//        let newFolderItem = NSMenuItem(title: "Criar Pasta", action: #selector(newFolder), keyEquivalent: "n")
//        newFolderItem.keyEquivalentModifierMask = [.command,.option]
//        return newFolderItem
//    }
//    
//    func importarDocumentoItem() -> NSMenuItem {
//        let importDocumentItem = NSMenuItem(title: "Importar Documento", action: #selector(newFile), keyEquivalent: "i")
//        importDocumentItem.keyEquivalentModifierMask = [.command]
//        // Aqui, você pode adicionar uma lógica para habilitar/desabilitar o item conforme necessário
//        return importDocumentItem
//    }
//    
//    func pesquisarItem() -> NSMenuItem {
//        let searchItem = NSMenuItem(title: "Pesquisar", action: #selector(search), keyEquivalent: " ")
//        searchItem.keyEquivalentModifierMask = [.command, .option]
//        return searchItem
//    }
//    
//    func enviarEmailItem() -> NSMenuItem {
//        let sendEmailItem = NSMenuItem(title: "Enviar E-mail", action: #selector(sendEmail), keyEquivalent: "e")
//        sendEmailItem.keyEquivalentModifierMask = [.command, .shift]
//        // Aqui, você pode adicionar uma lógica para habilitar/desabilitar o item conforme necessário
//        return sendEmailItem
//    }
//    
//    func visualizarAbaClienteItem() -> NSMenuItem {
//        let clientTab = NSMenuItem(title: "Aba Cliente", action: #selector(goToClients), keyEquivalent: "1")
//        clientTab.keyEquivalentModifierMask = [.control]
//        return clientTab
//    }
//    
//    func visualizarAbaProcessosItem() -> NSMenuItem {
//        let lawsuitTab = NSMenuItem(title: "Aba Cliente", action: #selector(goToLawsuits), keyEquivalent: "2")
//        lawsuitTab.keyEquivalentModifierMask = [.control]
//        return lawsuitTab
//    }
//    
//    func ocultarMostrarBarraClientesItem() -> NSMenuItem {
//        let showClientsSideBarItem = NSMenuItem(title: "Ocultar/Mostrar Barra de Clientes", action: #selector(showClientsSideBar), keyEquivalent: "h")
//        showClientsSideBarItem.keyEquivalentModifierMask = [.command, .option]
//        return showClientsSideBarItem
//    }
//    
//    func verProcessosClienteItem() -> NSMenuItem {
//        return NSMenuItem(title: "Ver Processos do Cliente", action: #selector(showClientLawsuits), keyEquivalent: "1")
//    }
//    
//    func verDocumentosClienteItem() -> NSMenuItem {
//        return NSMenuItem(title: "Ver Documentos do Cliente", action: #selector(showClientDocuments), keyEquivalent: "2")
//    }
//    
//    func gridViewItem() -> NSMenuItem {
//        let gridViewItem = NSMenuItem(title: "Visualização em Grid", action: #selector(toggleGridView), keyEquivalent: "1")
//        gridViewItem.keyEquivalentModifierMask = [.command, .shift]
//        return gridViewItem
//    }
//    
//    func listViewItem() -> NSMenuItem {
//        let listViewItem = NSMenuItem(title: "Visualização em Lista", action: #selector(toggleGridView), keyEquivalent: "2")
//        listViewItem.keyEquivalentModifierMask = [.command, .shift]
//        return listViewItem
//    }
//    
//    @objc func newClient() {
//        // Ação customizada para "New"
//        ShortCutsViewModel.shared.addClient = true
//    }
//    
//    @objc func newLawsuit() {
//        // Ação customizada para "New"
//        ShortCutsViewModel.shared.addLawsuit = true
//    }
//    
//    @objc func newFolder() {
//        ShortCutsViewModel.shared.newFolder = true
//    }
//    
//    @objc func newFile() {
//        ShortCutsViewModel.shared.newFile = true
//    }
//    
//    @objc func search() {
//        ShortCutsViewModel.shared.searth = true
//    }
//    
//    @objc func sendEmail() {
//        ShortCutsViewModel.shared.sendEmail = true
//    }
//    
//    @objc func goToClients() {
//        ShortCutsViewModel.shared.goToClients = true
//    }
//    
//    @objc func goToLawsuits() {
//        ShortCutsViewModel.shared.goToLawsuits = true
//    }
//    
//    @objc func showClientsSideBar() {
//        ShortCutsViewModel.shared.showClientsSideBar = true
//    }
//    
//    @objc func showClientLawsuits() {
//        ShortCutsViewModel.shared.showClientLawsuits = true
//    }
//    
//    @objc func showClientDocuments() {
//        ShortCutsViewModel.shared.showClientDocuments = true
//    }
//    
//    @objc func toggleGridView() {
//        ShortCutsViewModel.shared.isShowingGridView.toggle()
//    }
    
}
