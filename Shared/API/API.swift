//
//  API.swift
//  LastfmWidget
//
//  Created by Wisse Hes on 07/06/2022.
//

import Foundation
import Alamofire
import UIKit
import SwiftUI
import UIImageColors

class API {
    static let lfm: Session = {
        let configuration = URLSessionConfiguration.af.default
        
        configuration.waitsForConnectivity = true
        
        return Session(configuration: configuration)
    }()
    
    static func topArtists(completion: @escaping (Result<LastFMTopArtistsTopartists, AFError>) -> Void) {
        let parameters: Parameters = [
            "method": "user.gettopartists",
            "user": Config.user,
            "api_key": Config.LastFMApiKey,
            "format": "json"
        ]
        lfm.request("\(Config.LastFMApi)", parameters: parameters).validate().responseDecodable(of:LastFMTopArtistsResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.topartists))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func topAlbums(_ period: LastfmPeriod = .overall, completion: @escaping (Result<LastFMTopAlbums, AFError>) -> Void) {
        let parameters: Parameters = [
            "method": "user.gettopalbums",
            "user": Config.user,
            "api_key": Config.LastFMApiKey,
            "format": "json",
            "period": period.lastfmValue
        ]
        lfm.request("\(Config.LastFMApi)", parameters: parameters).validate().responseDecodable(of:LastFMTopAlbumsResponse.self) { response in
            //            print(response.response)
            switch response.result {
            case .success(let data):
                completion(.success(data.topalbums))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func widgetTopAlbum(period: LastfmPeriod, completion: @escaping (Result<BasicAlbum, TopAlbumsError>) -> Void) {
        self.topAlbums(period) { result in
            switch result {
            case .success(let topalbums):
                if let album = topalbums.album.first {
                    var basicAlbum = BasicAlbum(from: album)
                    
                    if let imageurl = basicAlbum.image {
                        self.getImageFromURL(imageurl) { image in
                            let colors = image.getColors()
                            if let colors = colors {
                                basicAlbum.backgroundColor = Color(uiColor: colors.background)
                            }
                            basicAlbum.uiImage = image
                            completion(.success(basicAlbum))
                        }
                    } else {
                        completion(.success(basicAlbum))
                    }
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let err):
                completion(.failure(.afError(err)))
            }
        }
    }
    
    static private func getImageFromURL(_ url: URL, completion: @escaping (UIImage) -> Void) {
        lfm.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let image = UIImage(data: data)
                if let image = image {
                    completion(image)
                } else {
                    completion(UIImage(systemName: "music.note")!)
                }
            case .failure(_):
                completion(UIImage(systemName: "music.note")!)
            }
        }
    }
}

extension LastfmPeriod {
    var lastfmValue: String {
        switch self {
        case .overall:
            return "overall"
        case .lastWeek:
            return "7day"
        case .lastMonth:
            return "1month"
        case .threemonth:
            return "3month"
        case .sixmonth:
            return "6month"
        case .lastYear:
            return "12month"
        default:
            return "7day"
        }
    }
    
    var periodText: String {
        switch self {
        case .overall:
            return "#1 album of all time"
        case .lastWeek:
            return "#1 album last week"
        case .lastMonth:
            return "#1 album last month"
        case .threemonth:
            return "#1 album last 3 months"
        case .sixmonth:
            return "#1 album last 6 months"
        case .lastYear:
            return "#1 album last year"
        default:
            return "#1 album last week"
        }
    }
}
