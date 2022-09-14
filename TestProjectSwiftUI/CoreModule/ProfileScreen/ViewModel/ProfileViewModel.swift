//
//  ProfileViewModel.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 07.09.2022.
//

import CoreData
import SwiftUI
import GoogleSignIn

class ProfileViewModel: ObservableObject {
    
    let user = GIDSignIn.sharedInstance.currentUser
    @Published var image: UIImage?
    private var context = ProfilePhotoService.shared.persistentContainer.viewContext
    
    init() {
        loadPhotoWithCoreData()
    }
    
    func savedImage(imageProfile: UIImage) {
        image = imageProfile
        
        guard let image = image else {
            return
        }
        
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        
        saveData(data: data)
    }
    
    private func saveData(data: Data) {
        
        let photo = PhotoProfile(context: context)
        photo.content = UIImage(data: data)
        
        image = photo.content
        try? context.save()
    }
    
    private func loadPhotoWithCoreData() {
        let request: NSFetchRequest<PhotoProfile> = NSFetchRequest(entityName: "PhotoProfile")

        do {
            let photos: [PhotoProfile] = try context.fetch(request)
            if let photo = photos.first {
                image = photo.content
            }
        } catch let error {
            print(error)
        }
    }
}
