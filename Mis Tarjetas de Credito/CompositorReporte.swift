//
//  CompositorReporte.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 15/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CompositorReporte: NSObject {
    
    let pathToProyeccionHTMLTemplate = Bundle.main.url(forResource: "ProyeccionCuota", withExtension: "html")
    
    let pathToDetalleHTMLTemplate = Bundle.main.url(forResource: "detallecuota", withExtension: "html")

    let pathToUltimoDetalleHTMLTemplate = Bundle.main.url(forResource: "ultimodetallecuota", withExtension: "html")
    
    let pdfFileReportCompra: String = "reporteCompra.pdf"
    let pdfFileReportExtracto: String = "reporteExtracto.pdf"
    
    override init() {
        super.init()
    }
    
    func renderizarReporte(tarjeta: Tarjeta?, compra: Compra?) -> String! {
        // Store the invoice number for future use.
        //self.invoiceNumber = invoiceNumber

        let fmtDate = DateFormatter()
        fmtDate.dateFormat = "dd-MM-yyyy"
        
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOf: self.pathToProyeccionHTMLTemplate!, encoding: String.Encoding.utf8)
            
                //String(contentsOf: self.pathToProyeccionHTMLTemplate!)
            
            // Replace all the placeholders with real values except for the items.
            // The logo image.
            
            var imagen: String? = nil
            
            if compra?.imagen == nil {
                imagen = "icono-bolsocompra.png"
            } else {
                imagen =  getImageFullPathFrom(directory: "Images", fileName: (compra?.imagen!)!)
            }

            HTMLContent = HTMLContent.replacingOccurrences(of: "#IMAGEN_COMPRA#", with: imagen!)

            HTMLContent = HTMLContent.replacingOccurrences(of: "#NUMERO_TARJETA#", with: (tarjeta?.numero)!)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#CUPO_TARJETA#", with: valorFormateado(valor: (tarjeta?.cupo)!, decimales: 2, estilo: .decimal))

            HTMLContent = HTMLContent.replacingOccurrences(of: "#CUPO_DISPONIBLE#", with: valorFormateado(valor: (tarjeta?.disponible)!, decimales: 2, estilo: .decimal))
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#VALOR_COMPRA#", with: valorFormateado(valor: (compra?.valor)!, decimales: 2, estilo: .decimal))
            
            let date = compra?.fecha as Date?
            
            if (date == nil) {
                HTMLContent = HTMLContent.replacingOccurrences(of: "#FECHA_COMPRA#", with: "N.A.")
            } else {
                HTMLContent = HTMLContent.replacingOccurrences(of: "#FECHA_COMPRA#", with: fmtDate.string(from: (date)!))
            }


            HTMLContent = HTMLContent.replacingOccurrences(of: "#DESCRIPCION_COMPRA#", with: (compra?.descripcion)!)

            HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_A_PAGAR#", with: valorFormateado(valor: (compra?.totalAPagar())!, decimales: 2, estilo: .decimal))


            // The invoice items will be added by using a loop.
            var detalles = ""
            
            let proyecciones = compra?.obtenerProyecciones()
            
            //let conteo = proyecciones?.count
            
            // For all the items except for the last one we'll use the "single_item.html" template.
            // For the last one we'll use the "last_item.html" template.
            for proyeccion in proyecciones! {
                
                var itemHTMLContent: String!
                
                // Determine the proper template file.
                if NSNumber.init(value: (proyeccion as! Proyeccion).cuota).intValue != (proyecciones?.count)! {
                    itemHTMLContent = try String(contentsOf: self.pathToDetalleHTMLTemplate!, encoding: String.Encoding.utf8)
                        //String(contentsOf: self.pathToDetalleHTMLTemplate!)
                }
                else {
                    itemHTMLContent = try String(contentsOf: self.pathToUltimoDetalleHTMLTemplate!, encoding: String.Encoding.utf8)
                        
                        //String(contentsOf: self.pathToUltimoDetalleHTMLTemplate!)
                }
                
                // Replace the description and price placeholders with the actual values.
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CUOTA#", with: valorFormateado(valor: (proyeccion as! Proyeccion).cuota, decimales: 0, estilo: .decimal))
                    
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#FECHA_CORTE#", with: (fmtDate.string(from: (proyeccion as! Proyeccion).fechaCorte! as Date)))
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#VALOR_COMPRA#", with: valorFormateado(valor: (proyeccion as! Proyeccion).valor, decimales: 2, estilo: .decimal))

                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#DIAS#", with: valorFormateado(valor: (proyeccion as! Proyeccion).dias, decimales: 0, estilo: .decimal))
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#INTERES_DIARIO#", with: valorFormateado(valor: (proyeccion as! Proyeccion).temd, decimales: 6, estilo: .decimal))
                    
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#SALDO#", with: valorFormateado(valor: (proyeccion as! Proyeccion).saldo, decimales: 2, estilo: .decimal))

                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#VALOR_CUOTA#", with: valorFormateado(valor: (proyeccion as! Proyeccion).valorCuota, decimales: 2, estilo: .decimal))
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#TOTAL_INTERESES#", with: valorFormateado(valor: (proyeccion as! Proyeccion).interes, decimales: 2, estilo: .decimal))

                let valorTotalCuota: Double = (proyeccion as! Proyeccion).interes + (proyeccion as! Proyeccion).valorCuota

                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#TOTAL_CUOTA#", with: valorFormateado(valor: valorTotalCuota, decimales: 2, estilo: .decimal))

                
                // Add the item's HTML code to the general items string.
                detalles += itemHTMLContent
            }
            
            // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: detalles)
            
            // The HTML code is ready.
            return HTMLContent

        }
        catch {
            print("Unable to open and use HTML template files. Error: \(error.localizedDescription)")
        }
        
        return nil
    }

    // Create a PDF document from the HTML to be shared
    func pdfGenerator(htmlContent: String, formatter: UIViewPrintFormatter) -> NSMutableData {
        // Format HTML
        //let fmt = UIMarkupTextPrintFormatter(markupText: htmlContent)
        
        //let fmt = UIViewPrintFormatter()

        // Assign print formatter to UIPrintPageRenderer
        let render = UIPrintPageRenderer()
        
        render.addPrintFormatter(formatter, startingAtPageAt: 0)
        
        // Assign paperRect and printableRect
        let page = CGRect(x: 0, y: 0, width: 8.5 * 72, height: 11 * 72) // Letter US at 72 dpi
        
        let printable = page.insetBy(dx: 0, dy: 0)
        
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        // Create PDF context and draw
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        
        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        
        return pdfData
    }
    
    func drawPDFWith(renderer: UIPrintPageRenderer, pdfFileName: String) -> NSData! {
        let data = NSMutableData()
        
        // original line
        //UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        
        UIGraphicsBeginPDFContextToFile(pdfFileName, CGRect.zero, nil)
    
        // original line
        //UIGraphicsBeginPDFPage()
        UIGraphicsBeginPDFPageWithInfo(CGRect.init(x: 0, y: 0, width: 612, height: 756), nil)
    
        
        for page in 1...renderer.numberOfPages {
            UIGraphicsBeginPDFPage();
            renderer.drawPage(at: page - 1, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
    
        return data
    }

    func exportToPDF(HTMLContent: String, tipoReporte: Reporte, formatter: UIViewPrintFormatter) -> URL {
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let path = paths.appendingPathComponent("reports")

        if isAValidDirectory(directory: "reports") {
            
            var pdfFileName: String?
            
            if tipoReporte == .compra {
                pdfFileName = pdfFileReportCompra
            } else if tipoReporte == .extracto {
                pdfFileName = pdfFileReportExtracto
            }
            
            
            let fullPath = path.appendingPathComponent(pdfFileName!)
            
            //print("File name: \(fileName)")
            //print("Full path: \(fullPath)")
            
            pdfGenerator(htmlContent: HTMLContent, formatter: formatter).write(to: fullPath, atomically: false)
            
            return fullPath
                
        }
        
        return path
    }
    
}
