//
//  ContentData.swift
//  CodeChallenge
//
//  Created by SOM on 24/11/20.
//  Copyright © 2020 Somnath Rasal. All rights reserved.
//

import Foundation

struct ContentData: Codable {
    var id: String?
    var type: String
    var date: String?
    var data: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case date
        case data
    }
}

extension ContentData {
    var dateConverted: Date {
        guard let date = self.date else { return Date() }
        return dateFormatter.date(from: date) ?? Date()
    }
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }
}
