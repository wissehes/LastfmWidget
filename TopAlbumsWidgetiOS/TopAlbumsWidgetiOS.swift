//
//  TopAlbumsWidget.swift
//  TopAlbumsWidget
//
//  Created by Wisse Hes on 07/06/2022.
//

import WidgetKit
import SwiftUI
import UIKit
import Intents

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), topalbum: .sample, error: false, configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), topalbum: .sample, error: false,  configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        API.widgetTopAlbum(period: configuration.period) { result in
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
    @Environment(\.colorScheme) var colorScheme
    var gradientColor: Color {
        if colorScheme == .dark {
            return .black
        } else {
            return .white
        }
    }
    
    var gradient: some View {
        LinearGradient(colors: [gradientColor, .pink], startPoint: .topTrailing, endPoint: .bottomLeading)
    }
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallView(entry: entry)
        case .systemMedium:
            MediumView(entry: entry)
        case .systemLarge:
            ZStack {
                LinearGradient(colors: [.white, .pink], startPoint: .topTrailing, endPoint: .bottomLeading)
                
                Text(entry.topalbum.name)
            }
        case .systemExtraLarge:
            ZStack {
                LinearGradient(colors: [.white, .pink], startPoint: .topTrailing, endPoint: .bottomLeading)
                
                Text(entry.topalbum.name)
            }
        @unknown default:
            Text(entry.topalbum.name)
        }
    }
    
    func showImage(_ image: UIImage?, geo: GeometryProxy) -> some View {
        Group {
            if let image = entry.topalbum.uiImage {
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
        ).preferredColorScheme(.dark).previewContext(WidgetPreviewContext(family: .systemMedium))
        
    }
}
