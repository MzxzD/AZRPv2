//
//  API.swift
//  UHP zadatak
//
//  Created by Mateo Doslic on 24/10/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire

class APIService {
    
    func fetchDataFromApI(username: String, pass: String) -> Observable<DataWrapper<LogIn>>{
        print("Downloading data...")
        
        let url = "http://0.0.0.0:8000/api/auth/login/"
        
        return RxAlamofire
            .request(.post, url, parameters: ["username": username, "password": pass], encoding: URLEncoding.default , headers: nil)
            .validate(statusCode: 200..<500)
            .responseJSON()
            .map({ (response) -> DataWrapper<LogIn> in
                let decoder = JSONDecoder()
                print(response)
                var APIResponse: LogIn!
                let responseJSON = response.data!
                do {
                    let data = try decoder.decode(LogIn.self, from: responseJSON)
                    APIResponse = data
                }catch {
//                    print(error.localizedDescription)
                    
                    let data = try decoder.decode(ErrorMessage.self, from: responseJSON)
//                    print(data)
                    
                   let errorMessage = data.detail
                    
                    return DataWrapper(data: APIResponse, error: errorMessage)
                }
                
                return DataWrapper(data:APIResponse, error: nil)
            })
    }
    func getUsers(token: String) -> Observable<DataWrapper<Users>> {
        print("Downloading data...")
        
        let url = "http://0.0.0.0:8000/api/auth/users/?token="+token
        
        return RxAlamofire
            .data(.get, url)
            
            .map({ (response) -> DataWrapper<Users> in
                let decoder = JSONDecoder()
                print(response)
                var APIResponse: Users!
                let responseJSON = response
                do {
                    let data = try decoder.decode(Users.self, from: responseJSON)
                    APIResponse = data
                }catch let error {
                    print(error.localizedDescription)
                    return DataWrapper(data: APIResponse, error: error.localizedDescription)
                }
                
                return DataWrapper(data:APIResponse, error: nil)
            })
    }
    
    func getUsers(token: String, searchQuerry: String) -> Observable<DataWrapper<Users>>{
        print("Downloading data...")
        
        let url = "http://0.0.0.0:8000/api/auth/users/?token="+token+"&q="+searchQuerry
        
        return RxAlamofire
            .data(.get, url)
            .map({ (response) -> DataWrapper<Users> in
                let decoder = JSONDecoder()
                print(response)
                var APIResponse: Users!
                let responseJSON = response
                do {
                    let data = try decoder.decode(Users.self, from: responseJSON)
                    APIResponse = data
                }catch let error {
                    print(error.localizedDescription)
                    return DataWrapper(data: APIResponse, error: error.localizedDescription)
                }
                
                return DataWrapper(data:APIResponse, error: nil)
            })
    }
}


