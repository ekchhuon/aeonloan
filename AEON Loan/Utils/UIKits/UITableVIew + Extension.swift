//
//  UITableVIew + Extension.swift
//  AEON Loan
//
//  Created by aeon on 9/22/20.
//

import UIKit

extension UITableView {
    func register<T>(nibName cell: T) {
        let name = String(describing: cell.self)
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
}
