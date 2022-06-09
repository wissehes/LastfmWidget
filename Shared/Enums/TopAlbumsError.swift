//
//  TopAlbumsError.swift
//  LastfmWidget
//
//  Created by Wisse Hes on 08/06/2022.
//

import Foundation
import Alamofire

enum TopAlbumsError: Error {
    case afError(AFError)
    case noData
}
