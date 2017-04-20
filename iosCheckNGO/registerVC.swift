//
//  registerVC.swift
//  iosCheckNGO
//
//  Created by Minwoo Park on 3/27/17.
//  Copyright © 2017 Ignite. All rights reserved.
//

import UIKit
import Alamofire

var sendingFromRegister = ""
class registerVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailRegister: UITextField!
    @IBOutlet weak var passwordRegister: UITextField!
    @IBOutlet weak var passwordConfirmRegister: UITextField!
    @IBOutlet weak var budgetRegister: UITextField!
 
    @IBOutlet weak var firstNameRegister: UITextField!
    @IBOutlet weak var lastNameRegister: UITextField!
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    let URL_USER_REGISTER = "http://cgi.soic.indiana.edu/~team40/Register2.php"
    
    private func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        sendingFromRegister = emailRegister.text!
        if firstNameRegister.text!.isEmpty || lastNameRegister.text!.isEmpty || emailRegister.text!.isEmpty || passwordConfirmRegister.text!.isEmpty || passwordRegister.text!.isEmpty || budgetRegister.text!.isEmpty
        {
            
            
            let alertController = UIAlertController(title: "Register Error", message:
                "No empty entries allowed", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            
            
        }
        
        
        else if isValidEmail(testStr: emailRegister.text!) == false{
            
            let alertController = UIAlertController(title: "Register Error", message:
                "Invalid Email Address", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        else if passwordRegister.text! != passwordConfirmRegister.text! {
        
            let alertController = UIAlertController(title: "Register Error", message:
                "Password does not match!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            let parameters: Parameters=[
                "EmailAddress":emailRegister.text!,
                "Password":passwordRegister.text!,
                "FirstName":firstNameRegister.text!,
                "LastName":lastNameRegister.text!,
                "BudgetAmount":budgetRegister.text!
                            ]
            
            //Sending http post request
            Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    //printing response
                    print(response)
                    
                    //getting the json value from the server
                    if let result = response.result.value {
                        
                        //converting it as NSDictionary
                        let jsonData = result as! NSDictionary
                        
                        //displaying the message in label
                       print(jsonData.value(forKey: "message") as! String!)
                    }
            }
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        keyboardSetting()
//        emailRegister.delegate = self
//        passwordRegister.delegate = self
//        passwordConfirmRegister.delegate = self
        firstNameRegister.delegate = self
        lastNameRegister.delegate = self
        budgetRegister.delegate = self
//        emailRegister.tag = 0
//        passwordRegister.tag = 1
//        passwordConfirmRegister.tag = 2
//        firstNameRegister.tag = 3
//        lastNameRegister.tag = 4
//        budgetRegister.tag = 5
        
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func keyboardSetting() {
        budgetRegister.delegate = self
        budgetRegister.keyboardType = UIKeyboardType.decimalPad
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        

        self.firstNameRegister.resignFirstResponder()

        return true
            
    
        
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

