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

