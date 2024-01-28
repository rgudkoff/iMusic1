//
//  UIViewController + Storyboard.swift
//  iMusic
//
//  Created by Роман Гудков on 04.01.2023.
//  Copyright © 2023 Sibilus. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func loadFromStoryBoard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error: No initial view controller in \(name) storuboard")
        }
    }
}
