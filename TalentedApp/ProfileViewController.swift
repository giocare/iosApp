//
//  ProfileViewController.swift
//  TalentedApp
//
//  Created by jess on 5/10/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import Foundation
import  UIKit

class ProfileViewController: UIViewController, EditProfileViewControllerDelegate {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    let defaults = UserDefaults.standard
    let userLocation = ProfileInfo().location
  
    @IBOutlet weak var inforContainer: UIView!
    @IBOutlet weak var photoContainer: UIImageView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        nameLabel.text = ProfileInfo().name
        locationLabel.text = ProfileInfo().location
        bioLabel.text = ProfileInfo().bio
        
        defaults.set(userLocation, forKey: "Location")
        print(UserDefaults.standard.string(forKey: "Location") as Any)
        
        inforContainer.layer.cornerRadius = 10
        photoContainer.layer.cornerRadius = photoContainer.frame.size.width / 2
        photoContainer.clipsToBounds = true
        
        let rightBarButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ProfileViewController.logoutButton(_:)))
         self.navigationItem.leftBarButtonItem = rightBarButton
    }
    
    // these two functions close Edit High Score
    func editProfileViewControllerDidCancel(_ controller: EditProfileViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func editProfileViewController(_ controller: EditProfileViewController, didFinishEditing item: ProfileInfo) {

        print("** RECIEVING AFTER DONE")
        nameLabel.text = item.name
        locationLabel.text = item.location
        bioLabel.text = item.bio
        navigationController?.popViewController(animated: true)
        let userLocation = item.location
        defaults.set(userLocation, forKey: "Location")
        print(UserDefaults.standard.string(forKey: "Location") as Any)
    }
    
    
    var item = ProfileInfo()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier != "logoutTransition" ){
            let controller = segue.destination as! EditProfileViewController
                controller.delegate = self
            nameLabel.text = item.name
            bioLabel.text = item.bio
            locationLabel.text = item.location
                
                print("** SENDING ** \(item)")
        }
            
        }
        
        @objc func logoutButton(_ sender:UIBarButtonItem!)
        {
            print("User has been successfully logged out")
            self.performSegue(withIdentifier: "logoutTransition", sender: nil)

        }
        
    
}
