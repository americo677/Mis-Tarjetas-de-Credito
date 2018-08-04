//
//  Extracto+CoreDataProperties.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 13/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Extracto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Extracto> {
        return NSFetchRequest<Extracto>(entityName: "Extracto")
    }

    @NSManaged public var cuotaManejo: Double
    @NSManaged public var fechaCorte: NSDate?
    @NSManaged public var indice: Double
    @NSManaged public var totalAPagar: Double
    @NSManaged public var totalIntereses: Double
    @NSManaged public var totalPagoCuotas: Double

}
