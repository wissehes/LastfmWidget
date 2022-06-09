//
//  LastFMTopArtistsResponse.swift
//  LastfmWidget
//
//  Created by Wisse Hes on 07/06/2022.
//

import Foundation

// MARK: - LastFMTopArtistsResponse
struct LastFMTopArtistsResponse: Codable {
    let topartists: LastFMTopArtistsTopartists
}

// MARK: - LastFMTopArtistsTopartists
struct LastFMTopArtistsTopartists: Codable {
    let artist: [LastFMTopArtistsArtist]
    let attr: LastFMTopArtistsTopartistsAttr

    enum CodingKeys: String, CodingKey {
        case artist
        case attr = "@attr"
    }
}

// MARK: - LastFMTopArtistsArtist
struct LastFMTopArtistsArtist: Codable {
    let streamable: String
    let image: [LastFMTopArtistsImage]
    let mbid: String
    let url: String
    let playcount: String
    let attr: LastFMTopArtistsArtistAttr
    let name: String

    enum CodingKeys: String, CodingKey {
        case streamable, image, mbid, url, playcount
        case attr = "@attr"
        case name
    }
}

// MARK: - LastFMTopArtistsArtistAttr
struct LastFMTopArtistsArtistAttr: Codable {
    let rank: String
}

// MARK: - LastFMTopArtistsImage
struct LastFMTopArtistsImage: Codable {
    let size: LastFMTopArtistsSize
    let text: String

    enum CodingKeys: String, CodingKey {
        case size
        case text = "#text"
    }
}

enum LastFMTopArtistsSize: String, Codable {
    case extralarge = "extralarge"
    case large = "large"
    case medium = "medium"
    case mega = "mega"
    case small = "small"
}

// MARK: - LastFMTopArtistsTopartistsAttr
struct LastFMTopArtistsTopartistsAttr: Codable {
    let user, totalPages, page, perPage: String
    let total: String
}
