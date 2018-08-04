//
//  ACButton.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 8/09/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class ACButton: UIButton {
    
    override func awakeFromNib() {
        
        layer.cornerRadius = self.frame.size.height / 2
        
        layer.shadowColor = UIColor.init(red: Global.SHADOW_COLOR, green: Global.SHADOW_COLOR, blue: Global.SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        
        layer.borderColor = UIColor.darkGray.cgColor
    }
}
