//
//  SearchResultCell.swift
//  TalentedApp
//
//  Created by jess on 5/5/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import UIKit
import CoreData

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    var downloadTask: URLSessionDownloadTask?
    var managedObjectContext: NSManagedObjectContext!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    var companyLogoURL: String!
    var date = Date()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyButton.layer.shadowOpacity = 0.4
        applyButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        saveButton.setImage(UIImage(named:"bookmark_highlighted"), for: .selected)
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedObjectContext = appDelegate.managedObjectContext
        }
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(for result: SearchResult) {
        positionLabel.text = result.title
        companyLabel.text = result.company
        locationLabel.text = result.location
        companyLogoURL = result.company_logo
                
        if result.company_logo != nil {
            if let smallURL = URL(string: result.company_logo!) {
                downloadTask = logoImageView.loadImage(url: smallURL)
            }
        } else {
            logoImageView.image = UIImage(named: "profile") // Replace THIS
        }
    }

    @IBAction func done() {
        if saveButton.isSelected == false {
            saveButton.isSelected = true
            let jobInfo = JobInfo(context: managedObjectContext)
            jobInfo.position = positionLabel.text
            jobInfo.company = companyLabel.text
            jobInfo.location = locationLabel.text
            jobInfo.logo = companyLogoURL
            jobInfo.date = date

            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error: \(error)")
            }
        }
        
        
    }
            

}
