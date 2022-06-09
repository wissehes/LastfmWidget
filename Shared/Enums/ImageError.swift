//
//  ImageError.swift
//  LastfmWidget
//
//  Created by Wisse Hes on 09/06/2022.
//

import Foundation
import Alamofire

enum ImageError: Error {
    case afError(AFError)
    case imageError
}
