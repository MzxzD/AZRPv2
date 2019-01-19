//
//  UIImageView + Extensions.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 18/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//
//
//import Foundation
//import Alamofire
//import RxAlamofire
//import RxSwift
//
//
//extension UIImageView {
//    public func imageFromUrl(urlString: String) {
//        requestData(.get, urlString)
//            .observeOn(MainScheduler.instance)
//            .subscribeOn { self.image = UIImage(data: $0) }
//    }
//}
