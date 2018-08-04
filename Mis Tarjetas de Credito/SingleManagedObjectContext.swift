//
//  SingleNSManagedObjectContext.swift
//  Mi Calculadora de Prestamo
//
//  Created by Américo Cantillo on 15/11/16.
//  Copyright © 2016 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData

class SingleManagedObjectContext {

    private var _moc: NSManagedObjectContext
    
    private init(_ moc: NSManagedObjectContext =  DataController().managedObjectContext) {
        _moc = moc
    }
    
    static let sharedInstance = SingleManagedObjectContext()

    func getMOC() -> NSManagedObjectContext {
        return _moc
    }
    
    func setMOC(_ moc: NSManagedObjectContext) {
        _moc = moc
    }
}
