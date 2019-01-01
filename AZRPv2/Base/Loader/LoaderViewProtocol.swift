//
//  LoaderViewProtocol.swift
//  ePetrokemija
//
//  Created by Matija Solić on 04/07/2018.
//  Copyright © 2018 ePetrokemija. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
protocol LoaderViewProtocol: class{
    var disposeBag: DisposeBag {get}
    func showLoader()
    func dismissLoader()
}
extension  LoaderViewProtocol where Self: UIViewController {
    func showLoader(){
        LoaderHUD.showLoader(viewController: self)
    }
    
    func dismissLoader(){
        LoaderHUD.dismissLoader(viewController: self)
    }
    
    func initializeLoaderObserver(_ loaderObservable: Observable<Bool>){
        loaderObservable
            .asDriver(onErrorJustReturn: false)
            .do(onNext: { [unowned self] (showLoader) in
                if(showLoader){
                    self.showLoader()
                }else {
                    self.dismissLoader()
                }
            })
        .drive()
        .disposed(by: disposeBag)
    }
}
