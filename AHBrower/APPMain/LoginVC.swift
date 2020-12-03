//
//  LoginVC.swift
//  AHBrower
//
//  Created by paydrin on 2018/11/27.
//  Copyright © 2018 jacky.he. All rights reserved.
//

import UIKit

class LoginVC: UIViewController , UITextFieldDelegate{

    
    @IBOutlet weak var loginTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTF.delegate = self
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil && textField.text?.count == 4 && textField.text == "5555" {
            textField.resignFirstResponder()
            
            let nv = UINavigationController.init(rootViewController: MainListVC())
            
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window?.rootViewController = nv
            return true
        }
        return false
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
