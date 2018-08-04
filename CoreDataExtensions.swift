//
//  CoreDataExtensions.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 16/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Tarjeta {
    
    func obtenerUltimoIndice() -> Double {
        var result: Double = 0
        let tarjetas = fetchData(entity: .tarjeta, byIndex: nil, orderByIndex: true)
        
        if tarjetas.count > 0 {
            result = (tarjetas.last as! Tarjeta).indice
        }
        
        return result
    }
    
    func obtenerNuevoIndice() -> Double {
        let result: Double = obtenerUltimoIndice() + 1
        return result
    }
    
    func obtenerPrimerIndice() -> Double {
        var result: Double = 0
        let tarjetas = fetchData(entity: .tarjeta, byIndex: nil, orderByIndex: true)
        
        if tarjetas.count > 0 {
            result = (tarjetas.first as! Tarjeta).indice
        }
        
        return result
    }

    func orderByDescription(orden: Orden) -> [AnyObject] {
        let moc = SingleManagedObjectContext.sharedInstance.getMOC()
        
        let data = NSFetchRequest<NSFetchRequestResult>(entityName: Tarjeta.entity().managedObjectClassName!)
        
        data.entity = NSEntityDescription.entity(forEntityName: Tarjeta.entity().managedObjectClassName!, in: moc)
        
        do {
            let tarjetas = try moc.fetch(data) as [AnyObject]
            
            //self.instituciones = instituciones.sorted { ($0 as! Institucion).descripcion! < ($1 as! Institucion).descripcion! }
            if orden == .ascendente {
                return tarjetas.sorted { ($0 as! Tarjeta).banco! < ($1 as! Tarjeta).banco! }
            } else {
                return tarjetas.sorted { ($0 as! Tarjeta).banco! > ($1 as! Tarjeta).banco! }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
    func addToCompras(compra: Compra) {
        let compras = self.mutableSetValue(forKey: "compras")
        compras.add(compra)
        cargarCompraPor(valor: compra.valor)
    }
    
    func obtenerCompras() -> [AnyObject] {
        let compras = self.mutableSetValue(forKey: "compras").allObjects as [AnyObject]
        
        let comprasOrdenadas = compras.sorted { ((($0 as! Compra).fecha)! as Date) < ((($1 as! Compra).fecha)! as Date) }
        
        return comprasOrdenadas
    }
    
    func cargarCompraPor(valor: Double) {
        self.disponible = self.disponible - valor
    }

    /*
    func cuotasPeriodoActual() -> [AnyObject] {
        let compras = self.mutableSetValue(forKey: "compras").allObjects as [AnyObject]
        
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        let hoy = Date()
        
        
        
        
        if periodos.count > 0 {
            //print("Periodos: \(periodos)")
            let periodosFiltrados = periodos.filter {
                (($0 as! Periodo).fechaInicial! as Date) <= hoy && hoy <= (($0 as! Periodo).fechaFinal! as Date)
            }
            if periodosFiltrados.count >= 1 {
                return periodosFiltrados.first as? Periodo
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    */
    
    func removeFromCompras(compra: Compra) {
        let moc = SingleManagedObjectContext.sharedInstance.getMOC()

        let valor = compra.valor
        
        moc.delete(compra as NSManagedObject)
        
        do {
            try moc.save()
        } catch {
            let deleteError = error as NSError
            print(deleteError)
        }

        descargarCompraPor(valor: valor)
    }
    
    func descargarCompraPor(valor: Double) {
        self.disponible = self.disponible + valor
    }
    
    func sincronizarCupoDisponible() {
        let moc = SingleManagedObjectContext.sharedInstance.getMOC()

        let compras = self.mutableSetValue(forKey: "compras").allObjects as [AnyObject]
        
        self.disponible = self.cupo
        
        for object in compras {
            let compra = object as! Compra
            
            self.disponible -= compra.valor
        }

        do {
            try moc.save()
        } catch {
            let err = error as NSError
            print(err.localizedDescription)
        }
    }
    
}

extension Compra {
    //func addToRangos(rango: RangoEscala) {
    //    let rangos = self.mutableSetValue(forKey: "rangos")
    //    rangos.add(rango)
    //}

    //func obtenerRangos() -> [AnyObject] {
    //    let rangos = self.mutableSetValue(forKey: "rangos").allObjects as [AnyObject]
        
    //    let rangosOrdenados = rangos.sorted { ($0 as! RangoEscala).limiteInferior < ($1 as! RangoEscala).limiteInferior }
        
    //    return rangosOrdenados
    //}

    func obtenerUltimoIndice() -> Double {
        var result: Double = 0
        let compras = fetchData(entity: .compra, byIndex: nil, orderByIndex: true)
        
        if compras.count > 0 {
            result = (compras.last as! Compra).indice
        }
        
        return result
    }
    
    func obtenerNuevoIndice() -> Double {
        let result: Double = obtenerUltimoIndice() + 1
        return result
    }
    
    func obtenerPrimerIndice() -> Double {
        var result: Double = 0
        let compras = fetchData(entity: .compra, byIndex: nil, orderByIndex: true)
        
        if compras.count > 0 {
            result = (compras.first as! Compra).indice
        }
        
        return result
    }
    
    func addToProyecciones(proyeccion: Proyeccion) {
        let proyecciones = self.mutableSetValue(forKey: "proyecciones")
        proyecciones.add(proyeccion)
    }
    
    func obtenerProyecciones() -> [AnyObject] {
        let proyecciones = self.mutableSetValue(forKey: "proyecciones").allObjects
        
        let proyeccionesOrdenadas = proyecciones.sorted { ($0 as! Proyeccion).cuota < ($1 as! Proyeccion).cuota
        }
        
        return proyeccionesOrdenadas as [AnyObject]
    }
    
    func obtenerProyeccionDelMes() -> AnyObject? {
        var cuotaDelMes: AnyObject?
        
        let hoy = Date()
        
        let proyecciones = obtenerProyecciones()
        
        if proyecciones.count > 0 {
            for pObj in proyecciones {
                let cuota = pObj as! Proyeccion
                
                if samePeriod(reference: hoy as NSDate, compareTo: cuota.fechaCorte!) {
                    cuotaDelMes = cuota
                    break
                }
                
            }
        } else {
            cuotaDelMes = nil
        }
        
        
        return cuotaDelMes
    }
    
    func totalAPagar() -> Double {
        let proyecciones = self.mutableSetValue(forKey: "proyecciones")
        var total: Double = 0
        
        for p in proyecciones {
            total += (p as! Proyeccion).valorCuota + (p as! Proyeccion).interes
        }
        
        return total
    }
    
    func removerProyecciones() {
        
        let moc = SingleManagedObjectContext.sharedInstance.getMOC()
        
        let proyecciones = self.mutableSetValue(forKey: "proyecciones").allObjects
        
        for p in proyecciones as! [NSManagedObject] {
            let proyeccion = p as! Proyeccion
            moc.delete(proyeccion)
        }
        
        /*
        let coordinator = moc.persistentStoreCoordinator

        let fetchRequestForDelete: NSFetchRequest<Proyeccion> = Proyeccion.fetchRequest()
        
        let filter = NSPredicate(format: "compra == %@", self)
        
        fetchRequestForDelete.predicate = filter
        
        let deletedFetch = NSBatchDeleteRequest(fetchRequest: fetchRequestForDelete as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            //try moc.execute(deletedFetch)
            try coordinator?.execute(deletedFetch, with: moc)
            
            //print("Se eliminaron las proyecciones de la compra con éxito!.")
        } catch let error as NSError {
            print("No se pudo eliminar los datos de la compra.  Error: \(error.localizedDescription)")
        }
        */
        
    }
    
    func actualizar(valor: Double) {
        if valor != self.valor {
            let valorAnterior = self.valor
            self.valor = valor
            
            let tarjeta = self.tarjeta
            
            tarjeta?.descargarCompraPor(valor: valorAnterior)
            tarjeta?.cargarCompraPor(valor: valor)
        }
    }
}

extension Proyeccion {
    func obtenerUltimoIndice() -> Double {
        var result: Double = 0
        let proyecciones = fetchData(entity: .proyeccion, byIndex: nil, orderByIndex: true)
        
        if proyecciones.count > 0 {
            result = (proyecciones.last as! Proyeccion).indice
        }
        
        return result
    }
    
    func obtenerNuevoIndice() -> Double {
        let result: Double = obtenerUltimoIndice() + 1
        return result
    }
    
    func obtenerPrimerIndice() -> Double {
        var result: Double = 0
        let rangos = fetchData(entity: .proyeccion, byIndex: nil, orderByIndex: true)
        
        if rangos.count > 0 {
            result = (rangos.first as! Proyeccion).indice
        }
        
        return result
    }

}

extension Extracto {
    /*
    func periodoVigente() -> Periodo? {
        let periodos = self.mutableSetValue(forKey: "periodos")
       
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        let hoy = Date()
        
        if periodos.count > 0 {
            print("Periodos: \(periodos)")
            let periodosFiltrados = periodos.filter {
                (($0 as! Periodo).fechaInicial! as Date) <= hoy && hoy <= (($0 as! Periodo).fechaFinal! as Date)
            }
            if periodosFiltrados.count >= 1 {
                return periodosFiltrados.first as? Periodo
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func addPeriodo(periodo: Periodo) {
        let periodos = self.mutableSetValue(forKey: "periodos")
        periodos.add(periodo)
    }

    func removePeriodo(periodo: Periodo) {
        let periodos = self.mutableSetValue(forKey: "periodos")
        periodos.remove(periodo)
    }
    
    func obtenerPeriodos() -> [AnyObject] {
        let periodos = self.mutableSetValue(forKey: "periodos").allObjects
        
        return periodos as [AnyObject]
    }
 
    func obtenerPeriodosOrdernadoPorIndice() -> [AnyObject] {
        let periodos = self.mutableSetValue(forKey: "periodos").allObjects
        var result = [AnyObject]()
        
        if periodos.count > 0 {
            result = periodos.sorted { ($0 as! Periodo).indice < ($1 as! Periodo).indice } as [AnyObject]
        }
        
        return result as [AnyObject]
    }
     */

    func obtenerUltimoIndice() -> Double {
        var result: Double = 0
        let extractos = fetchData(entity: .extracto, byIndex: nil, orderByIndex: true)
        
        if extractos.count > 0 {
            result = (extractos.last as! Extracto).indice
        }
        
        return result
    }
    
    func obtenerNuevoIndice() -> Double {
        let result: Double = obtenerUltimoIndice() + 1
        return result
    }
    
    func obtenerPrimerIndice() -> Double {
        var result: Double = 0
        let extractos = fetchData(entity: .extracto, byIndex: nil, orderByIndex: true)
        
        if extractos.count > 0 {
            result = (extractos.first as! Extracto).indice
        }
        
        return result
    }
}

extension Detalle {
    func obtenerUltimoIndice() -> Double {
        var result: Double = 0
        let detalles = fetchData(entity: .detalle, byIndex: nil, orderByIndex: true)
        
        if detalles.count > 0 {
            result = (detalles.last as! Detalle).indice
        }
        
        return result
    }
    
    func obtenerNuevoIndice() -> Double {
        let result: Double = obtenerUltimoIndice() + 1
        return result
    }
    
    func obtenerPrimerIndice() -> Double {
        var result: Double = 0
        let detalles = fetchData(entity: .detalle, byIndex: nil, orderByIndex: true)
        
        if detalles.count > 0 {
            result = (detalles.first as! Detalle).indice
        }
        
        return result
    }
    
}
