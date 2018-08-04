//
//  VCPreviewReport.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 15/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import MessageUI

class VCPreviewReport: UIViewController {

    
    @IBOutlet weak var wvPreview: UIWebView!
    
    
    var reporte: CompositorReporte? = nil
    var contenidoHTML: String!
    var pdfFileExported: URL!
    
    var tarjeta: Tarjeta? = nil
    var compra: Compra? = nil
    
    
    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initTableView(tableView: self.tvTarjetas, backgroundColor: UIColor.customUltraLightBlue())
        
        //initTableView(tableView: self.tvCompras, backgroundColor: UIColor.clear)
        
        //initToolBar(toolbarDesign: .toLeftBackToRightPDFStyle, actions: [nil, #selector(self.btnPDFExport(_:))], title: "Previsualización")
        
        //initSearchBar(tableView: tvEvaluaciones)
        
        //configSearchBar(tableView: tvCompras)
        
        //self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        //self.tvPeriodos.isHidden = true
        
        //initViewForPicker()
        
        //initFormatters()
        
        //initDatePickers()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadPreferences()

        createReportAsHTML()
        
        //restrictRotation(restrict: false)

        var items = [AnyObject]()
        items.append(UIBarButtonItem(title: "Opciones", style: .plain, target: self,action: #selector(self.showOptionsAlert)))
        self.toolbarItems = items as? [UIBarButtonItem]

    }

    func createReportAsHTML() {
        reporte = CompositorReporte()
        if let reporteHTML = reporte?.renderizarReporte(tarjeta: tarjeta, compra: compra) {
            
            //print("URL: \(String(describing: reporte?.pathToProyeccionHTMLTemplate!))")
            
            //print("HTML: \(reporteHTML)")
            
            wvPreview.loadHTMLString(reporteHTML, baseURL: reporte?.pathToProyeccionHTMLTemplate)
            
            contenidoHTML = reporteHTML
            
        }
    }
    
    func btnPDFExport(_ sender: UIBarButtonItem? = nil) {
        //pdfFileExported = reporte?.exportToPDF(HTMLContent: contenidoHTML, tipoReporte: .compra, formatter: (wvPreview?.viewPrintFormatter())!)
        
        //wvPreview.loadRequest(URLRequest(url: urlPDF!))
    }
    
    
    @objc func showOptionsAlert(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Exportar", message: "El detalle de las cuotas simuladas se ha exportado en un archivo PDF.\n\n¿Qué deseas hacer?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let actionPreview = UIAlertAction(title: "Previsualizar el PDF", style: UIAlertActionStyle.default) { (action) in
            
            DispatchQueue.main.async(execute: {
                self.pdfFileExported = self.reporte?.exportToPDF(HTMLContent: self.contenidoHTML, tipoReporte: .compra, formatter: (self.wvPreview?.viewPrintFormatter())!)
                
                //print("\nArchivo generado: \(self.pdfFileExported!)")
            })
            
            

            DispatchQueue.main.async(execute: {self.wvPreview.loadRequest(URLRequest(url: self.pdfFileExported!))})
        }
        
        let actionEmail = UIAlertAction(title: "Enviar PDF por E-Mail", style: UIAlertActionStyle.default) { (action) in
            DispatchQueue.main.async(execute: {
                self.pdfFileExported = self.reporte?.exportToPDF(HTMLContent: self.contenidoHTML, tipoReporte: .compra, formatter: (self.wvPreview?.viewPrintFormatter())!)
                
                //print("\nArchivo generado: \(self.pdfFileExported!)")
            })
            
            DispatchQueue.main.async(execute: {self.sendEmail()})

            
        }
        
        let actionCancel = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default) { (action) in print(action)
        }
        
        alert.addAction(actionPreview)
        alert.addAction(actionEmail)
        alert.addAction(actionCancel)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }

        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VCPreviewReport: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            
            mail.mailComposeDelegate = self
            mail.setToRecipients([])
            mail.setMessageBody("<p>En este mensaje se encuentra adjunto el archivo PDF que contiene los datos proyectados.</p>", isHTML: true)
            
            let filename: String = "ProyeccionCuotas_".appending(genFileNameFromDateTime(sufix: "pdf"))
        
            do {
                try  mail.addAttachmentData(NSData(contentsOfFile: (self.pdfFileExported.relativePath)) as Data, mimeType: "application/pdf", fileName: filename)
            } catch {
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Ocurrió  un error al intentar enviar el correo.  \(error.localizedDescription)", toFocus: nil)
            }
            
            self.present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            //showCustomWarningAlert("You must authorize sending e-mail.", toFocus: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
