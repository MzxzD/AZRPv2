//
//  BaseRepositoryProtocol.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 11/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import Foundation
import Alamofire
protocol BaseRepositoryProtocol {

}
/**
 Extension that enables you to create global code for Repositories. Place here code for common actions - like creating API key param.
 
 Example of method:
 
 internal func createRequestParams() -> Parameters {
 var params = Parameters()
 params["api_token"] = RestEndpoints.API_TOKEN
 
 return params
 }
 */
extension BaseRepositoryProtocol {
    
}
