import Foundation
import CoreData

@objc(LogEntry)
class LogEntry: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var kind: String
    @NSManaged var status: String
    @NSManaged var track: String
    @NSManaged var artist: String
    @NSManaged var album: String?
    @NSManaged var extra: String?
}

extension LogEntry {
    static func create(context: NSManagedObjectContext,
                       kind: String, status: String,
                       track: String, artist: String,
                       album: String?, extra: String?) {
        let e = LogEntry(context: context)
        e.id = UUID(); e.date = Date()
        e.kind = kind; e.status = status
        e.track = track; e.artist = artist
        e.album = album; e.extra = extra
        try? context.save()
    }

    static func fetchRequestRecent(limit: Int = 200) -> NSFetchRequest<LogEntry> {
        let req = NSFetchRequest<LogEntry>(entityName: "LogEntry")
        req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        req.fetchLimit = limit
        return req
    }
}

extension LogEntry: Identifiable {}
