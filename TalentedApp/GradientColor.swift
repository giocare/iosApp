//
//  GradientColor.swift
//  MyLocations
//
//  Created by jess on 4/22/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import Foundation
import UIKit

class GradientColor: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: superview!.frame.size.width, height: superview!.frame.size.height)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.zPosition = -1
        layer.addSublayer(gradientLayer)
    }
    
    
    /*
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [colorTop, colorBottom.cgColor]
        self.view.layer.addSublayer(gradientLayer)
    }
 */
    
   
}
