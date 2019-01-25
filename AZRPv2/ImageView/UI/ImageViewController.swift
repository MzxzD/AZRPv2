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
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewModel: ImageViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.initializeData()
//        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.downloadImage()

    }
    
    
    private func initializeData(){
        initializeLoaderObserver(viewModel.loaderPublisher)
        self.viewModel.startLoader()
        let imageIsReady = viewModel.imageIsReady
        imageIsReady
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                self.imageView.image = self.viewModel.image
                self.setupView()
            })
            .disposed(by: disposeBag)
    }
    
    
   
    
    
    
    
    
    
    
    
    private func setupView(){
        view.addSubview(imageView)
//        imageView.bounds = view.bounds
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        self.imageView.image = viewModel.image
    }
}
