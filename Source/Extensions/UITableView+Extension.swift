//
//  UITableView+Extension.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 30/8/21.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(fromClass cellType: T.Type) {
        let identifier = String(describing: cellType)
        register(cellType, forCellReuseIdentifier: identifier)
    }
    
    func dequeue<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
}
