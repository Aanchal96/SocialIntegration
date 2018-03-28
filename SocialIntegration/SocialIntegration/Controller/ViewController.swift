//
//  ViewController.swift
//  SocialIntegration
//
//  Created by Appinventiv on 27/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var visualEffect: UIVisualEffectView!

    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var passTF: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var forgotPassBtn: UIButton!
    
    @IBOutlet weak var noAccountButton: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var orLabel: UILabel!
    
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    
    @IBOutlet weak var footerView: UIView!
    
    let loginButton = LoginButton(readPermissions: [ .publicProfile ])
    
    var dict : [String : AnyObject]!
    
    let borderWidth:CGFloat = 2
    
    let cornerRadius:CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonDefault(self.continueButton)
        
        //MARK: --> setting delegate of GIDSignIn to self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //MARK: --> creating Facebook Login button
        let leading:CGFloat = 44
        let centre = view.center
        let width = (centre.x - leading)*2
        let height:CGFloat = 40
        let y = self.footerView.center.y - (height/2) + 10
        self.loginButton.frame = CGRect(x: leading, y: y, width: width, height: height)
        self.view.addSubview(loginButton)
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            //            let vc = ViewController().storyboard?.instantiateViewController(withIdentifier: "mapsViewController") as! MapsViewController
            //            ViewController().navigationController?.pushViewController(vc, animated: true)
        }
        
        //MARK: --> Customized FB login button
        //        let myLoginButton = UIButton(type: .custom)
        //        myLoginButton.backgroundColor = UIColor.darkGray
        //        myLoginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        //        myLoginButton.center = view.center
        //        myLoginButton.setTitle("My Login Button", for: .normal)
        //        view.addSubview(myLoginButton)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //MARK: --> Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        self.holdDown(sender as! UIButton)
    }
    
    @IBAction func continueButton(_ sender: Any) {
        self.buttonDefault(sender as! UIButton)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapsViewController") as! MapsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func forgotPassBtn(_ sender: Any) {
    }
    
    @IBAction func noAccountButton(_ sender: Any) {
        self.animate(footerView)
        self.animate(signUpBtn)
        self.animate(orLabel)
        self.animate(loginButton)
        self.animate(googleSignInBtn)
        self.noAccountButton.isHidden = true
        
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
    }
    
    @IBAction func googleSignInBtn(_ sender: Any) {
    }
    @IBAction func gSignOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
    }
    
}
//MARK: --> Facebook login handling methods
extension ViewController:  FBSDKLoginButtonDelegate{
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            print("User cancelled login.")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("public_profile")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile ], viewController: self){ loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //MARK: --> function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
    
}
//MARK: --> Button customizations
extension ViewController{
    
    func holdDown(_ sender:UIButton)
    {
        sender.backgroundColor = UIColor.orange
        sender.layer.cornerRadius = self.cornerRadius
        sender.layer.borderWidth = self.borderWidth
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    func buttonDefault(_ button : UIButton){
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = self.cornerRadius
        button.layer.borderWidth = self.borderWidth
        button.layer.borderColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), for: .normal)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animateIdentity(footerView)
        self.animateIdentity(signUpBtn)
        self.animateIdentity(orLabel)
        self.animateIdentity(loginButton)
        self.animateIdentity(googleSignInBtn)
    }
}

//MARK: --> Animations
extension ViewController{
    func animate(_ object:UIView){
        self.setAlpha(self.visualEffect, 0.5)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
            self.setAlpha(self.visualEffect, 0.9)
            let alpha:CGFloat = 0.2
            self.setAlpha(self.userNameTF, alpha)
            self.setAlpha(self.passTF, alpha)
            self.setAlpha(self.continueButton, alpha)
            self.setAlpha(self.forgotPassBtn, alpha)
            let y = self.footerView.bounds.size.height
            object.transform = CGAffineTransform(translationX: 0, y: -y)
        }, completion: nil)
    }
    
    func animateIdentity(_ object:UIView){
        self.setAlpha(self.visualEffect, 0.9)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
            self.setAlpha(self.visualEffect, 0.5)
            let alpha:CGFloat = 1
            self.setAlpha(self.userNameTF, alpha)
            self.setAlpha(self.passTF, alpha)
            self.setAlpha(self.continueButton, alpha)
            self.setAlpha(self.forgotPassBtn, alpha)
            object.transform = .identity
        }){   (true) in self.noAccountButton.isHidden = false
        }
    }
    
    func setAlpha(_ object:UIView,_ value:CGFloat){
        return object.alpha = value
    }
}
