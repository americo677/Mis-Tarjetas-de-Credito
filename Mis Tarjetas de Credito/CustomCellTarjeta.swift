//
//  CustomCellTarjeta.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 7/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class CustomCellTarjeta: UITableViewCell {

    @IBOutlet weak var ivImageTarjeta: UIImageView!
    
    @IBOutlet weak var lblBancoFranquicia: UILabel!
    
    @IBOutlet weak var lblNumeroTarjeta: UILabel!
    
    @IBOutlet weak var lblCupoDisponible: UILabel!
    
    @IBOutlet weak var lblTEAVigente: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
