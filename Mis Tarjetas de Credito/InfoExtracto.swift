//
//  InfoExtracto.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 11/09/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation


class InfoExtracto {
    var cuotaManejo: Double
    var fechaCorte: NSDate?
    var indice: Double
    var totalAPagar: Double
    var totalIntereses: Double
    var totalPagoCuotas: Double
    
    init?() {
        cuotaManejo = 0.0
        fechaCorte = NSDate()
        indice = 0.0
        totalAPagar = 0.0
        totalIntereses = 0.0
        totalPagoCuotas = 0.0
    }

}
