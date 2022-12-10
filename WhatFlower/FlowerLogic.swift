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
        let wikiURL = "https://en.wikipedia.org/w/api.php"
        let flowerName = flower.replacingOccurrences(of: " ", with: "%")
        
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
        
        var flowerURL = wikiURL + "&"
        for parameter in parameters {
            flowerURL += parameter.key + "=" + parameter.value + "&"
        }
    }
}
