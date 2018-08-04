//
//  CustomPrintPageRenderer.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 16/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {
    let A4PageWidth: CGFloat = 595.2
    
    let A4PageHeight: CGFloat = 841.8

    let letterPageWidth: CGFloat = 8.5 * 72
    let letterPageHeight: CGFloat = 11 * 72

    override init() {
        super.init()
        
        // Specify the frame of the A4 page.
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: letterPageWidth, height: letterPageHeight)
        
        // Set the page frame.
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        
        // Set the horizontal and vertical insets (that's optional).
        self.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
    }

}
