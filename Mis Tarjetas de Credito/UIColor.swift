//
//  UIColor.swift
//  Mi Calculadora de Prestamo
//
//  Created by Américo Cantillo on 1/11/16.
//  Copyright © 2016 Américo Cantillo Gutiérrez. All rights reserved.
//


import Foundation
import UIKit

extension UIColor {

    class func toolbarTitleFontColor() -> UIColor {
        return UIColor.yellow
    }
    
    class func toolbarBackgroundColor() -> UIColor {
        return UIColor.customOceanBlue()
    }
    
    class func viewBackgroundColor() -> UIColor {
        return UIColor.customUltraLightBlue()
    }
    
    class func tableViewBackgroundColor() -> UIColor {
        return UIColor.customUltraLightBlue()
    }
    
    class func customOceanBlue() -> UIColor {
        return UIColor(red:0.030, green:0.376 ,blue:0.588 , alpha:1.00)
    }
    
    class func customUltraLightBlue() -> UIColor {
        return UIColor(red:0.838, green:0.913 ,blue:1.000, alpha:1.00)
    }

    class func customBlue() -> UIColor {
        return UIColor(red:0.043, green:0.576 ,blue:0.588 , alpha:1.00)
    }
    
    class func customLightGray() -> UIColor {
        return UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 0.23)
    }
    
    class func  customLightGreen() -> UIColor {
        return UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 0.3)
    }
    
    class func  customLightYellow() -> UIColor {
        return UIColor(red: 1.0, green: 1.0, blue: 0.85, alpha: 0.9)
    }
    
    class func  customLightRed() -> UIColor {
        return UIColor(red: 7.0, green: 0.1, blue: 0.1, alpha: 0.3)
    }
    
    class func customDarkColor() -> UIColor {
        return UIColor(red:0.260, green:0.260 ,blue:0.260 , alpha:1.00)
    }
    
    class func customLightColor() -> UIColor {
        return UIColor(red:0.460, green:0.460 ,blue:0.460 , alpha:1.00)
    }
    
    class func customLightPurple() -> UIColor {
        return UIColor(red:0.186, green:0.006 ,blue:0.174 , alpha:1.00)
    }
}
