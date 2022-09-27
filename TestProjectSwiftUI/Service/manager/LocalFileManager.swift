//
//  LocalFileManager.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 14.07.2022.
//

import SwiftUI

class LocalFileManager {
    static let shared = LocalFileManager()
    private init() { }
    
    func saveImage(image: UIImage, nameImage: String, nameFolder: String) {
        createFolderIfNeeded(folderName: nameFolder)
        
        guard let data = image.pngData(),
              let url = getURLForImage(imageName: nameImage, folderName: nameFolder) else {
            return
        }
        
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image \(error.localizedDescription) Folder name - \(nameFolder)")
        }
    }
    
    func getImage(nameImage: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: nameImage, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating folder \(error.localizedDescription) Folder name - \(folderName)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
