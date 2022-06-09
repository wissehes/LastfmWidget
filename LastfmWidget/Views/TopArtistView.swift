//
//  TopArtistView.swift
//  LastfmWidget
//
//  Created by Wisse Hes on 07/06/2022.
//

import SwiftUI

struct TopArtistView: View {
    @State var topartists: LastFMTopArtistsTopartists?
    
    var body: some View {
        List {
            if let topartists = topartists {
                ForEach(topartists.artist, id: \.name) { item in
                    Text(item.name)
                }
            } else {
                ProgressView()
            }
        }.onAppear {
            API.topArtists { result in
                switch result {
                case .success(let artists):
                    self.topartists = artists
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

struct TopArtistView_Previews: PreviewProvider {
    static var previews: some View {
        TopArtistView()
    }
}
