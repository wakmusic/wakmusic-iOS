//
//  LoadingAlertControllerType.swift
//  CommonFeature
//
//  Created by KTH on 2023/05/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public protocol LoadingAlertControllerType: AnyObject {
    var alertController: UIAlertController! { get set }
}

public extension LoadingAlertControllerType where Self: UIViewController {
    func startLoading(message: String) {
        DispatchQueue.main.async {
            self.alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
            self.present(self.alertController, animated: true)
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.alertController.dismiss(animated: true)
        }
    }
}
