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
    
    func parseJSON(for flower: String) {
        guard let flowerURL = createURL(with: flower) else {
            fatalError("Unable to create valid URL with flower")
        }
        
        AF.request(flowerURL).response { response in
            guard let result = response.data else {
                fatalError("Couldn't get response.data with Alamofire")
            }
            self.parse1JSON(with: result)
        }
    }
    
    func parse1JSON(with data: Data) {
        guard let json = try? JSON(data: data) else {
            fatalError("Couldn't get JSON while parsing the result")
        }
        
        let pathToPageID: [JSONSubscriptType] = ["query", "pageids"]
        guard let pageID = json[pathToPageID].first?.1.stringValue else {
            fatalError("Couldn't get pageID")
        }
        
        print(pageID)
        
        let pathToDescription: [JSONSubscriptType] = ["query", "pages", pageID, "extract"]
        let description = json[pathToDescription].stringValue

        print(description)
        
    }
    
    
    fileprivate func createURL(with flower: String) -> String? {
        let wikiURL = "https://en.wikipedia.org/w/api.php"
        let flowerName = flower.replacingOccurrences(of: " ", with: "%20")
        
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts",
            "exintro" : "",
            "explaintext" : "",
            "indexpageids" : "",
            "redirects" : "1",
            "titles" : flowerName
        ]
        
        var flowerURLString = wikiURL + "?&"
        for parameter in parameters {
            flowerURLString += parameter.key + "=" + parameter.value + "&"
        }
        
        return flowerURLString
    }
}
