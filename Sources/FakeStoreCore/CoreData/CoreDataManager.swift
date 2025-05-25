//
//  CoreDataManager.swift
//  FakeStore
//
//  Created by Andrew Vale on 17/02/25.
//

import CoreData

public class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    
    public init(modelName: String) {
            guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
                  let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Failed to load the Core Data model \(modelName) from the package bundle.")
            }

            persistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)

            persistentContainer.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Failed to load persistent stores: \(error)")
                }
            }
            backgroundContext = persistentContainer.newBackgroundContext()
        }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //TODO: - Implement a better error handling
                print("Error while saving context \(error)")
            }
        }
    }
}
