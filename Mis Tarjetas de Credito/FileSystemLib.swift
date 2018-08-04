//
//  FileSystemLib.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 13/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func getPath(_ fileName: String) -> String {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent(fileName)
    return fileURL.path
}

func getDocumentsURL() -> NSURL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL as NSURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL!.path
    
}

func copyFileFromBundleToDirectory(directory directoryName: String, file filename: String) -> Bool {
    
    var isFileCopied: Bool = false
    
    if isAValidDirectory(directory: directoryName) {
        let manager = FileManager.default
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = paths.appendingPathComponent(directoryName)
        //let fullPath = "\(path.appendingPathComponent(filename))"
        let fullPath = path.appendingPathComponent(filename)

        var isDir: ObjCBool = false
        
        let ext = fullPath.relativePath.getFileExtension()
        let name = fullPath.relativePath.getFilenameWithoutExtension()
    
        //print("full path: \(fullPath)")
        if !manager.fileExists(atPath: fullPath.relativePath, isDirectory: &isDir) {
            
            let fileFromBundle = Bundle.main.path(forResource: name, ofType: ext)
            
            do {
                try manager.copyItem(atPath: fileFromBundle!, toPath: fullPath.relativePath)
                isFileCopied = true
                //print("El archivo fue copiado con éxito.")
            } catch {
                print("Error al intentar copiar el archivo \(fileFromBundle!) en la ruta \(fullPath.relativePath)")
            }
        }
    }
    return isFileCopied
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func genFileNameFromDateTime(sufix formato: String) -> String {
    let date = NSDate()
    let calendar = NSCalendar.current
    let hour = calendar.component(.hour, from: date as Date)
    let minutes = calendar.component(.minute, from: date as Date)
    let seconds = calendar.component(.second, from: date as Date)
    let day = calendar.component(.day, from: date as Date)
    let month = calendar.component(.month, from: date as Date)
    let year = calendar.component(.year, from: date as Date)
    
    let fileName = String(format: "%04d%02d%02d%02d%02d%02d.%@", year, month, day, hour, minutes, seconds, formato)
    
    return fileName
}


/*
 func cargarImagenDesde(fileName: String!) -> UIImage? {
 
 if fileName != nil {
 if !fileName.isEmpty {
 //let fullFileName = URL(fileURLWithPath: fileName)
 
 //"\((getDocumentsURL().appendingPathComponent(fileName)?.absoluteString)!).jpg"
 
 let iImagen = UIImage(contentsOfFile: fileName!)
 
 if iImagen == nil {
 print("No se encontró la imagen: \(fileName!)")
 } else {
 print("Cargando imagen de la ruta: \(fileName!)")
 }
 
 // this is just for you to see the path in case you want to go to the directory, using Finder.
 return iImagen
 }
 }
 return UIImage()
 }
 
 func guardarImagen(imagen: UIImage!) -> Bool {
 
 //let jpgImage = UIImagePNGRepresentation(image)
 
 let jpgImage = UIImageJPEGRepresentation(imagen, 0.6)
 
 var isOk: Bool?
 
 let fileName = getDocumentsURL().appendingPathComponent(genFileNameFromDateTime())
 
 //self.nombreArchivoImagen =  "\(fileName!)"
 
 do {
 _ = try jpgImage?.write(to: fileName!)
 print("La imagen fue almacenada en el dispositivo \(fileName!)")
 isOk = true
 } catch let err {
 isOk = false
 print("No se pudo almacenar la imagen: \(err.localizedDescription)")
 }
 return isOk!
 }
 
 func saveImage(image: UIImage!, imageFullFileName fullName: inout String) -> Bool {
 
 //let jpgImage = UIImagePNGRepresentation(image)
 
 let jpgImage = UIImageJPEGRepresentation(imagen, 0.6)
 
 var isOk: Bool?
 
 let fileName = getDocumentsURL().appendingPathComponent(genFileNameFromDateTime())
 
 //self.nombreArchivoImagen =  "\(fileName!)"
 
 do {
 _ = try jpgImage?.write(to: fileName!)
 print("La imagen fue almacenada en el dispositivo \(fileName!)")
 isOk = true
 } catch let err {
 isOk = false
 print("No se pudo almacenar la imagen: \(err.localizedDescription)")
 }
 return isOk!
 }
 */

// conseguido en internet
// https://iosdevcenters.blogspot.com/2016/04/save-and-get-image-from-document.html

// Save image at document directory

func isAValidDirectory(directory directoryName: String) -> Bool {
    //let fileManager = FileManager.default
    
    let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    //let path = "\(paths.appendingPathComponent(directoryName))"
    let path = paths.appendingPathComponent(directoryName)
    //let fileManager = FileManager.default
    
    var isDir: ObjCBool = false
    var isValidDir: Bool = false
    
    //print("path on isAValidDirectory: \(path.relativePath)")
    
    if manager.fileExists(atPath: path.relativePath, isDirectory: &isDir) {
        if isDir.boolValue {
            // file exists and is a directory
            //print("El directorio \(directoryName) es válido")
            isValidDir = true
        } else {
            // file exists and is not a directory
            //print("Error, el componente Images no es un directorio")
            isValidDir = createDirectory(directory: directoryName)
        }
    } else {
        // file does not exist
        //print("Error, no existe el directorio para Mis Regalos App")
        isValidDir = createDirectory(directory: directoryName)
    }
    
    return isValidDir
}

func saveImageIn(directory directoryName: String, image: UIImage!, fullFileName fileName: inout String) -> Bool {
    
    //let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var isSaveOk: Bool = true
    
    if isAValidDirectory(directory: directoryName) {
        let path = paths.appendingPathComponent(directoryName)
        
        fileName = genFileNameFromDateTime(sufix: "jpg")
        
        let fullPath = path.appendingPathComponent(fileName)
        
        //print("File name: \(fileName)")
        //print("Full path: \(fullPath)")
        
        //let image = UIImage(named: fileName)
        
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        
        //isSaveOk = manager.createFile(atPath: fullPath.absoluteString, contents: imageData, attributes: nil)
        
        do {
            
            try imageData?.write(to: fullPath)
            
        } catch {
            print("Error al escribir imagen: \(error.localizedDescription)")
            isSaveOk = false
        }
        
        if !isSaveOk {
            print("No se pudo almacenar el archivo \(fullPath.absoluteString)")
        }
    } else {
        isSaveOk = false
    }
    
    return isSaveOk
}

/*
func savePDFIn(directory directoryName: String, pdfRender: drawPDFUsingPrintPageRenderer, fullFileName fileName: inout String) -> Bool {
    
    //let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var isSaveOk: Bool = true
    
    if isAValidDirectory(directory: directoryName) {
        let path = paths.appendingPathComponent(directoryName)
        
        fileName = genFileNameFromDateTime(sufix: "pdf")
        
        let fullPath = path.appendingPathComponent(fileName)
        
        //print("File name: \(fileName)")
        //print("Full path: \(fullPath)")
        
        //let image = UIImage(named: fileName)
        
        //let imageData = UIImageJPEGRepresentation(image!, 0.5)
        
        //isSaveOk = manager.createFile(atPath: fullPath.absoluteString, contents: imageData, attributes: nil)
        
        pdfRender
        
        do {
            
            try imageData?.write(to: fullPath)
            
        } catch (let error as Error) {
            print("Error al escribir imagen: \(error.localizedDescription)")
            isSaveOk = false
        }
        
        if !isSaveOk {
            print("No se pudo almacenar el archivo \(fullPath.absoluteString)")
        }
    } else {
        isSaveOk = false
    }
    
    return isSaveOk
}
*/

// get document directory path
/*
 func getDirectoryPath() -> String {
 let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
 let documentsDirectory = paths[0]
 return documentsDirectory
 }
 */

// get image from document directory
func getImageFrom(directory directoryName: String, fileName: String) -> UIImage {
    
    let iImage: UIImage?
    
    let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = paths.appendingPathComponent(directoryName)
    
    let imagePath = path.appendingPathComponent(fileName)
    
    //print("Full image path: \(imagePath)")
    
    if manager.fileExists(atPath: imagePath.path) {
        iImage = UIImage(contentsOfFile: imagePath.path)
    } else {
        print("Not found image \(imagePath.absoluteString)")
        iImage = UIImage()
    }
    
    return iImage!
}

func getImageFullPathFrom(directory directoryName: String, fileName: String) -> String! {
    let vacio = ""
    //let iImage: UIImage?
    
    //let manager = FileManager.default
    if !(fileName.isEmpty) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let path = paths.appendingPathComponent(directoryName)
        
        let imagePath = path.appendingPathComponent(fileName)
        
        //print("Full image path: \(imagePath)")
        
        //if manager.fileExists(atPath: imagePath.path) {
        //    iImage = UIImage(contentsOfFile: imagePath.path)
        //} else {
        //    print("Not found image \(imagePath.absoluteString)")
        //    iImage = UIImage()
        //}
        
        return imagePath.path
    }
    
    return vacio
}

