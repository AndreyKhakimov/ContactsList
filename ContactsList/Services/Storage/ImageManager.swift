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
    
    private init() {}
    
    func imageURL(forPath path: String) -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(path)
        return url
    }
    
    func saveImageOnDisk(image: UIImage, pathComponent: String, imageCompletionHandler: @escaping (String?) -> Void) {
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
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
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = pathComponent + ".jpg"
        let url = documents.appendingPathComponent(fileName)
        
        if let data = image.jpegData(compressionQuality: 0.95) {
            do {
                try data.write(to: url)
            } catch {
                print("Unable to write image data to disk")
            }
        }
    }
    
    func retrieveImage(with imagePath: String) -> UIImage? {
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
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
