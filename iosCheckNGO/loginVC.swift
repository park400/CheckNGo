//
//  loginVC.swift
//  iosCheckNGO
//
//  Created by Minwoo Park on 3/27/17.
//  Copyright © 2017 Ignite. All rights reserved.
//

import UIKit

var sendingEmail = ""
class loginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailText: UITextField!
 
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
  
    


    
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
         sendingEmail = emailText.text!
        
      
  
        if emailText.text!.isEmpty || passwordText.text!.isEmpty
        {
            emailText.attributedPlaceholder = NSAttributedString(string:"username@email.com", attributes: [NSForegroundColorAttributeName:UIColor.red])
            
            passwordText.attributedPlaceholder = NSAttributedString(string:"password", attributes: [NSForegroundColorAttributeName:UIColor.red])
            
            let alertController = UIAlertController(title: "Login Error", message:
                "No empty entries allowed", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        else{
        
            let urlString = "http://cgi.soic.indiana.edu/~team40/iosLogin.php?EmailAddress=\(emailText.text!)&Password=\(passwordText.text!)"
            //print(urlString)
            let loginURL = URL(string: urlString)!
            let request = URLRequest(url: loginURL)
            let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
                
                func displayError(_ error: String) {
                    print(error)
                    print("URL at time of error: \(loginURL)")
                  
                }
               
                if error == nil {
                    
                    // there was data returned
                    if let data = data {
                        
                        let parsedResult: [String:String]!
                        do {
                            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:String]
                        } catch {
                            displayError("Could not parse the data as JSON: '\(data)'")
                            return
                        }
                        
                        if parsedResult["message"]! == "Incorrect Password"{
                            performUIUpdatesOnMain {
                                 self.statusLabel.text! = "1"
                                if self.statusLabel.text! == "1"{
                                    
                                    let alertController = UIAlertController(title: "Login Error", message:
                                        "Incorrect Password", preferredStyle:.alert)
                                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                    }
                                }
                                
                                
                            }
                         
                        if parsedResult["message"]! == "Email Address does not exist."{
                            
                         
                            performUIUpdatesOnMain {
                                self.statusLabel.text! = "2"
                                if self.statusLabel.text! == "2" {
                                    
                                let alertController = UIAlertController(title: "Login Error", message:
                                    "There is no such Email Address.", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                                
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }
                        
                        if parsedResult["message"]! == "Login success."{
                            performUIUpdatesOnMain {
                            self.statusLabel.text! = "3"
                            if self.statusLabel.text! == "3"{
                                    self.performSegue(withIdentifier: "loginSuccess", sender: self)
                                }
                            
                         
                        
                            }
                    
                        }
    
                        }
                }
            }
        task.resume()
        }
        
      
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        emailText.delegate = self
        passwordText.delegate = self
        
  
        
    
   
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailText{
            self.passwordText.becomeFirstResponder()
        }else{
            self.passwordText.resignFirstResponder()
        }
        return false
    }

    

        // Do any additional setup after loading the view.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.view.center = CGPoint(x: self.view.frame.width/2, y: (self.view.frame.height/2) - 200)
        }, completion: {
            (finished:Bool) in
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.view.center = CGPoint(x: self.view.frame.width/2, y: (self.view.frame.height/2))
        }, completion: {
            (finished:Bool) in
        })
    }


}
