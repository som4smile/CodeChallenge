//
//  ContentDownloader.swift
//  CodeChallenge
//
//  Created by SOM on 24/11/20.
//  Copyright © 2020 Somnath Rasal. All rights reserved.
//

import Foundation
import Alamofire

typealias TaskCompletionHandler = ((Any?, Error?) -> Void)

struct NetworkState {

    // Instance variable to hold the value for Network reachability.
    var isNetworkAvailable: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class ContentDownloader {
    
    static let sharedInstance = ContentDownloader()
    private let urlString = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json"
    
    // API to Download content from Server using Alamofire
    func downloadContent(with completionBlock: @escaping TaskCompletionHandler) -> Void {
        AF.request(self.urlString, method: .get, encoding: URLEncoding.default).responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success(let json):
                completionBlock(json, nil)
                
            case .failure(let error):
                completionBlock(nil, error)
            }
        })
    }
    
    // API to Download Image from Server using Alamofire

    func downloadImage(with imageURL: String, completionBlock: @escaping TaskCompletionHandler)-> Void {
        AF.download(imageURL).responseData(completionHandler: { response in
            
             switch response.result {
            
             case .success(let imageData):
                 completionBlock(imageData, nil)

             case .failure(let error):
                 completionBlock(nil, error)
            }

        })
    }
}
