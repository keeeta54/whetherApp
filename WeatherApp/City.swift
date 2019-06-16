//
//  City.swift
//  WeatherApp
//
//  Created by 梶原敬太 on 2019/06/15.
//  Copyright © 2019 梶原敬太. All rights reserved.
//

import Foundation
import SwiftyJSON

class City{
    let id: String //ID
    let title: String //市区町村名
    
    init (city: JSON){
        id = city["id"].stringValue
        title = city["title"].stringValue
    }
}
