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
import AlamofireImage



class ImageViewModel: ImageViewModelProtocol {
    var loaderPublisher: PublishSubject<Bool>
    var url: String
    var image: Image
    var imageIsReady: ReplaySubject<Bool>
    
    init(urlToImage: String) {
        self.loaderPublisher = PublishSubject<Bool>()
        self.url = urlToImage
        self.image = Image()
        self.imageIsReady = ReplaySubject<Bool>.create(bufferSize: 1)
    }
    func startLoader(){
        self.loaderPublisher.onNext(true)

    }
    
    
    func downloadImage(){
        let urlToDownload = URL(string: self.url)
        Alamofire.request(urlToDownload!)
            .responseImage(completionHandler: { (response) in
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    self.image = image
                    self.loaderPublisher.onNext(false)
                    self.imageIsReady.onNext(true)
                }
            })
    }
    
    
}

protocol ImageViewModelProtocol {
    var loaderPublisher: PublishSubject<Bool>{get}
    var image: Image {get}
    func downloadImage()
    func startLoader()
    var imageIsReady: ReplaySubject<Bool> {get}
}
