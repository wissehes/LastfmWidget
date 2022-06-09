//
//  API.swift
//  LastfmWidget
//
//  Created by Wisse Hes on 07/06/2022.
//

import Foundation
import Alamofire
import AppKit

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
    
    static func topAlbums(_ period: LastfmPeriod = .overall,completion: @escaping (Result<LastFMTopAlbums, AFError>) -> Void) {
        let parameters: Parameters = [
            "method": "user.gettopalbums",
            "user": Config.user,
            "api_key": Config.LastFMApiKey,
            "format": "json",
            "period": period.lastfmValue
        ]
        lfm.request("\(Config.LastFMApi)", parameters: parameters).validate().responseDecodable(of:LastFMTopAlbumsResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.topalbums))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func widgetTopAlbum(period: LastfmPeriod, completion: @escaping (Result<BasicAlbum, TopAlbumsError>) -> Void) {
        self.topAlbums { result in
            switch result {
            case .success(let topalbums):
                if let album = topalbums.album.first {
                    var basicAlbum = BasicAlbum(from: album)
                    
                    if let imageurl = basicAlbum.image {
                        self.getImageFromURL(imageurl) { result in
                            switch result {
                            case .success(let image):
                                basicAlbum.nsImage = image
                                completion(.success(basicAlbum))
                            case .failure(_):
                                completion(.success(basicAlbum))
                            }
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
    
    static private func getImageFromURL(_ url: URL, completion: @escaping (Result <NSImage, ImageError>) -> Void) {
        lfm.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let image = NSImage(data: data)
                if let image = image {
                    completion(.success(image))
                } else {
                    completion(.failure(.imageError))
                }
            case .failure(let err):
                completion(.failure(.afError(err)))
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
            return "overall"
        }
    }
}
