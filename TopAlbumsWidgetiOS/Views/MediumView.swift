//
//  MediumView.swift
//  LastFM Widgets
//
//  Created by Wisse Hes on 09/06/2022.
//

import SwiftUI
import WidgetKit
import UIImageColors

struct MediumView: View {
    var entry: Provider.Entry
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                BackgroundGradient(color: entry.topalbum.backgroundColor)
                
                HStack {
                    Image(uiImage: entry.topalbum.uiImage)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 100, height: 100, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text(entry.topalbum.name)
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.heavy)
                        Text(entry.topalbum.artist)
                            .font(.system(.title3, design: .default))
                        Text(entry.configuration.period.periodText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(entry.topalbum.scrobbles) Plays")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }.padding()
            }.frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct MediumView_Previews: PreviewProvider {
    static var previews: some View {
        MediumView(entry: SimpleEntry(
            date: Date(),
            topalbum: .sample,
            error: false,
            configuration: ConfigurationIntent()
            )
        ).previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
