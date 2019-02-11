//
//  DismissKeyboardModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 25/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit

extension UIViewController {
        func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    }

