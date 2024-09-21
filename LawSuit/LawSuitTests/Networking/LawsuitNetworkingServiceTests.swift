//
//  LawsuitNetworkingServiceTests.swift
//  LawSuitTests
//
//  Created by Giovanna Micher on 17/09/24.
//

import XCTest
@testable import LawSuit

final class LawsuitNetworkingServiceTests: XCTestCase {
    
    //MARK: - Attributes
    var sut: LawsuitNetworkingService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension LawsuitNetworkingServiceTests {
    func getMock() -> String { //usa """ para strings com mais de uma linha
        return """
        {
            "took": 39,
            "timed_out": false,
            "_shards": {
                "total": 20,
                "successful": 20,
                "skipped": 0,
                "failed": 0
            },
            "hits": {
                "total": {
                    "value": 1,
                    "relation": "eq"
                },
                "max_score": 14.7042675,
                "hits": [
                    {
                        "_index": "api_publica_tjsp",
                        "_id": "TJSP_G1_10535655720248260053",
                        "_score": 14.7042675,
                        "_source": {
                            "numeroProcesso": "10535655720248260053",
                            "classe": {
                                "codigo": 120,
                                "nome": "Mandado de Segurança Cível"
                            },
                            "sistema": {
                                "codigo": -1,
                                "nome": "Inválido"
                            },
                            "formato": {
                                "codigo": 1,
                                "nome": "Eletrônico"
                            },
                            "tribunal": "TJSP",
                            "dataHoraUltimaAtualizacao": "2024-08-26T20:45:07.608Z",
                            "grau": "G1",
                            "@timestamp": "2024-09-15T19:45:21.950659341Z",
                            "dataAjuizamento": "2024-07-29T11:20:00.000Z",
                            "movimentos": [
                                {
                                    "complementosTabelados": [
                                        {
                                            "codigo": 2,
                                            "valor": 2,
                                            "nome": "sorteio",
                                            "descricao": "tipo_de_distribuicao_redistribuicao"
                                        }
                                    ],
                                    "codigo": 26,
                                    "nome": "Distribuição",
                                    "dataHora": "2024-07-29T12:07:10.000Z"
                                },
                                {
                                    "complementosTabelados": [
                                        {
                                            "codigo": 4,
                                            "valor": 107,
                                            "nome": "Certidão",
                                            "descricao": "tipo_de_documento"
                                        }
                                    ],
                                    "codigo": 60,
                                    "nome": "Expedição de documento",
                                    "dataHora": "2024-07-29T13:56:45.000Z"
                                },
                                {
                                    "complementosTabelados": [
                                        {
                                            "codigo": 3,
                                            "valor": 5,
                                            "nome": "para despacho",
                                            "descricao": "tipo_de_conclusao"
                                        }
                                    ],
                                    "codigo": 51,
                                    "nome": "Conclusão",
                                    "dataHora": "2024-07-29T14:03:57.000Z"
                                },
                                {
                                    "codigo": 15085,
                                    "nome": "Emenda à Inicial",
                                    "dataHora": "2024-07-30T11:43:33.000Z"
                                }
                            ],
                            "id": "TJSP_G1_10535655720248260053",
                            "nivelSigilo": 0,
                            "orgaoJulgador": {
                                "codigo": 74365,
                                "nome": "16 FAZENDA PUBLICA DE CENTRAL"
                            },
                            "assuntos": [
                                {
                                    "codigo": 14950,
                                    "nome": "Pagamento"
                                }
                            ]
                        }
                    }
                ]
            }
        }
        """
    }
}
