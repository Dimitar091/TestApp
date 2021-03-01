//
//  SingInViewController.swift
//  TestApp
//
//  Created by Dimitar on 18.1.21.
//

import UIKit
import Firebase
import FirebaseAuth

class SingInViewController: UIViewController {
    
    @IBOutlet weak var emailHolder: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var passwordHolder: UIView!
    @IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func onSingin(_ sender: Any) {
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
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
            if let error = error {
                let specificError = error as NSError
               
                if specificError.code == AuthErrorCode.invalidEmail.rawValue && specificError.code == AuthErrorCode.wrongPassword.rawValue {
                    self.showErrorWith(title: "Error", msg: "Incorect email or password")
                    return
                }
                
                if specificError.code == AuthErrorCode.userDisabled.rawValue {
                    self.showErrorWith(title: "Error", msg: "You account was disabled")
                    return
                }
                
                self.showErrorWith(title: "Error", msg: error.localizedDescription)
                return
            }
            
            if let authResult = authResult {
                self.getLocalUserData(uid: authResult.user.uid)
            }
        }
    }
    func getLocalUserData(uid: String) {
        DataStore.shared.getUser(uid: uid) { (user, error) in
            if let error = error {
                self.showErrorWith(title: "Error", msg: error.localizedDescription)
                return
            }
            
            if let user = user {
                DataStore.shared.localUser = user
                self.continuteToHome()
                return
            }
        }
    }
    
    func showErrorWith(title: String?, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func onCreateNewAcc(_ sender: Any) {
        performSegue(withIdentifier: "newAcc", sender: nil)
    }
    func continuteToHome() {
        performSegue(withIdentifier: "HomeView", sender: nil)
        navigationController?.popToRootViewController(animated: false)
    }
    
}
extension SingInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
