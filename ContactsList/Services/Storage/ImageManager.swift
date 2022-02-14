//
//  ImageStorage.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 16.01.2022.
//

import UIKit
import Kingfisher

class ImageManager {
    
    static let shared = ImageManager()
    
    private let fileManager: FileManager
    
    private init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    
    func imageURL(forPath path: String) -> URL {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(path)
        return url
    }
    
    func saveImageOnDisk(image: UIImage, pathComponent: String, imageCompletionHandler: @escaping (String?) -> Void) {
        
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = pathComponent + ".jpg"
        let url = documents.appendingPathComponent(fileName)
        
        if let data = image.jpegData(compressionQuality: 0.95) {
            do {
                try data.write(to: url)
                imageCompletionHandler(fileName)
            } catch {
                print("Unable to write image data to disk")
            }
        }
    }
    
    func saveImageOnDisk(image: UIImage, pathComponent: String) {
        
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let url = documents.appendingPathComponent(pathComponent)
        
        if let data = image.jpegData(compressionQuality: 0.95) {
            do {
                try data.write(to: url)
            } catch {
                print("Unable to write image data to disk")
            }
        }
    }
    
    func deleteImageFromDisk(pathComponent: String) {
        let url = imageURL(forPath: pathComponent)
        let path = url.path
        
        do {
            if fileManager.fileExists(atPath: path) {
                try fileManager.removeItem(atPath: path)
            } else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place: \(error.localizedDescription)")
        }
    }
    
    func retrieveImage(with imagePath: String) -> UIImage? {
        
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let url = documents.appendingPathComponent(imagePath)
        
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error.localizedDescription)")
        }
        return UIImage(systemName: "photo.artframe")
    }
    
    func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void) {
        
        guard let imageURL = URL(string: urlString) else {
            return  imageCompletionHandler(nil)
        }
        let resource = ImageResource(downloadURL: imageURL)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                imageCompletionHandler(value.image)
            case .failure:
                imageCompletionHandler(nil)
            }
        }
    }
    
    func downloadImage(with url : URL , imageCompletionHandler: @escaping (UIImage?) -> Void) {
        
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                imageCompletionHandler(value.image)
            case .failure:
                imageCompletionHandler(nil)
            }
        }
    }
    
}
