//
//  LastFMTopAlbumsResponse.swift
//  LastfmWidget
//
//  Created by Wisse Hes on 07/06/2022.
//

import Foundation

// MARK: - LastFMTopAlbumsResponse
struct LastFMTopAlbumsResponse: Codable {
    let topalbums: LastFMTopAlbums
}

// MARK: - LastFMTopAlbumsResponseTopalbums
struct LastFMTopAlbums: Codable {
    let album: [LastFMTopAlbumsResponseAlbum]
    let attr: LastFMTopAlbumsResponseTopalbumsAttr

    enum CodingKeys: String, CodingKey {
        case album
        case attr = "@attr"
    }
}

// MARK: - LastFMTopAlbumsResponseAlbum
struct LastFMTopAlbumsResponseAlbum: Codable {
    let artist: LastFMTopAlbumsResponseArtist
    let image: [LastFMTopAlbumsResponseImage]
    let mbid: String
    let url: String
    let playcount: String
    let attr: LastFMTopAlbumsResponseAlbumAttr
    let name: String

    enum CodingKeys: String, CodingKey {
        case artist, image, mbid, url, playcount
        case attr = "@attr"
        case name
    }
}

// MARK: - LastFMTopAlbumsResponseArtist
struct LastFMTopAlbumsResponseArtist: Codable {
    let url: String
    let name, mbid: String
}

// MARK: - LastFMTopAlbumsResponseAlbumAttr
struct LastFMTopAlbumsResponseAlbumAttr: Codable {
    let rank: String
}

// MARK: - LastFMTopAlbumsResponseImage
struct LastFMTopAlbumsResponseImage: Codable {
    let size: LastFMTopAlbumsResponseSize
    let text: String

    enum CodingKeys: String, CodingKey {
        case size
        case text = "#text"
    }
}

enum LastFMTopAlbumsResponseSize: String, Codable {
    case extralarge = "extralarge"
    case large = "large"
    case medium = "medium"
    case small = "small"
}

// MARK: - LastFMTopAlbumsResponseTopalbumsAttr
struct LastFMTopAlbumsResponseTopalbumsAttr: Codable {
    let user, totalPages, page, perPage: String
    let total: String
}
