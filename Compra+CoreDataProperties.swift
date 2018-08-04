//
//  Compra+CoreDataProperties.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 14/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Compra {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Compra> {
        return NSFetchRequest<Compra>(entityName: "Compra")
    }

    @NSManaged public var comercio: String?
    @NSManaged public var descripcion: String?
    @NSManaged public var fecha: NSDate?
    @NSManaged public var imagen: String?
    @NSManaged public var indice: Double
    @NSManaged public var plazo: Double
    @NSManaged public var saldo: Double
    @NSManaged public var tea: Double
    @NSManaged public var totalIntereses: Double
    @NSManaged public var valor: Double
    @NSManaged public var tarjeta: Tarjeta?
    @NSManaged public var proyecciones: NSSet?

}

// MARK: Generated accessors for proyecciones
extension Compra {

    @objc(addProyeccionesObject:)
    @NSManaged public func addToProyecciones(_ value: Proyeccion)

    @objc(removeProyeccionesObject:)
    @NSManaged public func removeFromProyecciones(_ value: Proyeccion)

    @objc(addProyecciones:)
    @NSManaged public func addToProyecciones(_ values: NSSet)

    @objc(removeProyecciones:)
    @NSManaged public func removeFromProyecciones(_ values: NSSet)

}