// create directory
func createDirectory(directory directoryName: String) -> Bool {
    let manager = FileManager.default
    
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = paths.appendingPathComponent(directoryName)
    
    var isCreationOk: Bool = true
    
    if !manager.fileExists(atPath: path.path) {
        do {
            try manager.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error al intentar crear el directorio \(directoryName): \(error.localizedDescription)")
            isCreationOk = false
        }
    } else {
        print("El directorio \(directoryName) ya existe!")
    }
    
    return isCreationOk
}

// delete directory
func deleteFileFrom(directory directoryName: String, fileNameToDelete fileName: String) -> Bool {
    let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = paths.appendingPathComponent(directoryName)
    
    let imagePath = path.appendingPathComponent(fileName)
    
    var isDeletedOk: Bool = true
    
    if manager.fileExists(atPath: imagePath.path) {
        try! manager.removeItem(atPath: imagePath.path)
    } else {
        print("No se pudo elminar el archivo \(imagePath.path)")
        isDeletedOk = false
    }
    
    return isDeletedOk
}

// MARK: - Consulta a la BD de instituciones y escalas registradas
func fetchData(entity: CustomClasses, byIndex index: Double? = nil, orderByIndex order: Bool? = false) -> [AnyObject] {
    
    var results = [AnyObject]()
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    //let sortDescriptor = NSSortDescriptor(key: "secciones.recibos.fecha", ascending: false)
    
    
    // fetchRequest.sortDescriptors = [sortDescriptor]
    
    // Initialize Fetch Request
    //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: smModelo.smPresupuesto.entityName)
    
    //let fetchRequest: NSFetchRequest<Programa> = Programa.fetchRequest() //
    //var fecthRequest: NSFetchRequestResult?
    
    switch entity {
    case .tarjeta:
        let fetchTarjeta: NSFetchRequest<Tarjeta> = Tarjeta.fetchRequest()
        fetchTarjeta.entity = NSEntityDescription.entity(forEntityName: "Tarjeta", in: moc)
        if index != nil {
            let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
            //let predicate = NSPredicate(format: " descripcion contains[c] %@ ", "norte" as String)
            fetchTarjeta.predicate = predicate
        }
        do {
            results = try moc.fetch(fetchTarjeta)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        break
    case .compra:
        let fetchCompra: NSFetchRequest<Compra> = Compra.fetchRequest()
        fetchCompra.entity = NSEntityDescription.entity(forEntityName: "Compra", in: moc)
        if index != nil {
            let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
            fetchCompra.predicate = predicate
        }
        do {
            results = try moc.fetch(fetchCompra)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        break
    case .proyeccion:
        let fetchProyeccion: NSFetchRequest<Proyeccion> = Proyeccion.fetchRequest()
        fetchProyeccion.entity = NSEntityDescription.entity(forEntityName: "Proyeccion", in: moc)
        if index != nil {
            let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
            fetchProyeccion.predicate = predicate
        }
        do {
            let programas = try moc.fetch(fetchProyeccion)
            if programas.count > 0 {
                if order! {
                    results = programas.sorted { ($0 as Proyeccion).indice < ($1 as Proyeccion).indice }
                } else {
                    results = programas
                }
            } else {
                results = []
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        break
    case .extracto:
        let fetchExtracto: NSFetchRequest<Extracto> = Extracto.fetchRequest()
        fetchExtracto.entity = NSEntityDescription.entity(forEntityName: "Extracto", in: moc)
        if index != nil {
            let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
            fetchExtracto.predicate = predicate
        }
        do {
            let periodos = try moc.fetch(fetchExtracto)
            if order! {
                results = periodos.sorted { ($0 as Extracto).indice < ($1 as Extracto).indice }
            } else {
                results = periodos
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        break
    case .detalle:
        let fetchDetalle: NSFetchRequest<Detalle> = Detalle.fetchRequest()
        fetchDetalle.entity = NSEntityDescription.entity(forEntityName: "Detalle", in: moc)
        if index != nil {
            let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
            fetchDetalle.predicate = predicate
        }
        do {
            let periodos = try moc.fetch(fetchDetalle)
            if order! {
                results = periodos.sorted { ($0 as Detalle).indice < ($1 as Detalle).indice }
            } else {
                results = periodos
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        break
    }
    
    return results
}

// MARK: - Procedimientos para operar fechas
func firstDayOf(month: Int, year: Int) -> NSDate {
    var startDate = NSDate()
    
    let strDate = ("\("01")-\(month)-\(year)")
    
    let fmtDate = DateFormatter()

    fmtDate.dateFormat = "dd-MM-yyyy"

    startDate = fmtDate.date(from: strDate)! as NSDate
    
    
    //let calendar = Calendar.currentCalendar()
    
    //let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
    
    //let lmonth = components.month
    //let lyear = components.year
    
    //let startOfMonth = ("\(year)-\(month)-01")
    
    //let components = calendar.components([.Year, .Month], fromDate: date)
    
    //let startOfMonth = calendar.dateFromComponents(components)!
    
    //print(dateFormatter.stringFromDate(startOfMonth)) // 2015-11-01
    //print("Fecha inicial: \(month)/\(year): \(startDate)")
    
    return startDate
}

func lastDayOf(month: Int, year: Int) -> NSDate {
    //let comps2 = NSDateComponents()
    
    //comps2.month = month
    //comps2.day = -1
    
    var lastDay = NSDate()
    
    let calendar = Calendar.current
    
    let startDate = firstDayOf(month: month, year: year)
    
    //let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: startDate, options: [])!
    
    let nextMonth = calendar.date(byAdding: .month, value: 1, to: startDate as Date)
    
    let date = calendar.date(byAdding: .day, value: -1, to: nextMonth!)
    
    lastDay = date! as NSDate
    //let fmtDate = DateFormatter()
    
    //fmtDate.dateFormat = "dd-MM-yyyy"

    //print(dateFormatter.stringFromDate(endOfMonth)) // 2015-11-30
    //print("Fecha inicial: \(month)/\(year): \(lastDay)")
    
    return lastDay

}

func daysBetween(startDay: NSDate, lastDay: NSDate) -> Int {
    let calendar = Calendar.current
    let dias =  Set<Calendar.Component>([.day])
    
    let result = calendar.dateComponents(dias, from: startDay as Date,  to: lastDay as Date)
    
    return result.day! + 1
}

func daysLeft(startDay: NSDate) -> Int {
    let calendar = Calendar.current
    let dias =  Set<Calendar.Component>([.day])
    let periodo = Set<Calendar.Component>([.month, .year])
    
    let comp = calendar.dateComponents(periodo, from: startDay as Date)
    
    let lastDay = lastDayOf(month: comp.month!, year: comp.year!)
    
    let result = calendar.dateComponents(dias, from: startDay as Date,  to: lastDay as Date)
    
    return result.day! + 1
}

func samePeriod(reference date1: NSDate, compareTo date2: NSDate) -> Bool {
    var isEqual: Bool = false
    
    let calendar = Calendar.current
    let setPeriod = Set<Calendar.Component>([.month, .year])
    
    let refPeriod = calendar.dateComponents(setPeriod, from: date1 as Date)
    
    //dateComponents(setPeriod, from: date1 as Date)
    let compareToPeriod = calendar.dateComponents(setPeriod, from: date2 as Date)
    
    if refPeriod.year == compareToPeriod.year && refPeriod.month == compareToPeriod.month {
        isEqual = true
    }
    return isEqual
}

func valorFormateado(valor: Double, decimales: Int, estilo: NumberFormatter.Style = .none) -> String {
    let fmtNumber = NumberFormatter()
    
    fmtNumber.numberStyle = estilo
    fmtNumber.maximumFractionDigits = decimales
    
    return fmtNumber.string(from: NSNumber.init(value: valor))!
}

extension String {
    func getFilenameWithoutExtension() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func getFileExtension() -> String {
        return (self as NSString).pathExtension
    }
    
    func occurrencies(_ chr: Character) -> Int {
        var count: Int = 0
        for char in self.characters {
            if char == chr {
                count += 1
            }
        }
        return count
    }
}
