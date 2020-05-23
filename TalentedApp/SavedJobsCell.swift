//
//  SearchResultCell.swift
//  TalentedApp
//
//  Created by jess on 5/5/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import UIKit

class SavedJobsCell: UITableViewCell {
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    var company_logo: String!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        applyButton.layer.shadowOpacity = 0.4
        applyButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        saveButton.setImage(UIImage(named:"bookmark_highlighted"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(for result: JobInfo) {
        positionLabel.text = result.position
        companyLabel.text = result.company
        locationLabel.text = result.location
        company_logo = result.logo
        
        if company_logo != nil {
            if let smallURL = URL(string: company_logo!) {
                downloadTask = logoImageView.loadImage(url: smallURL)
            }
        } else {
            logoImageView.image = UIImage(named: "profile") // Replace THIS
        }
    }
    
}
