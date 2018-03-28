//
//  AppDelegate.swift
//  SocialIntegration
//
//  Created by Appinventiv on 27/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate  {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //MARK:--> Initialize facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //MARK:--> Providing client ID and google sign in delegate
        GIDSignIn.sharedInstance().clientID = "217652371245-ftqsu0p0gj31u3j6kkslk9t8rvg4077c.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        //MARK:--> Providing API key to google maps and places
        GMSServices.provideAPIKey("AIzaSyCTsuqQHKE76BKkodBzMMilo9z4s7rMq10")
        GMSPlacesClient.provideAPIKey("AIzaSyCTsuqQHKE76BKkodBzMMilo9z4s7rMq10")
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        //to handle app states
        FBSDKAppEvents.activateApp()
    }
    
    //MARK:--> Method to handle Google sign in
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    //MARK:--> Perform operations after signing into google 
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            //      let userId = user.userID                  // For client-side use only!
            //      let idToken = user.authentication.idToken // Safe to send to the server
            //      let fullName = user.profile.name
            //      let givenName = user.profile.givenName
            //      let familyName = user.profile.familyName
            //      let email = user.profile.email
        }
    }
    
    //MARK:--> Perform any operations when the user disconnects from google from app here.
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        MapsViewController().navigationController?.popViewController(animated: true)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                                   sourceApplication: sourceApplication,
                                                                   annotation: annotation)
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return googleDidHandle || facebookDidHandle
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SocialIntegration")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

