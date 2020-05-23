//
//  SceneDelegate.swift
//  TalentedApp
//
//  Created by jess on 4/19/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // lcreate insance variable persistent container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Could not load data store: \(error)")
            }
        }
        return container
    }()
    
    // asknpersistentContainer for its viewContext
    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        //let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        UITabBar.appearance().tintColor = UIColor(named: "accentColor")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

//        let tabController = storyBoard.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
//
//        if let tabViewControllers = tabController.viewControllers {
//            // FIRST TAB
//            var navController = tabViewControllers[0] as! UINavigationController
//            let controller = navController.viewControllers.first as! SearchViewController
//            controller.managedObjectContext = managedObjectContext
//            
//           
//            // SECOND TAB
//            navController = tabViewControllers[1] as! UINavigationController
//            let controller2 = navController.viewControllers.first as! SecondViewController
//            controller2.managedObjectContext = managedObjectContext
//
//        }
//        print(applicationDocumentsDirectory)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

