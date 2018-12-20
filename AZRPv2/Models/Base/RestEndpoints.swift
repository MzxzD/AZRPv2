//
//  RestResource.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 10/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
// Info about backend : https://app.productive.io/1139-plava-tvornica/projects/11398/tasks/boards/11135/m/task/167050?filter=LTE%3D
//

import Foundation
/**
 Enum that stores all API Endpoints.
 
 Example of proper written EndpointEnum:
 
 enum RestEndpoints{
 static let ENDPOINT: String = Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"] as! String
 case index
 case article(articleId: Int)
 func endpoint() -> String {
 
 switch self {
 case .index:
 return RestEndpoints.ENDPOINT+"index"

 case .article(let articleId):
 return RestEndpoints.ENDPOINT+"clanak/\(articleId)"
 }
 }
 
 */
enum RestEndpoints{
    static let ENDPOINT: String = Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"] as! String

    func endpoint() -> String {
        
        switch self {
        
        }
    }
}
