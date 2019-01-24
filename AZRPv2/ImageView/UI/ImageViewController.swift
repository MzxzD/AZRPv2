//
//  ImageViewController.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 18/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import UIKit
import RxSwift

class ImageViewController: UIViewController, LoaderViewProtocol {
    var disposeBag = DisposeBag()
    

    
    let imageView :UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    var viewModel: ImageViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    private func initializeData(){
        initializeLoaderObserver(viewModel.loaderPublisher)
    }
    
    private func setupView(){
        view.addSubview(imageView)
        imageView.layer.bounds = view.bounds
    }
}
