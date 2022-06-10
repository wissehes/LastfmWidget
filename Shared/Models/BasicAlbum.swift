//
//  BasicAlbum.swift
//  LastfmWidget
//
//  Created by Wisse Hes on 07/06/2022.
//

import Foundation
import UIKit
import SwiftUI

struct BasicAlbum {
    let name: String
    let artist: String
    let image: URL?
    let scrobbles: String
    var uiImage: UIImage = UIImage(systemName: "music.note")!
    var backgroundColor: Color?

    
    static let sample: BasicAlbum = .init(
        name: "Chromatica",
        artist: "Lady Gaga",
        image: URL(string: "https://upload.wikimedia.org/wikipedia/en/d/d6/Lady_Gaga_-_Chromatica_%28Official_Album_Cover%29.png"),
        scrobbles: "1000",
        uiImage: UIImage(named: "chromatica")!,
        backgroundColor: .black
    )
}

extension BasicAlbum {
    init(from: LastFMTopAlbumsResponseAlbum) {
        self.name = from.name
        self.artist = from.artist.name
        self.image = URL(string: from.image.last?.text ?? "")
        self.scrobbles = from.playcount
        self.backgroundColor = .black
    }
}
