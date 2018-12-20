//
//  SerializationManager.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 26/09/2018.
//  Copyright © 2018 Avaz. All rights reserved.
//

import Foundation
class SerializationManager {
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .deferredToData
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .deferredToData
        return encoder
    }()
    
    static func parseData<T: Codable>(jsonString: String) -> T?{
        guard let jsonData = jsonString.data(using: .utf8)
            else {
                return nil
        }
        return parseData(jsonData: jsonData)
    }
    
    static func parseData<T: Codable>(jsonData: Data) -> T?{
        let object: T?
        do {
            object = try jsonDecoder.decode(T.self, from: jsonData)
            
        }catch let error {
            debugPrint("Error while parsing data from server. Received dataClassType: \(T.self). More info: \(error)")
            object=nil
        }
        return object
    }
    
    static func encodeToJson<T: Codable>(codableData: T) -> String?{
        let jsonString: String?
        do {
            let jsonData = try jsonEncoder.encode(codableData)
            jsonString = String(data: jsonData, encoding: .utf8)
            
        }catch let error {
            debugPrint("Error while encoding data to JSON. Received dataClassType: \(T.self). More info: \(error)")
            jsonString = nil
        }
        return jsonString
    }
}
