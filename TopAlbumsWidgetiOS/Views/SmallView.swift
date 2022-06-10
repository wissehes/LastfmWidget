//
//  SmallView.swift
//  LastFM Widgets
//
//  Created by Wisse Hes on 09/06/2022.
//

import SwiftUI
import WidgetKit

struct SmallView: View {
    var entry: Provider.Entry
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                BackgroundGradient()
                
                showImage(entry.topalbum.uiImage, geo: geo)
                
                VStack(alignment: .center) {
                    Text(entry.topalbum.name)
                        .font(.headline)
                        .padding(.leading, 2)
                        .padding(.trailing, 2)
                        .background(.ultraThinMaterial)
                        .cornerRadius(5)
                    Text(entry.configuration.period.periodText)
                        .lineLimit(2)
                        .foregroundColor(.gray)
                        .font(.system(size: 11))
                }.padding()
            }
        }
    }
    
    func showImage(_ image: UIImage, geo: GeometryProxy) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .clipShape(ContainerRelativeShape())
            .frame(
                width: geo.size.width,
                height: geo.size.height
            )
    }
}

struct SmallView_Previews: PreviewProvider {
    static var previews: some View {
        SmallView(entry: SimpleEntry(
            date: Date(),
            topalbum: .sample,
            error: false,
            configuration: ConfigurationIntent()
        )
        ).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
