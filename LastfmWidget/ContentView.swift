//
//  ContentView.swift
//  LastfmWidget
//
//  Created by Wisse Hes on 07/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab = 1
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Top Artists", destination: TopArtistView())
                NavigationLink("Top Albums", destination: TopAlbumsView())
            }.listStyle(.sidebar)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
