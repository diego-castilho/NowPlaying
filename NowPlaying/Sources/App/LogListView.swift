//
//  LogListView.swift
//  NowPlaying
//
//  Scrobble Log View - Liquid Glass Design
//
//  Created by Diego Castilho on 17/11/25
//  Copyright © 2025 Diego Castilho. All rights reserved.
//

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
        VStack(spacing: 0) {
            // Header with filters
            filterHeader
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.md)
            
            // List content
            if filtered(items).isEmpty {
                emptyState
            } else {
                logList
            }
        }
        .background(
            Color.clear
                .background(.ultraThinMaterial)
        )
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private var filterHeader: some View {
        GlassCard(
            padding: DesignSpacing.md,
            cornerRadius: DesignSpacing.CornerRadius.lg,
            shadow: .prominent,
            backgroundColor: DesignColor.Glass.surface1.opacity(0.4)
        ) {
            VStack(spacing: DesignSpacing.sm) {
                // Pickers row
                HStack(spacing: DesignSpacing.md) {
                    // Tipo picker
                    VStack(alignment: .leading, spacing: DesignSpacing.xxs) {
                        Text("Tipo")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(DesignColor.Text.secondary)
                        
                        Picker("", selection: $filterKind) {
                            Text("Todos").tag("all")
                            Text("Now Playing").tag("nowPlaying")
                            Text("Scrobble").tag("scrobble")
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Status picker
                    VStack(alignment: .leading, spacing: DesignSpacing.xxs) {
                        Text("Status")
                            .font(DesignTypography.caption1)
                            .foregroundStyle(DesignColor.Text.secondary)
                        
                        Picker("", selection: $filterStatus) {
                            Text("Todos").tag("all")
                            Text("OK").tag("ok")
                            Text("Falhou").tag("failed")
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: .infinity)
                    }
                }
                
                // Search field
                HStack(spacing: DesignSpacing.xs) {
                    Image(systemName: "magnifyingglass")
                        .font(DesignTypography.body)
                        .foregroundStyle(DesignColor.Text.tertiary)
                    
                    TextField("Buscar por artista, música ou álbum…", text: $search)
                        .textFieldStyle(.plain)
                        .font(DesignTypography.body)
                    
                    if !search.isEmpty {
                        Button {
                            search = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(DesignTypography.body)
                                .foregroundStyle(DesignColor.Text.tertiary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.vertical, DesignSpacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: DesignSpacing.CornerRadius.sm)
                        .fill(DesignColor.Glass.surface2.opacity(0.5))
                )
            }
        }
        .frostEffect(intensity: 0.6)
    }
    
    // MARK: - List
    
    @ViewBuilder
    private var logList: some View {
        ScrollView {
            LazyVStack(spacing: DesignSpacing.sm) {
                ForEach(Array(filtered(items).enumerated()), id: \.element.id) { index, entry in
                    logItemView(entry)
                        .transition(TransitionPreset.fadeScale.transition)
                        .animation(
                            AnimationPreset.springGentle.animation.delay(Double(index) * 0.02),
                            value: filterKind
                        )
                        .animation(
                            AnimationPreset.springGentle.animation.delay(Double(index) * 0.02),
                            value: filterStatus
                        )
                }
            }
            .padding(.horizontal, DesignSpacing.lg)
            .padding(.vertical, DesignSpacing.md)
        }
    }
    
    @ViewBuilder
    private func logItemView(_ entry: LogEntry) -> some View {
        GlassCard(
            padding: DesignSpacing.md,
            cornerRadius: DesignSpacing.CornerRadius.md,
            shadow: .prominent,
            backgroundColor: DesignColor.Glass.surface1.opacity(0.3)
        ) {
            HStack(alignment: .top, spacing: DesignSpacing.md) {
                // Type badge
                GlassBadge(
                    entry.kind == "nowPlaying" ? "NOW" : "SCROBBLE",
                    style: entry.kind == "nowPlaying" ? .info : .success,
                    size: .small
                )
                
                // Track info
                VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                    // Artist — Track
                    Text("\(entry.artist) — \(entry.track)")
                        .font(DesignTypography.headline)
                        .foregroundStyle(DesignColor.Text.primary)
                        .lineLimit(2)
                    
                    // Album + Date
                    HStack(spacing: DesignSpacing.sm) {
                        if let album = entry.album, !album.isEmpty {
                            HStack(spacing: DesignSpacing.xxs) {
                                Image(systemName: "opticaldisc")
                                    .font(DesignTypography.caption1)
                                Text(album)
                                    .font(DesignTypography.subheadline)
                            }
                            .foregroundStyle(DesignColor.Text.secondary)
                        }
                        
                        HStack(spacing: DesignSpacing.xxs) {
                            Image(systemName: "clock")
                                .font(DesignTypography.caption1)
                            Text(entry.date.shortHuman())
                                .font(DesignTypography.subheadline)
                        }
                        .foregroundStyle(DesignColor.Text.tertiary)
                    }
                    
                    // Error message (if any)
                    if let extra = entry.extra, !extra.isEmpty {
                        Text(extra)
                            .font(DesignTypography.footnote)
                            .foregroundStyle(DesignColor.Status.error)
                            .padding(.top, DesignSpacing.xxs)
                    }
                }
                
                Spacer()
                
                // Status badge
                GlassBadge(
                    entry.status.uppercased(),
                    style: entry.status == "ok" ? .success : .error,
                    size: .small
                )
            }
        }
        .frostEffect(intensity: 0.4)
    }
    
    // MARK: - Empty State
    
    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: DesignSpacing.lg) {
            Spacer()
            
            Image(systemName: "music.note.list")
                .font(.system(size: 64))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            DesignColor.Accent.primary.opacity(0.6),
                            DesignColor.Accent.secondary.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: DesignSpacing.xs) {
                Text("Nenhum registro encontrado")
                    .font(DesignTypography.title3)
                    .foregroundStyle(DesignColor.Text.primary)
                
                Text(emptyStateMessage)
                    .font(DesignTypography.body)
                    .foregroundStyle(DesignColor.Text.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if !search.isEmpty || filterKind != "all" || filterStatus != "all" {
                GlassButton(
                    "Limpar Filtros",
                    icon: "xmark.circle",
                    style: .secondary,
                    size: .medium
                ) {
                    withAnimation(AnimationPreset.springBouncy.animation) {
                        search = ""
                        filterKind = "all"
                        filterStatus = "all"
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSpacing.xl)
    }
    
    private var emptyStateMessage: String {
        if !search.isEmpty {
            return "Nenhum resultado para '\(search)'"
        } else if filterKind != "all" || filterStatus != "all" {
            return "Tente ajustar os filtros"
        } else {
            return "Comece tocando uma música no Apple Music"
        }
    }
    
    // MARK: - Filter Logic
    
    private func filtered(_ src: FetchedResults<LogEntry>) -> [LogEntry] {
        src.filter { e in
            (filterKind == "all" || e.kind == filterKind) &&
            (filterStatus == "all" || e.status == filterStatus) &&
            (search.isEmpty || "\(e.artist) \(e.track) \(e.album ?? "")".lowercased().contains(search.lowercased()))
        }
    }
}

// MARK: - Preview

#if DEBUG
struct LogListView_Previews: PreviewProvider {
    static var previews: some View {
        let core = CoreDataStack.shared
        
        return LogListView()
            .environment(\.managedObjectContext, core.container.viewContext)
            .frame(width: 800, height: 600)
    }
}
#endif
