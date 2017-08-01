//
//  Alert.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/08/01.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import UIKit


class Alert {
    let error: Error
    
    init(error: Error) {
        self.error = error
    }
    
    func alertController() -> UIAlertController {
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}
