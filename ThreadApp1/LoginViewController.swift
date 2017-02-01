//
//  LoginViewController.swift
//  ThreadApp1
//
//  Created by Vishwajeet Dagar on 1/31/17.
//  Copyright © 2017 Vishwajeet. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var navibar: UINavigationItem!
    lazy var tableViewController: TableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        return secondVC
    }()
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        let permissions = ["public_profile","user_photos","user_posts"]
        loginManager.logIn(withReadPermissions: permissions, from: self, handler:{ (result, error) in
            if let error = error {
                    print("error = \(error.localizedDescription)")
                }
            else if (result! as FBSDKLoginManagerLoginResult).isCancelled {
                print("user tapped on Cancel button")
            }
            else{
                print("authenticate successfully")
                self.goToTableViewController()
                }
            })
    }
    
    func goToTableViewController() {
        self.navigationController?.pushViewController(self.tableViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FBSDKAccessToken.current() != nil {
            goToTableViewController()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
