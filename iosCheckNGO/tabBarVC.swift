//
//  tabBarVC.swift
//  iosCheckNGO
//
//  Created by Minwoo Park on 4/3/17.
//  Copyright © 2017 Ignite. All rights reserved.
//

import UIKit

class tabBarVC: UITabBarController, UITabBarControllerDelegate {
    
  
    
    override func viewDidLoad() {
        self.delegate=self
        super.viewDidLoad()
//        self.tabBarController?.selectedIndex = 0
        let arrayOfTabBarItems = self.tabBar.items
        //initial state
        
        if let barItems = arrayOfTabBarItems, barItems.count > 0 {
            let tabBarItem = barItems[1]
            tabBarItem.isEnabled = false
            print("disabled shopping Cart")
        }
        
     
    }
    
    

    
    
    override func viewWillAppear(_ animated: Bool) {
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    






}
