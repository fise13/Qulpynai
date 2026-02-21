//
//  Persistence.swift
//  Qulpynai
//
//  CoreData controller — isolated, not used in app flow
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        try? viewContext.save()
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Qulpynai")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                #if DEBUG
                assertionFailure("CoreData load failed: \(error), \(error.userInfo)")
                #endif
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
