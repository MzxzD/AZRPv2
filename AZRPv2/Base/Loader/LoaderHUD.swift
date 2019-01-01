//
//  LoaderHUD.swift
//  ePetrokemija
//
//  Created by Matija Solić on 05/07/2018.
//  Copyright © 2018 ePetrokemija. All rights reserved.
//

import Foundation
import UIKit
class LoaderHUD {
    static let LOADER_SIZE = CGFloat(44)
    private static let loaderView : LoaderOverlayView = {
        return LoaderOverlayView()
    }()
    static func showLoader(viewController: UIViewController){
  
        if let superview = loaderView.superview {
            if( superview == viewController.view) {
                return  //noting to do here as we are already showing loader.
            }else{
                loaderView.removeFromSuperview()
            }
            
        }
        viewController.view.addSubview(loaderView)
        loaderView.spinnerView.animate()
        
    }
    static func dismissLoader(viewController: UIViewController){
            loaderView.spinnerView.stopAnimation()
            loaderView.removeFromSuperview()
    }
}
