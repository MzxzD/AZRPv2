//
//  Double + extensions.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 01/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .full
        
        return dateFormatter.string(from: date)
    }
    
    

}


public func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date as Date)
    }
    
  public func dayStringFromTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.current.identifier) as Locale
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date as Date)
    }

