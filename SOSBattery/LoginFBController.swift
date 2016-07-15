//
//  ViewController.swift
//  SOSBattery
//
//  Created by Rodrigo Dugin on 07/07/16.
//  Copyright © 2016 Point-Break Apps. All rights reserved.
//

import UIKit
import Firebase


class LoginFBController: UIViewController, FBSDKLoginButtonDelegate {
     
     let loginButton : FBSDKLoginButton = {
          let button = FBSDKLoginButton()
          button.readPermissions = ["email", "public_profile"]
          return button
     }()
     
          var ref: FIRDatabaseReference!
     

     override func viewDidLoad() {
          super.viewDidLoad()
         
          view.addSubview(loginButton)
          
          loginButton.center =  CGPointMake(self.view.bounds.size.width / 2, self.view.frame.size.height - 50)
          
          loginButton.delegate = self
          
          
          
     }

     func fetchProfile(){
          print("fetch profile")
          
          self.ref = FIRDatabase.database().reference()
          
          let parameters = ["fields": "email, first_name, last_name, picture.type(large), gender, age_range"]
          FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {(connection, result, error) -> Void in
               
               if error != nil {
                    print(error)
                    return
               }
               
               if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                    let pictureUrl: String = url
                    
                      let age =  result["age_range"] as! NSDictionary
                    
                    
                    
                         
                         let age_range : String
                         
                          if  age["max"] == nil{
                              age_range = "\(age["min"] as! Int )+"
                              
                         }
                          else{
                              
                              age_range = "\(age["min"] as! Int )-\(age["max"] as! Int)"
                         }
 
                   
                    
                    
                    let db = ["email": result["email"]as! String,"age_range": age_range  ,"id": "facebook:\(result["id"]as! String)" ,"imgURL": pictureUrl, "nome":"\(result["first_name"]as! String) \(result["last_name"]as! String)", "sexo": result["gender"]as! String]
                    
                    self.ref.child("usuarios").child("facebook:\(result["id"]as! String)").setValue(db)
                    
                   
                    
                    
                    
               }
              
             
               
               
               
          }
            

          
          
          
     }
     
        
     override func viewDidAppear(animated: Bool) {
          if FBSDKAccessToken.currentAccessToken() != nil{
         
               self.performSegueWithIdentifier("mySegueTabID", sender: nil)
          
          }
          
          
     }
     
          
     
     
     func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
          
          print("completed login")
          
          fetchProfile()

          
     }
     
     func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
          
     }
     
     func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
          print("loginButtonWillLogin")
          return true
     }
     
     
     
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
     }


}

