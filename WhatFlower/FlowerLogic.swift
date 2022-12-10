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
    
    mutating func parseJSON(for flower: String) {
        guard let flowerURL = createURL(with: flower) else {
            fatalError("Unable to create valid URL with flower")
        }
    }
    
    fileprivate func createURL(with flower: String) -> URL? {
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
        print("String =", flowerURLString)
        return URL(string: flowerURLString)
    }
}
