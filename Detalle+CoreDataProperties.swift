//
//  Detalle+CoreDataProperties.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 13/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Detalle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detalle> {
        return NSFetchRequest<Detalle>(entityName: "Detalle")
    }

    @NSManaged public var comercio: String?
    @NSManaged public var concepto: String?
    @NSManaged public var cuota: Double
    @NSManaged public var cuotasPagadas: Double
    @NSManaged public var cuotasPendientes: Double
    @NSManaged public var detalle: Double
    @NSManaged public var fecha: NSDate?
    @NSManaged public var indice: Double
    @NSManaged public var plazo: Double
    @NSManaged public var saldoPendiente: Double
    @NSManaged public var tea: Double
    @NSManaged public var valor: Double
    @NSManaged public var valorCuota: Double

}
