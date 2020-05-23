//
//  Rounded Image.swift
//  TalentedApp
//
//  Created by jess on 5/16/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import Foundation
import UIKit

class RoundedImage: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()

        let radius: CGFloat = self.bounds.size.width / 2.0

        self.layer.cornerRadius = radius
    }
}
