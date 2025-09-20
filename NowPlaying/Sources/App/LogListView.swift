import SwiftUI
import CoreData

struct LogListView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(fetchRequest: LogEntry.fetchRequestRecent())
    private var items: FetchedResults<LogEntry>

    @State private var filterKind: String = "all"
    @State private var filterStatus: String = "all"
    @State private var search: String = ""

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Picker("Tipo", selection: $filterKind) {
                    Text("Todos").tag("all")
                    Text("Now Playing").tag("nowPlaying")
                    Text("Scrobble").tag("scrobble")
                }.pickerStyle(.segmented).frame(width: 280)

                Picker("Status", selection: $filterStatus) {
                    Text("Todos").tag("all")
                    Text("OK").tag("ok")
                    Text("Falhou").tag("failed")
                }.pickerStyle(.segmented).frame(width: 280)

                Spacer()
                TextField("Buscar por artista/track/álbum…", text: $search)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 200)
            }

            List(filtered(items)) { e in
                HStack(alignment: .top, spacing: 12) {
                    Text(e.kind == "nowPlaying" ? "NP" : "SC")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(e.kind == "nowPlaying" ? Color.blue.opacity(0.15) : Color.green.opacity(0.15))
                        .foregroundStyle(e.kind == "nowPlaying" ? .blue : .green)
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(e.artist) — \(e.track)").font(.headline)
                        HStack(spacing: 8) {
                            if let album = e.album, !album.isEmpty {
                                Label(album, systemImage: "opticaldisc")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Label(e.date.shortHuman(), systemImage: "clock")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        if let extra = e.extra, !extra.isEmpty {
                            Text(extra).font(.footnote).foregroundStyle(.red)
                        }
                    }
                    Spacer()
                    Circle()
                        .fill(e.status == "ok" ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                        .help(e.status.uppercased())
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 6)
    }

    private func filtered(_ src: FetchedResults<LogEntry>) -> [LogEntry] {
        src.filter { e in
            (filterKind == "all" || e.kind == filterKind) &&
            (filterStatus == "all" || e.status == filterStatus) &&
            (search.isEmpty || "\(e.artist) \(e.track) \(e.album ?? "")".lowercased().contains(search.lowercased()))
        }
    }
}
