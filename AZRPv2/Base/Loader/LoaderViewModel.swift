//
//  LoaderViewModel.swift
//  ePetrokemija
//
//  Created by Matija Solić on 04/07/2018.
//  Copyright © 2018 ePetrokemija. All rights reserved.
//

import Foundation
import RxSwift
protocol LoaderViewModelProtocol {
    var loaderPublisher: PublishSubject<Bool> {get}
}
