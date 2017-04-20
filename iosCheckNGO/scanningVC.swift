//
//  scanningVC.swift
//  iosCheckNGO
//
//  Created by Minwoo Park on 3/28/17.
//  Copyright © 2017 Ignite. All rights reserved.
//

import UIKit
import AVFoundation

var resultArray = [String]()

var scannedName: [String] = []
var scannedPrice: [String] = []
//var scannedQty: [Int] = []



class scanningVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var naviBar: UINavigationBar!
    
    var barcodeNumArray:[String] = []
    var priceArray:[String] = []
    var productNameArray:[String] = []
    
  
    
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alertController = UIAlertController(title: "Welcome!", message:
            "Currently Empty Cart", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Scan Product!", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: scanButton)
            view.bringSubview(toFront: naviBar)
           
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
    }
    private func getAllProduct(){
        let urlString = "http://cgi.soic.indiana.edu/~team40/iosAllProducts.php"
//        print(urlString)
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
                    
                    let parsedResult: [String:AnyObject]!
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    } catch {
                        displayError("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                    //print(parsedResult)
                    
                    let productDictionary = parsedResult["products"] as! NSArray
                    let totalindexNumber = Int((productDictionary.count)) - 1
                  
                    for i in 0...totalindexNumber {
                       
                        //performUIUpdatesOnMain {
                            let allData = productDictionary[i] as! [String:AnyObject]
                            self.barcodeNumArray.append(allData["BarcodeNum"]! as! String)
                            self.priceArray.append(allData["Price"]! as! String)
                            self.productNameArray.append(allData["ProductName"]! as! String)
                    }
                            if self.barcodeNumArray.contains(self.messageLabel.text!as String){
                                
                                let searchingIndex: Int = self.barcodeNumArray.index(of: self.messageLabel.text!)!
                                
                                let alert =  UIAlertController(title: "Scanning is successfully Done!", message:
                                    "Would you like to add this item on shopping cart?", preferredStyle:.alert)
                                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default,handler: nil))
                                alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: {(action) -> Void in
                                 
                                    performUIUpdatesOnMain {
                                        
                                        resultArray.append(self.messageLabel.text! as String)
                                        scannedPrice.append(self.priceArray[searchingIndex])
                                        scannedName.append(self.productNameArray[searchingIndex])
                                        
                                      
                                        
                                        
                                        if resultArray.count <= 9 {
                                            self.tabBarController?.tabBar.items?[1].badgeValue = String(resultArray.count)
                                        }else{
                                            self.tabBarController?.tabBar.items?[1].badgeValue = "9+"
                                        }
                                    }
                                    let shoppingCartAlert = UIAlertController(title: nil, message:
                                        "Are you done with scanning?", preferredStyle:.alert)
                                    shoppingCartAlert.addAction(UIAlertAction(title: "Keep Scanning", style: UIAlertActionStyle.default,handler: nil))
                                    shoppingCartAlert.addAction(UIAlertAction(title: "Go to Shopping Cart", style: UIAlertActionStyle.default,handler: {(action)-> Void in
                                        //performUIUpdatesOnMain {
                                        
//                                        let shoppingVC = self.storyboard?.instantiateViewController(withIdentifier: "shoppingCart") as! shoppingCart

 
                                            self.tabBarController?.tabBar.items?[0].isEnabled = false
                                            self.tabBarController?.tabBar.items?[1].isEnabled = true
                                        //}
                                        
                                    }))
                                    self.present(shoppingCartAlert, animated: true, completion: nil)
                                }))
                                
                             
                               
                                
                                self.present(alert, animated: true, completion: nil)
                                
                            }//if not found,
                            else{
                                print(self.messageLabel.text!)
                                let alert =  UIAlertController(title: "Scanning Error", message:
                                    "Cannot find product!", preferredStyle:.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                                    
                                    let shoppingCartAlert = UIAlertController(title: nil, message:
                                        "Are you done with scanning?", preferredStyle:.alert)
                                    shoppingCartAlert.addAction(UIAlertAction(title: "Keep Scanning", style: UIAlertActionStyle.default,handler: nil))
                                    shoppingCartAlert.addAction(UIAlertAction(title: "Go to Shopping Cart", style: UIAlertActionStyle.default,handler: {(action)-> Void in
                                        //performUIUpdatesOnMain {
//                                            self.presentViewController(shoppingCart, animated: true, completion: nil)
                                            self.tabBarController?.tabBar.items?[0].isEnabled = false
                                            self.tabBarController?.tabBar.items?[1].isEnabled = true
                                        //}
                                     
                                    }))
                                    self.present(shoppingCartAlert, animated: true, completion: nil)
                                
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        
      //                  }
                      
                    }
                 
                    
                  
                }
            }
        task.resume()
        }
    
    
    
    
    @IBAction func scanButtonClicked(_ sender: Any) {
        getAllProduct()
        print(messageLabel.text!)
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR/barcode is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
    
}
