//
//  FlowerLogic.swift
//  WhatFlower
//
//  Created by Yuriy Gudimov on 10.12.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

struct FlowerLogic {
    
    func requestInfo(for flower: String, completion: @escaping ((String, String?)) -> Void) {

        guard let flowerURLString = createURL(with: flower) else {
            fatalError("Unable to create valid URL with flower")
        }
        
        AF.request(flowerURLString).response { response in
            guard let result = response.data else {
                fatalError("Couldn't get response.data with Alamofire")
            }
            completion(self.parseJSON(with: result))
        }
    }
    
    func parseJSON(with data: Data) -> (String, String?) {
        
        guard let json = try? JSON(data: data) else {
            fatalError("Couldn't get JSON while parsing the result")
        }
        
        let pathToPageID: [JSONSubscriptType] = ["query", "pageids"]
        guard let pageID = json[pathToPageID].first?.1.stringValue else {
            fatalError("Couldn't get pageID")
        }
        
        let pathToDescription: [JSONSubscriptType] = ["query", "pages", pageID, "extract"]
        
        if let description = json[pathToDescription].string {
            if let photoURLString = json["query"]["pages"][pageID]["thumbnail"]["source"].string {
                return (description, photoURLString)
            } else {
                return (description, nil)
            }
        } else {
            print(json[pathToDescription].error!)
        }
        return ("Wikipedia has no description for this.", nil)
    }
    
    
    
    fileprivate func createURL(with flower: String) -> String? {
        let wikiURL = "https://en.wikipedia.org/w/api.php"
        let flowerName = flower.replacingOccurrences(of: " ", with: "%20")
        
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts%7Cpageimages",
            "exintro" : "",
            "explaintext" : "",
            "indexpageids" : "",
            "redirects" : "1",
            "titles" : flowerName,
            "pithumbsize" : "500"
        ]
        
        var flowerURLString = wikiURL + "?&"
        for parameter in parameters {
            flowerURLString += parameter.key + "=" + parameter.value + "&"
        }
        
        return flowerURLString
    }
}
