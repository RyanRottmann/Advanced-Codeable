//
//  MainViewController.swift
//  AdvancedCodable2
//
//  Created by Ryan Rottmann on 9/13/19.
//  Copyright © 2019 Ryan Rottmann. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController {
    
    @IBOutlet weak var displayTextView: UITextView!
    var errorMessageText = ""
    let jsonFileName = "photos"
    
    enum MyError: Error{
            case runtimeError(String)
    }
    
    struct PhotoCollection: Codable {
        var status: String
        var photosPath: String
        var photos: [Photo]
        
        enum CodingKeys: String, CodingKey {
            case status
            case photosPath = "photos_path"
            case photos
        }
    }
    
    struct Photo: Codable {
        var image: String
        var title: String
        var description: String
        var latitude: Double
        var longitude: Double
        var date: String
    }
    
    func load(jsonFileName: String) -> PhotoCollection? {
        var photoCollection: PhotoCollection?
        let jsonDecoder = JSONDecoder()
        
        if let jsonFileUrl = Bundle.main.url(forResource: jsonFileName, withExtension: ".json"),
            let jsonData = try? Data(contentsOf: jsonFileUrl) {
            do{
                photoCollection = try jsonDecoder.decode(PhotoCollection.self, from: jsonData)
                print("do")
            } catch{
                print("catch")
                var errorMessage = ""
                errorMessage += error.localizedDescription
                errorMessageText += errorMessage + "\nThere is a detailed error message of where the error is located on the console"
                print(Error.self)
                print(error.localizedDescription)
                print("photoCollection is ")
                print(photoCollection?.photos as Any)
                print("photoCollection.debugDescription is " + photoCollection.debugDescription)
                print(error.self)
            }
            
        }
        
        return photoCollection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photoCollection = load(jsonFileName: jsonFileName) {
            var displayInfo = ""
            displayInfo += "Status: \(photoCollection.status)\n"
            displayInfo += "Photos path: \(photoCollection.photosPath)\n\n"
            for photo in photoCollection.photos {
                displayInfo += "Photo:\n"
                displayInfo += "\(photo.title)\n"
                displayInfo += "\(photo.description)\n"
                displayInfo += "\(photo.date)\n"
                displayInfo += "\(photo.latitude)\n"
                displayInfo += "\(photo.longitude)\n"
                displayInfo += "\(photo.image)\n\n"
            }
            displayTextView.text = displayInfo
        } else {
            displayTextView.text = errorMessageText
            
        }
        
    }
        
    
    



}
