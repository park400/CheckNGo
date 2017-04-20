//
//  userInfoUpdateVC.swift
//  iosCheckNGO
//
//  Created by Minwoo Park on 4/2/17.
//  Copyright © 2017 Ignite. All rights reserved.
//

import UIKit
import Alamofire

class userInfoUpdateVC: UIViewController {
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var firstNameUpdate: UITextField!
    @IBOutlet weak var lastNameUpdate: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddress.text = sendingEmail
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        postToServer()
        
        
//        let parameters: Parameters=[
//            "EmailAddress":emailAddress.text!,
//            
//            "FirstName":firstNameUpdate.text!,
//            "LastName":lastNameUpdate.text!,
//            ]
//         print(firstNameUpdate.text!)
//        //Sending http post request
//        Alamofire.request(URL_USER_UPDATE, method: .post, parameters: parameters).responseJSON
//            {
//                response in
//                //printing response
//                print(response)
//                
//                //getting the json value from the server
//                if let result = response.result.value {
//                    
//                    //converting it as NSDictionary
//                    let jsonData = result as! NSDictionary
//                    
//                    //displaying the message in label
//                    print(jsonData.value(forKey: "message") as! String!)
//                }
//        }
    }

    func postToServer(){
        let urlString = "http://cgi.soic.indiana.edu/~team40/iosUpdateUserInfo.php"
        let updateUserURL = URL(string: urlString)!
        var request = URLRequest(url: updateUserURL)
        request.httpMethod = "POST"
        let postString = "firstName=\(firstNameUpdate.text!)&lastName=\(lastNameUpdate.text!)&emailAddress=\(sendingEmail)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        print(postString)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            func displayError(_ error: String) {
                print(error)
                print("URL at time of error: \(updateUserURL)")
                
            }
            
            if error == nil {
                
                // there was data returned
                if let data = data {
                    
                    let parsedResult:[String:AnyObject]
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String:AnyObject]
                    } catch {
                        displayError("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                    print(parsedResult)
                }
            }
        }
        task.resume()
        
        
        
    }

}
