//
//  DetalleExtracto.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 11/09/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import UIKit

class DetalleExtracto {
    
    public var comercio: String?
    public var concepto: String?
    public var cuota: Double
    public var cuotasPagadas: Double
    public var cuotasPendientes: Double
    public var detalle: Double
    public var fecha: NSDate?
    public var indice: Double
    public var plazo: Double
    public var saldoPendiente: Double
    public var tea: Double
    public var valor: Double
    public var valorCuota: Double
    
    init?() {
        self.comercio = ""
        self.concepto = ""
        self.cuota = 0.0
        self.cuotasPagadas = 0.0
        self.cuotasPendientes = 0.0
        self.detalle = 0.0
        self.fecha = Date() as NSDate
        self.indice = 0.0
        self.plazo = 0.0
        self.saldoPendiente = 0.0
        self.tea = 0.0
        self.valor = 0.0
        self.valorCuota = 0.0
    }
}
