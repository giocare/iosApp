//  LoginViewController.swift
//  TalentedApp
//
//  Created by jess on 4/24/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import Foundation

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var contactPointTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    
    @objc func didTapLoginButton() {
        let loginManager = FirebaseAuthManager()
        guard let email = contactPointTextField.text, let password = passwordTextField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                message = "User was sucessfully logged in."
                print(message)
                print("Presenting from Login")
                self.performSegue(withIdentifier: "myLoginTransition", sender: nil)
            } else {
                message = "There was an error."
                print(message)
            }

        }
    }


    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}
