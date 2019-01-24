//
//  ImageViewModel.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 18/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
//import AlamofireImage



class ImageViewModel: ImageViewModelProtocol {
    var loaderPublisher: PublishSubject<Bool>
    var url: String
    
    init(urlToImage: String) {
        self.loaderPublisher = PublishSubject<Bool>()
        self.url = urlToImage
    }
    
    func downloadImage(){
        let urlToDownload = URL(string: self.url)
        Alamofire.request(urlToDownload!)
            .responseData { (image) in
                let imagesave = image.data as! UIImage
        }
    }
    
    
}

protocol ImageViewModelProtocol {
    var loaderPublisher: PublishSubject<Bool>{get}
}
