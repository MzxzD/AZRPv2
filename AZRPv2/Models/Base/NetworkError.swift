//
//  NetworkError.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 10/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case parseFailed
    case empty
    case generalError
}
