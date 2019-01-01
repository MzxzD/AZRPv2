//
//  TableRefresh.swift
//  ePetrokemija
//
//  Created by Matija Solić on 12/06/2018.
//  Copyright © 2018 ePetrokemija. All rights reserved.
//

import UIKit

enum TableRefresh {
    case complete
    case reloadRows(indexPaths: [IndexPath])
    case updateRows(indexPaths: [IndexPath])
    case section(section: Int, withAnimation: UITableView.RowAnimation )
    case addRows(indexPaths: [IndexPath], withAnimation: UITableView.RowAnimation)
    case removeRows(indexPaths: [IndexPath], withAnimation: UITableView.RowAnimation)
    case addSection(withIndex:Int)
    case removeSection(withIndex:Int)
    case dontRefresh
    case multipleActions(removeIndexes:[IndexPath], addIndexes:[IndexPath],modifiedIndexes:[IndexPath])
}
