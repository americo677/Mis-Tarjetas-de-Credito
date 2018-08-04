//
//  Tarjeta+CoreDataProperties.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 13/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Tarjeta {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tarjeta> {
        return NSFetchRequest<Tarjeta>(entityName: "Tarjeta")
    }

    @NSManaged public var banco: String?
    @NSManaged public var cuotaManejo: Double
    @NSManaged public var cupo: Double
    @NSManaged public var disponible: Double
    @NSManaged public var franquicia: String?
    @NSManaged public var imagen: String?
    @NSManaged public var indice: Double
    @NSManaged public var numero: String?
    @NSManaged public var teaVigente: Double
    @NSManaged public var compras: NSSet?

}

// MARK: Generated accessors for compras
extension Tarjeta {

    @objc(addComprasObject:)
    @NSManaged public func addToCompras(_ value: Compra)

    @objc(removeComprasObject:)
    @NSManaged public func removeFromCompras(_ value: Compra)

    @objc(addCompras:)
    @NSManaged public func addToCompras(_ values: NSSet)

    @objc(removeCompras:)
    @NSManaged public func removeFromCompras(_ values: NSSet)

}
