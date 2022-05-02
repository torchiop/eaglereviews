//
//  UIBarButtonItem+hide.swift
//  Snacktacular
//
//  Created by Peter Torchio on 4/11/22.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}
