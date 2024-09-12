//
//  LawsuitErrors.swift
//  LawSuit
//
//  Created by Giovanna Micher on 11/09/24.
//

import Foundation

enum LawsuitNumberError: Error {
    case invalidLawsuitNumber
    case invalidEndpoint
    case couldNotGetEndpointFromEnum
}

enum LawsuitRequestError: Error {
    case couldNotCreateURL
    case serverError(Int)
    case couldNotTransformDataError
    case couldNotCreateRequestBody
    case jsonNavigationError
    case errorRequest(error: String)
    case coreDataSaveError(error: String)
    case couldNotGetMovementInfo
    case unknown
}

