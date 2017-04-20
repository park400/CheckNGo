//
//  budgetLimitVC.swift
//  iosCheckNGO
//
//  Created by Minwoo Park on 4/2/17.
//  Copyright © 2017 Ignite. All rights reserved.
//

import UIKit
import Alamofire


var totalSpent = 0.00
class budgetLimitVC: UIViewController {
    
    @IBOutlet weak var budgetInfo: UILabel!
    @IBOutlet weak var totalBudget: UILabel!

    override func viewDidLoad() {
    
        super.viewDidLoad()
        getAllUserInfo()
        
        postToTransaction()
        retrieveTotalSum()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postToTransaction()
    
        
    {   for element in scannedPrice{
        
            totalSpent += Double(element)!
        }
            let urlString = "http://cgi.soic.indiana.edu/~team40/iosTransaction.php"
            let transactionURL = URL(string: urlString)!
            var request = URLRequest(url: transactionURL)
            request.httpMethod = "POST"
            let postString = "EmailAddress=\(sendingEmail)&TotalSpent=\(totalSpent)"
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            print(postString)
            let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
                
                func displayError(_ error: String) {
                    print(error)
                    print("URL at time of error: \(transactionURL)")
                    
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
    
    func retrieveTotalSum(){
    
    
        let urlString = "http://cgi.soic.indiana.edu/~team40/totalSpent.php"

        let allProductsURL = URL(string: urlString)!
        let request = URLRequest(url: allProductsURL)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            func displayError(_ error: String) {
                print(error)
                print("URL at time of error: \(allProductsURL)")
                
            }
            
            if error == nil {
                
                // there was data returned
                if let data = data {
                    
                    let parsedResult: [AnyObject]
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [AnyObject]
                    } catch {
                        displayError("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                   
                    let totalIndexNumber = (parsedResult.count - 1)
                    var emailArray:[String] = []
                    var totalArray:[Double] = []
                    for i in 0...totalIndexNumber{
                        let allData = parsedResult[i] as! [String:AnyObject]
                        emailArray.append(allData["EmailAddress"] as! String)
                        totalArray.append(allData["Totalsum"] as! Double)
                    }
                    print(totalArray)
                    if emailArray.contains(sendingEmail) {
                        let searchingIndex = Int(emailArray.index(of: sendingEmail)!)
                        performUIUpdatesOnMain {
                            self.budgetInfo.text! = "$\(totalArray[searchingIndex])"
                        }
                      
                        
                    }

                
                    
                    
                }
            }
        }
        task.resume()
    }

  func getAllUserInfo(){
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
                            
                            sendingAmount = budgetArray[searchingIndex]
                            self.totalBudget.text! = "$\(sendingAmount)"
                            
                        }
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
            }
        }
        task.resume()
        
        
    }

}
