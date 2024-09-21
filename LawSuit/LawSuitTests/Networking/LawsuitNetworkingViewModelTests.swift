//
//  LawsuitNetworkingViewModelTests.swift
//  LawSuitTests
//
//  Created by Giovanna Micher on 20/09/24.
//

import XCTest
@testable import LawSuit

final class LawsuitNetworkingViewModelTests: XCTestCase {
    
    //MARK: - Attributes
    var sut: LawsuitNetworkingViewModel!
    var coreDataStack: CoreDataStackTests!
    var lawsuitManager: LawsuitManager!
    
    override func setUpWithError() throws {
        coreDataStack = CoreDataStackTests()
        lawsuitManager = LawsuitManager(context: coreDataStack.context)
        sut = LawsuitNetworkingViewModel(lawsuitService: StubLawsuitNetworkingService(coreDataStack: coreDataStack), lawsuitManager: lawsuitManager)
    }
    
    override func tearDownWithError() throws {
        // Destrói as instâncias após os testes
        coreDataStack = nil
        lawsuitManager = nil
        sut = nil
    }
    
    func createMockLawsuitAndSaveIntoCoreData() -> Lawsuit{
        
        let lawsuit = Lawsuit(context: coreDataStack.context)
        lawsuit.number = "11442015920238260100"
        lawsuit.category = ""
        lawsuit.name = "Usucapião"
        do {
            try coreDataStack.context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        return lawsuit
    }
    
    //MARK: - Unit Tests
    func testFetchLawsuitUpdatesDataWithSuccess() async throws {
        
        sut = LawsuitNetworkingViewModel(lawsuitService: StubLawsuitNetworkingService(coreDataStack: coreDataStack), lawsuitManager: lawsuitManager)
        
        let lawsuit = createMockLawsuitAndSaveIntoCoreData()
        
        sut.fetchAndSaveUpdatesFromAPI(fromLawsuit: lawsuit)
    
        //Espera um tempo para a execução do código assíncrono
        try await Task.sleep(nanoseconds: 1_000_000_000)

        if let updatesSet = lawsuit.updates as? Set<Update> {
            let updatesArray = Array(updatesSet).sorted { $0.date ?? Date() < $1.date ?? Date() } // data do menor para o maior
            XCTAssertEqual("Expedição de documento", updatesArray[0].name) //menor data
            XCTAssertEqual("Petição", updatesArray[1].name) //maior data
        }
        //Verificar número de elementos retornados da "API"
        XCTAssertEqual(2, lawsuit.updates?.count)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

//imitador
class StubLawsuitNetworkingService: LawsuitNetworkingServiceProtocol {
    
    var coreDataStack: CoreDataStackTests
    
    init(coreDataStack: CoreDataStackTests) {
        self.coreDataStack = coreDataStack
    }
    
    func createMockUpdates() -> [Update] {
        let dateString1 = "2024-06-09T12:00:22.000Z" // date: 09/06/2024 00:22 -> menor data
        let dateString2 = "2024-07-30T11:06:12.000Z" // date: 30/07/2024 06:12
        
        let update = Update(context: coreDataStack.context)
        update.name = "Expedição de documento"
        update.date = dateString1.convertToDate()
        
        let update2 = Update(context: coreDataStack.context)
        update2.name = "Petição"
        update.date = dateString2.convertToDate()
        
        let updates = [update, update2]
        return updates
    }
    
    func fetchLawsuitUpdatesData(fromLawsuit lawsuit: Lawsuit) async throws -> Result<[Update], Error> {
        let updates = createMockUpdates()
        return .success(updates)
    }
}
