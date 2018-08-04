//
//  CustomCellCompra.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 12/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class CustomCellCompra: UITableViewCell {

    @IBOutlet weak var ivImagen: UIImageView!
    
    @IBOutlet weak var lblDescripcion: UILabel!
    
    @IBOutlet weak var lblComercio: UILabel!
    
    @IBOutlet weak var lblFecha: UILabel!
    
    @IBOutlet weak var lblValor: UILabel!
    
    @IBOutlet weak var lblPlazo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
