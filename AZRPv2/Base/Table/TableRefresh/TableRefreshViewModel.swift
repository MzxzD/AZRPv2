//
//  TableRefreshViewModel.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 01/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import RxSwift
protocol TableRefreshViewModelProtocol {
    var refreshView: PublishSubject<TableRefresh> {get}
}
