//
//  CreateAccountViewController.swift
//  TestApp
//
//  Created by Dimitar on 18.1.21.
//

import UIKit
import Firebase


class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailHolder: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var passworkHolder: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var genderHolder: UIView!
    @IBOutlet weak var txtGender: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showErrorWith(title: String?, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onFeed(_ sender: Any) {
        guard let email = txtEmail.text, email != "" else {
            showErrorWith(title: "Error", msg: "Please enter your email")
            return
        }
        
        guard let pass = txtPassword.text, pass != "" else {
            showErrorWith(title: "Error", msg: "Please enter password")
            return
        }
        
        guard email.isValidEmail() else {
            showErrorWith(title: "Error", msg: "Please enter a valid email")
            return
        }
        
        guard pass.count >= 6 else {
            showErrorWith(title: "Error", msg: "Password must contain at least 6 characters")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
            if let error = error {
                let specificError = error as NSError
               
                if specificError.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.showErrorWith(title: "Error", msg: "Email already in use!")
                    return
                }
                
                if specificError.code == AuthErrorCode.weakPassword.rawValue {
                    self.showErrorWith(title: "Error", msg: "Your password is too weak")
                    return
                }
                
                self.showErrorWith(title: "Error", msg: error.localizedDescription)
                return
            }
            
            if let authResult = authResult {
                self.saveUser(uid: authResult.user.uid)
            }
        }

    }
    func saveUser(uid: String) {
        let user = User(id: uid)
        DataStore.shared.setUserData(user: user) { (success, error) in
            if let error = error {
                self.showErrorWith(title: "Error", msg: error.localizedDescription)
                return
            }
            
            if success {
                DataStore.shared.localUser = user
                return
            }
        }
    }

    
}
