//
//  TopAlbumsView.swift
//  LastfmWidget
//
//  Created by Wisse Hes on 07/06/2022.
//

import SwiftUI

struct TopAlbumsView: View {
    @State var topalbums: LastFMTopAlbums?
    
    var body: some View {
        List {
            if let topalbums = topalbums {
                ForEach(topalbums.album, id: \.name) { item in
                    Text(item.name)
                    AsyncImage(url: URL(string: item.image.first?.text ?? ""))
                }
            } else {
                ProgressView()
            }
        }.onAppear {
            API.topAlbums { result in
                switch result {
                case .success(let albums):
                    self.topalbums = albums
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

struct TopAlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        TopAlbumsView()
    }
}
