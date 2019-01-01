//
//  LoaderOverlayView.swift
//  ePetrokemija
//
//  Created by Matija Solić on 05/07/2018.
//  Copyright © 2018 ePetrokemija. All rights reserved.
//

import UIKit
class LoaderOverlayView : UIView {
    let spinnerView: SpinnerView!

    override init(frame: CGRect) {
        let realFrame = UIScreen.main.bounds
        spinnerView = SpinnerView(frame: CGRect(origin: realFrame.origin, size: CGSize(width: LoaderHUD.LOADER_SIZE, height: LoaderHUD.LOADER_SIZE)))
        super.init(frame: realFrame)
        backgroundColor = .clear
        spinnerView.center = center
        addSubview(spinnerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
