//
//  ViewController.swift
//  TestApp
//
//  Created by Dimitar on 9.1.21.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import AuthenticationServices

class ViewController: UIViewController {

    @IBOutlet weak var emailHolder: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var passwordHolder: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showErrorWith(title: String?, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    
    func getLocalUserData(uid: String) {
        DataStore.shared.getUser(uid: uid) { (user, error) in
            if let error = error {
                self.showErrorWith(title: "Error", msg: error.localizedDescription)
                return
            }
            
            if let user = user {
                DataStore.shared.localUser = user
                self.continueToHomeScreen()
                
            }
        }
    }
    
    func userDidLogin(token: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let authResult = authResult {
                let user = authResult.user
                print(user)
                self.getLocalUserData(uid: user.uid)
            }
        }
    }
    func continueToHomeScreen() {
        performSegue(withIdentifier: "HomeView", sender: nil)
    }

    @IBAction func onFacebook(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(permissions: ["public_profile","email"], from: self) { (loginResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let result = loginResult, !result.isCancelled, let token = result.token {
                    self.userDidLogin(token: token.tokenString)
                } else {
                    print("User Canceled flow")
                }
            }
        }
    }
    
    @IBAction func onEmail(_ sender: Any) {
        performSegue(withIdentifier: "logniSegue", sender: nil)
    }
}

