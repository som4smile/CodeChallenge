//
//  FileManager.swift
//  CodeChallenge
//
//  Created by SOM on 24/11/20.
//  Copyright © 2020 Somnath Rasal. All rights reserved.
//

import Foundation

class ContentFileManager {

    static func writeToFile(location: URL, data: Data) {
        do {
            let fileURL = try FileManager.
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("example.json")

            try JSONSerialization.data(withJSONObject: dictionary)
                .write(to: fileURL)
        } catch {
            print(error)
        }
    }

}

