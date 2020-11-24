//
//  ContentFileManager.swift
//  CodeChallenge
//
//  Created by SOM on 24/11/20.
//  Copyright © 2020 Somnath Rasal. All rights reserved.
//

import Foundation

class ContentFileManager {

    // Save the downloaded JSON file in applicationSupportDirectory
    static func saveContentData(contentData: [[String: Any]]) {
        
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("contentData.json")

            try JSONSerialization.data(withJSONObject: contentData)
                .write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    // Read the contents of JSON file from applicationSupportDirectory
    static func readContentData() -> [[String: Any]]? {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("contentData.json")

            let data = try Data(contentsOf: fileURL)
            let contentData = try JSONSerialization.jsonObject(with: data)
            print(contentData)
            return contentData as? [[String: Any]]
        } catch {
            print(error)
        }
        return nil
    }

}

