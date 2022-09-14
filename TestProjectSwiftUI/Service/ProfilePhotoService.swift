//
//  ProfilePhotoService.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 07.09.2022.
//

import Foundation
import CoreData

class ProfilePhotoService {
    let persistentContainer: NSPersistentContainer
    static var shared = ProfilePhotoService()
    
    private init() {
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        
        persistentContainer = NSPersistentContainer(name: "ProfilePhotoContainer")
        UIImageTransformer.register()
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Fatal error - \(error)")
            }
        }
    }
}
