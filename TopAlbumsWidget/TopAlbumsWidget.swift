//
//  TopAlbumsWidget.swift
//  TopAlbumsWidget
//
//  Created by Wisse Hes on 07/06/2022.
//

import WidgetKit
import SwiftUI
import Intents
import Cocoa

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), topalbum: .sample, error: false, configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), topalbum: .sample, error: false,  configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        API.widgetTopAlbum { result in
            var entries: [SimpleEntry] = []
            var policy: TimelineReloadPolicy = .after(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!)
            
            switch result {
            case .success(let album):
                entries.append(SimpleEntry(date: Date(), topalbum: album, error: false, configuration: configuration))
                policy = .after(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!)
                break;
            case .failure(_):
                entries.append(SimpleEntry(date: Date(), topalbum: .sample, error: true, configuration: configuration))
                policy = .after(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!)
                break
            }
            
            let timeline = Timeline(entries: entries, policy: policy)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let topalbum: BasicAlbum
    let error: Bool
    let configuration: ConfigurationIntent
}

struct TopAlbumsWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            GeometryReader { geo in
                ZStack(alignment: .bottom) {
                    LinearGradient(colors: [.white, .pink], startPoint: .topTrailing, endPoint: .bottomLeading)
                    
                    showImage(entry.topalbum.nsImage, geo: geo)
                    
                    VStack(alignment: .leading) {
                        Text(entry.topalbum.name)
                            .foregroundColor(.white)
                            .font(.headline)
                        Text("Most played album of all time")
                            .lineLimit(3)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .padding(.bottom)
                    }
                        .padding(.leading)
                        .padding(.trailing)
                        .frame(width: geo.size.width, alignment: .leading)
                }
            }
        case .systemMedium:
            GeometryReader { geo in
                ZStack {
                    LinearGradient(colors: [.white, .pink], startPoint: .topTrailing, endPoint: .bottomLeading)
                    
                    HStack {
                        if let image = entry.topalbum.nsImage {
                            Image(nsImage: image)
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(width: 100, height: 100, alignment: .leading)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(entry.topalbum.name)
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.heavy)
                            Text(entry.topalbum.artist)
                                .font(.system(.title, design: .default))
                            Text("Most listened album of all time")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }.padding()
                }.frame(width: geo.size.width, height: geo.size.height)
            }
        case .systemLarge:
            ZStack {
                LinearGradient(colors: [.white, .pink], startPoint: .topTrailing, endPoint: .bottomLeading)
                
                Text(entry.topalbum.name)
            }
        @unknown default:
            Text(entry.topalbum.name)
        }
    }
    
    func showImage(_ image: NSImage?, geo: GeometryProxy) -> some View {
        Group {
            if let image = entry.topalbum.nsImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(ContainerRelativeShape())
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height
                    )
            }
        }
    }
}

@main
struct TopAlbumsWidget: Widget {
    let kind: String = "TopAlbumsWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TopAlbumsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Top Albums")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct TopAlbumsWidget_Previews: PreviewProvider {
    static var previews: some View {
        TopAlbumsWidgetEntryView(entry:
                                    SimpleEntry(
                                        date: Date(),
                                        topalbum: .sample,
                                        error: false,
                                        configuration: ConfigurationIntent())
        ).previewContext(WidgetPreviewContext(family: .systemSmall))
        TopAlbumsWidgetEntryView(entry:
                                    SimpleEntry(
                                        date: Date(),
                                        topalbum: .sample,
                                        error: false,
                                        configuration: ConfigurationIntent())
        ).previewContext(WidgetPreviewContext(family: .systemMedium))
        
    }
}
