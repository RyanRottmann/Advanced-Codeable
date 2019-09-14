//
//  MainViewController.swift
//  AdvancedCodable1
//
//  Created by Ryan Rottmann on 9/13/19.
//  Copyright © 2019 Ryan Rottmann. All rights reserved.
//

import UIKit
import Foundation
extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var displayTextView: UITextView!
    
    let jsonFileName = "photos"

    
    struct PhotoSet: Codable {
        var status: String
        var photosPath: String
        var photos: [PhotoItem]
        
        enum CodingKeys: String, CodingKey {
            case status
            case photosPath = "photos_path"
            case photos
        }
    }
    
    struct PhotoItem: Codable {
        var imageName: String
        var title: String
        var description: String
        var date: Date
        
        enum CodingKeys: String, CodingKey {
            case imageName = "image"
            case title
            case description
            case date
        }
    }
    
    func load(jsonFileName: String) -> PhotoSet? {
        var photoSet: PhotoSet?
        let jsonDecoder = JSONDecoder()
        
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        if let jsonFileUrl = Bundle.main.url(forResource: jsonFileName, withExtension: ".json"),
            let jsonData = try? Data(contentsOf: jsonFileUrl) {
            photoSet = try? jsonDecoder.decode(PhotoSet.self, from: jsonData)
        }
        
        return photoSet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photoSet = load(jsonFileName: jsonFileName) {
            var displayInfo = ""
            displayInfo += "Status: \(photoSet.status)\n"
            displayInfo += "Photos path: \(photoSet.photosPath)\n\n"
            for photo in photoSet.photos {
                displayInfo += "Photo:\n"
                displayInfo += "\(photo.title)\n"
                displayInfo += "\(photo.description)\n"
                displayInfo += "\(photo.date)\n"
                displayInfo += "\(photo.imageName)\n\n"
            }
            displayTextView.text = displayInfo
        } else {
            displayTextView.text = "Error."
            
        }

        
    }


}

