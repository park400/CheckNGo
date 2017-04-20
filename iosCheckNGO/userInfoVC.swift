//
//  userInfoVC.swift
//  iosCheckNGO
//
//  Created by Minwoo Park on 3/27/17.
//  Copyright © 2017 Ignite. All rights reserved.
//

import UIKit
var sendingAmount = ""
class userInfoVC: UIViewController {

    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var budgetAmount: UILabel!
    
    
    
    override func viewDidLoad() {
        print("sending: \(sendingEmail)")
       
        super.viewDidLoad()
        
        getAllUserInfo()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func getAllUserInfo(){
        let urlString = "http://cgi.soic.indiana.edu/~team40/allUserInfo.php"
//        print(urlString)
        let allUsersURL = URL(string: urlString)!
        let request = URLRequest(url: allUsersURL)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            func displayError(_ error: String) {
                print(error)
                print("URL at time of error: \(allUsersURL)")
                
            }
            
            if error == nil {
                
                // there was data returned
                if let data = data {
                    
                    let parsedResult: [String:AnyObject]!
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    } catch {
                        displayError("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                    let userDictionary = parsedResult["users"] as! NSArray
//                    print(userDictionary)
                    let totalindexNumber = Int((userDictionary.count)) - 1
                    var emailArray:[String] = []
                    var firstNameArray:[String] = []
                    var lastNameArray:[String] = []
                    var budgetArray:[String] = []
                        for i in 0...totalindexNumber {
                            let allData = userDictionary[i] as! [String:AnyObject]
                            emailArray.append(allData["EmailAddress"]! as! String)
                            firstNameArray.append(allData["FirstName"]! as! String)
                            lastNameArray.append(allData["LastName"]! as! String)
                            budgetArray.append(allData["BudgetAmount"]! as! String)
                            
                            }
                    
                    if emailArray.contains(sendingEmail) {
                        let searchingIndex = Int(emailArray.index(of: sendingEmail)!)

                        performUIUpdatesOnMain {
                            self.firstName.text! = firstNameArray[searchingIndex]
                            self.lastName.text! = lastNameArray[searchingIndex]
                            self.emailAddress.text! = emailArray[searchingIndex]
                            self.budgetAmount.text! = "$\(budgetArray[searchingIndex])"
                          
                            }
                       
                        }
                    

                    }
                    
                    
                    
                    
                  
                    
                    
                }
        }
        task.resume()

        
        }

    }



