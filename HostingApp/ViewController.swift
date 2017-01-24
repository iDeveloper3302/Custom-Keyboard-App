//
//  ViewController.swift
//  TransliteratingKeyboard
//
//  Created by Alexei Baboulevitch on 6/9/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var stats: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidHide"), name: UIKeyboardDidHideNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChangeFrame:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidChangeFrame:"), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (UIApplication.sharedApplication().statusBarOrientation.isLandscape) {
            let string1 = returnUIDeviceName()
            let string2 = "Landscape"
            let string = string1 + string2
            imageView.image = UIImage(named: string)
        }
        else {
            let string1 = returnUIDeviceName()
            let string2 = "Portrait"
            let string = string1 + string2
            imageView.image = UIImage(named: string)
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if (toInterfaceOrientation.isLandscape) {
            let string1 = returnUIDeviceName()
            let string2 = "Landscape"
            let string = string1 + string2
            imageView.image = UIImage(named: string)
        }
        else {
            let string1 = returnUIDeviceNameWidth()
            let string2 = "Portrait"
            let string = string1 + string2
            imageView.image = UIImage(named: string)
        }
    }
    
    func returnUIDeviceName() -> String {
        let height = UIScreen.mainScreen().bounds.height
//        if height < 568 {
//            return "iPhone4s"
//        } else if (height < 667 && height >= 568) {
//            return "iPhone5"
//        } else if (height < 736 && height >= 667) {
//            return "iPhone6"
//        } else if (height < 1024 && height >= 736) {
//            return "iPhone6Plus"
//        } else if (height < 2048 && height >= 1024) {
//            return "iPadMini-"
//        }else if (height < 2732  && height >= 2048) {
//            return "iPad"
//        } else if (height >= 2732) {
//            return "iPadPro"
//        }
        
        switch height {
        case 480.0:
            print("iPhone 3,4")
            return "iPhone4s"
        case 568.0:
            print("iPhone 5")
            return "iPhone5"
        case 667.0:
            print("iPhone 6")
            return "iPhone6"
        case 736.0:
            print("iPhone 6+")
            return "iPhone6Plus"
        case 1024.0:
            print("iPadMini")
            return "iPadMini"
        case 2048.0:
            print("iPad")
            return "iPad"
        case 2732.0:
            print("iPadPro")
            return "iPadPro"
            
        default:
            print("iPhone6Plus")
            return "iPhone6Plus"
            
        }
        
    }
    
    func returnUIDeviceNameWidth() -> String {
        let height = UIScreen.mainScreen().bounds.width
        
        switch height {
        case 480.0:
            print("iPhone 3,4")
            return "iPhone4s"
        case 568.0:
            print("iPhone 5")
            return "iPhone5"
        case 667.0:
            print("iPhone 6")
            return "iPhone6"
        case 736.0:
            print("iPhone 6+")
            return "iPhone6Plus"
        case 1024.0:
            print("iPadMini")
            return "iPadMini"
        case 2048.0:
            print("iPad")
            return "iPad"
        case 2732.0:
            print("iPadPro")
            return "iPadPro"
            
        default:
            print("iPhone6Plus")
            
        }
        
        return "iPhone6Plus"
    }
    
    @IBAction func dismiss() {
        for view in self.view.subviews {
            if let inputView = view as? UITextField {
                inputView.resignFirstResponder()
            }
        }
    }
    
    var startTime: NSTimeInterval?
    var firstHeightTime: NSTimeInterval?
    var secondHeightTime: NSTimeInterval?
    var referenceHeight: CGFloat = 216
    
    func keyboardWillShow() {
        if startTime == nil {
            startTime = CACurrentMediaTime()
        }
    }
    
    func keyboardDidHide() {
        startTime = nil
        firstHeightTime = nil
        secondHeightTime = nil
        
        self.stats?.text = "(Waiting for keyboard...)"
    }
    
    func keyboardDidChangeFrame(notification: NSNotification) {
        let frameBegin: CGRect! = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue()
        let frameEnd: CGRect! = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        
        if frameEnd.height == referenceHeight {
            if firstHeightTime == nil {
                firstHeightTime = CACurrentMediaTime()
                
                if let startTime = self.startTime {
                    if let firstHeightTime = self.firstHeightTime {
                        let formatString = NSString(format: "First: %.2f, Total: %.2f", (firstHeightTime - startTime), (firstHeightTime - startTime))
                        self.stats?.text = formatString as String
                    }
                }
            }
        }
        else if frameEnd.height != 0 {
            if secondHeightTime == nil {
                secondHeightTime = CACurrentMediaTime()

                if let startTime = self.startTime {
                    if let firstHeightTime = self.firstHeightTime {
                        if let secondHeightTime = self.secondHeightTime {
                            let formatString = NSString(format: "First: %.2f, Second: %.2f, Total: %.2f", (firstHeightTime - startTime), (secondHeightTime - firstHeightTime), (secondHeightTime - startTime))
                            self.stats?.text = formatString as String
                        }
                    }
                }
            }
        }
    }
}

