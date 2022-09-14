//
//  ProfilePhotoService.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 07.09.2022.
//

import UIKit
import CoreData

@objc(PhotoProfile)
class PhotoProfile: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoProfile> {
        return NSFetchRequest<PhotoProfile>(entityName: "PhotoProfile")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: UIImage?

}

extension PhotoProfile : Identifiable {

}
