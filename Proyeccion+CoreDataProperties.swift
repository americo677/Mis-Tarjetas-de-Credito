//
//  Proyeccion+CoreDataProperties.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 14/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Proyeccion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Proyeccion> {
        return NSFetchRequest<Proyeccion>(entityName: "Proyeccion")
    }

    @NSManaged public var cuota: Double
    @NSManaged public var dias: Double
    @NSManaged public var fechaCorte: NSDate?
    @NSManaged public var indice: Double
    @NSManaged public var interes: Double
    @NSManaged public var mes: Double
    @NSManaged public var plazo: Double
    @NSManaged public var saldo: Double
    @NSManaged public var tea: Double
    @NSManaged public var temd: Double
    @NSManaged public var valor: Double
    @NSManaged public var valorCuota: Double
    @NSManaged public var valorIntereses: Double
    @NSManaged public var compra: Compra?

}
