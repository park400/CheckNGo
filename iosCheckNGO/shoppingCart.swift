//
//  shoppingCart.swift
//  iosCheckNGO
//
//  Created by Minwoo Park on 3/29/17.
//  Copyright © 2017 Ignite. All rights reserved.
//

import UIKit




var totalSpending = Double()
   
var transactionDate = ""
class shoppingCart: UIViewController, UITableViewDelegate, UITableViewDataSource, PayPalPaymentDelegate {
    
    @IBOutlet weak var naviButton: UIBarButtonItem!
    
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
        
    }
    
 
    
    
    
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var shoppingCartTable: UITableView!
    var totalCost = 0.00
    
    
    
    var scannedQty:[Int] = []
    var scannedTotal:[String] = []
    var cartName:[String] = []
    var cartPrice:[String] = []
    
  
    
    
 

    override func viewDidLoad(){
        super.viewDidLoad()
        
        naviButton.isEnabled = false
        // Set up payPalConfig
        
        
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "Ignite, Inc." // Can be my ailias compay
        
        //privacy policy
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        //the language of Paypal ios sdk
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        //use the address which is registered in PayPAl
        payPalConfig.payPalShippingAddressOption = .none

        
        shoppingCartTable.delegate = self
        shoppingCartTable.dataSource = self
        cartName = scannedName
        cartPrice = scannedPrice
        
        
        for element in scannedPrice {
            
                self.scannedQty.append(1)
                self.scannedTotal.append(element)
            
            
            
        }
        print(cartName)
        print(cartPrice)
        print(scannedQty)
        print(scannedTotal)
        
        
        for element in scannedPrice{
            totalCost += Double(element)!
        }
        
        let finalValue = String(format:"%.2f", totalCost)
        
        grandTotal.text! = "$\(finalValue)"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
      

        
    }

    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        
        performUIUpdatesOnMain {
            
            
            
            let confirmAlert = UIAlertController(title: "Payment Confirmation", message:
                "", preferredStyle:.alert)
            confirmAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            self.present(confirmAlert, animated: true, completion: {()->Void in
            
               self.naviButton.isEnabled = true
                
            })
            
        }
       
        
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        transactionDate = "\(month)/\(day)/\(year) \(hour):\(minute):\(second)"
        print(transactionDate)
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
            
        })
    }

    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            
            return scannedTotal.count
    }
        
    
        
       
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
            let cell =  shoppingCartTable.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! CustomCell
            cell.productName.text = cartName[indexPath.row]
            cell.price.text = "$\(cartPrice[indexPath.row])"
            cell.quantity.text = String(scannedQty[indexPath.row])
            cell.total.text = "$\(scannedTotal[indexPath.row])"
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        cartName = scannedName
        cartPrice = scannedPrice
        
        if editingStyle == .delete{
            
         
                self.cartName.remove(at: indexPath.row)
                self.cartPrice.remove(at: indexPath.row)
                self.scannedQty.remove(at: indexPath.row)
                self.scannedTotal.remove(at: indexPath.row)
                self.shoppingCartTable.reloadData()
                print("AfterDelete product:\(cartName)")
                print("AfterDelete price:\(cartPrice)")
                print("AfterDelete qty:\(scannedQty)")
                print("AfterDelete total:\(scannedTotal)")
            
            var afterDeleteTotalPrice = 0.00
            for element in scannedTotal{
                afterDeleteTotalPrice += Double(element)!
                
            }
            if scannedTotal.count == 0{
                self.grandTotal.text! = "$"+String(format:"%.2f", afterDeleteTotalPrice)
            }else{
                self.grandTotal.text! = "$"+String(format:"%.2f", afterDeleteTotalPrice)
            }
            
            totalSpending = afterDeleteTotalPrice
            
            print(afterDeleteTotalPrice)
            
            
            if scannedTotal.count == 0 {
                self.tabBarController?.tabBar.items?[1].badgeValue = nil
            }else{self.tabBarController?.tabBar.items?[1].badgeValue = String(scannedTotal.count)

            }
            
            
            
            
        
        }
    }
    
    @IBAction func checkOutClicked(_ sender: Any) {

   
//        transactionDate = String(Date().description(with: Locale.current))
       
        
        

        self.tabBarController?.tabBar.items?[1].badgeValue = nil
        

            var items = [Any]()
            for i in 0...cartName.count-1 {
                let item = PayPalItem(name: scannedName[i], withQuantity: UInt(scannedQty[i]), withPrice: NSDecimalNumber(string: scannedPrice[i]), withCurrency: "USD", withSku: nil)
                items.append(item)
                
            }

            let subtotal = PayPalItem.totalPrice(forItems: items)
  
            
            let finalTax = String(describing: (subtotal as Decimal) * 0.07)
            let twodecimalTax = String(format:"%.2f", finalTax)
            print(finalTax)
            let tax = NSDecimalNumber(string: twodecimalTax)
  
            let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: nil, withTax: tax)
            
            let total = subtotal.adding(tax)
            
            let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Chroger", intent: .sale)
            
            payment.items = items
            payment.paymentDetails = paymentDetails
            
            if (payment.processable) {
                let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: self.payPalConfig, delegate: self)
                present(paymentViewController!, animated: true, completion: nil)
                
            }
            else {
             
                print("Payment not processalbe: \(payment)")
            }
     
            
            
            
        }
    
    func showPopup() {
    
        
    }
        

}


    



    


    





