import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    let container: NSPersistentContainer

    private init() {
        let model = NSManagedObjectModel()
        let entity = NSEntityDescription()
        entity.name = "LogEntry"
        entity.managedObjectClassName = NSStringFromClass(LogEntry.self)

        func attr(_ n: String, _ t: NSAttributeType, optional: Bool = false) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = n; a.attributeType = t; a.isOptional = optional; return a
        }

        entity.properties = [
            attr("id", .UUIDAttributeType),
            attr("date", .dateAttributeType),
            attr("kind", .stringAttributeType),
            attr("status", .stringAttributeType),
            attr("track", .stringAttributeType),
            attr("artist", .stringAttributeType),
            attr("album", .stringAttributeType, optional: true),
            attr("extra", .stringAttributeType, optional: true)
        ]

        model.entities = [entity]

        container = NSPersistentContainer(name: "Scrobble", managedObjectModel: model)

        let appSup = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSup.appendingPathComponent("NowPlaying", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent("Scrobble.sqlite")

        let desc = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [desc]

        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Core Data error: \(error)") }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
