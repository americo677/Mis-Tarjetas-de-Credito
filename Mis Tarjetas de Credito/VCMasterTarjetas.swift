//
//  VCMasterTarjetas.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 7/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCMasterTarjetas: UIViewController {

    @IBOutlet weak var tfNumeroTarjeta: UITextField!
    
    @IBOutlet weak var tfBanco: UITextField!
    
    @IBOutlet weak var tfFranquicia: UITextField!
    
    @IBOutlet weak var tfCupoAsignado: UITextField!
    
    @IBOutlet weak var tfTEAVigente: UITextField!
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()

    var boolEsNuevo: Bool = false
    var boolEsModificacion: Bool = false
    var boolEsConsulta: Bool = false
    
    var tarjeta: Tarjeta? = nil
    
    let fmtFloat: NumberFormatter = NumberFormatter()
    let fmtMon: NumberFormatter = NumberFormatter()
    let fmtPor: NumberFormatter = NumberFormatter()
    
    var pckrFranquicias = UIPickerView()
    
    var activeTextField = UITextField()
    
    var franquicia: Franquicia? = nil

    // MARK: - Inicializa formateadores numéricos
    func initFormatters() {
        // Preparación del formateador de fecha
        //dtFormatter.dateFormat = "dd/MM/yyyy"
        
        // Preparación de los formateadores númericos
        fmtFloat.numberStyle = .none
        fmtFloat.maximumFractionDigits = 2
        
        fmtMon.numberStyle = .currency
        fmtMon.maximumFractionDigits = 2
        
        fmtPor.numberStyle = .percent
        fmtPor.maximumFractionDigits = 2
        
    }

    // MARK: - Rutinas para selección y cancelación del pickerview
    @objc func donePicker(for sender: UIBarButtonItem) {
        self.activeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    // MARK: - Rutinas para selección y cancelación del pickerview
    @objc func cancelPicker(for sender: UIBarButtonItem) {
        self.activeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }

    // MARK: - Inicializador de los textfields
    func initTextFields(_ lTarjeta: Tarjeta? = nil) {
        if lTarjeta == nil {
            
            self.tfNumeroTarjeta.text = ""
            self.tfBanco.text = ""
            self.tfFranquicia.text = ""
            self.tfCupoAsignado.text = ""
            self.tfTEAVigente.text = ""
            
            self.tfNumeroTarjeta.keyboardType = .numberPad
            self.tfCupoAsignado.keyboardType = .decimalPad
            self.tfTEAVigente.keyboardType = .decimalPad
            
            loadPickerView(&self.pckrFranquicias, indiceSeleccionado:  Global.defaultIndex.franquicia, indicePorDefecto: Global.defaultIndex.franquicia, tag: 1, textField: self.tfFranquicia, opciones: Global.arreglo.franquicias, accionDone: #selector(donePicker(for:)), accionCancel: #selector(cancelPicker(for:)))
            
        } else {
            // se cargan los datos si la vista es para consultar un programa
        }
    }
    
    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initToolBar(toolbarColor: UIColor.customOceanBlue())
        
        if self.boolEsNuevo {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Nueva Tarjeta")
        } else if self.boolEsModificacion {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Modificación de Tarjeta")
        } else {
            initToolBar(toolbarDesign: .toLeftBackToRightStyle, actions: [nil], title: "Consulta de Tarjeta")
        }
        
        //self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        initFormatters()
        
        //initDatePickers()
        
        // Inicializa los textfields y los pickerviews
        initTextFields()
        
        //restrictRotation(restrict: false)
        
        // initViewForPicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPreferences()
        
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Función para recuperar la data de la BD
    func getData() {
        
    }
    
    // MARK: - Función para desplegar los datos recuperados por pantalla
    func showData() {
        if self.tarjeta != nil {
            self.tfNumeroTarjeta.text = self.tarjeta?.numero
            self.tfBanco.text = self.tarjeta?.banco
            self.tfFranquicia.text = self.tarjeta?.franquicia?.capitalized
            self.tfCupoAsignado.text = fmtMon.string(from: NSNumber.init(value: (self.tarjeta?.cupo)!))
            self.tfTEAVigente.text = fmtFloat.string(from: NSNumber.init(value: (self.tarjeta?.teaVigente)!))!
        } else {
            self.tfNumeroTarjeta.text = ""
            self.tfBanco.text = ""
            self.tfFranquicia.text = ""
            self.tfCupoAsignado.text = ""
            self.tfTEAVigente.text = ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // para consultar el único programa esperado
        self.getData()
        
        self.showData()
    }
    
    // MARK: - Funciones de los UIPickerViews
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return Global.arreglo.franquicias.count
        //} else {
        //    return Global.arreglo.nivelAcademico.count
        }
        return 0
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //if pickerView.tag == 1 {
            return Global.arreglo.franquicias[row]
        //} else {
        //    return Global.arreglo.nivelAcademico[row]
        //}
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.tfFranquicia.text = Global.arreglo.franquicias[row]
        //} else {
        //    self.tfNivelAcademico.text = Global.arreglo.nivelAcademico[row]
        //    self.indiceNivelAcademico = (row as NSNumber).doubleValue
        //    self.programa?.setValue(self.indiceNivelAcademico, forKey: "indiceNivelAcademico")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Procedimiento de preparación y validación de datos ingresados para guardado
    func prepararDatos(isDataReady isComplete: inout Bool) {
        isComplete = true
        
        //self.tfNumeroTarjeta.text = ""
        if !self.tfNumeroTarjeta.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar un número válido de tarjeta de crédito", toFocus: self.tfNumeroTarjeta)
        }
        
        //self.tfBanco.text = ""
        if !self.tfBanco.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre de la entidad financiera.", toFocus: self.tfBanco)
        }
        
        //self.tfFranquicia.text = ""
        if !self.tfFranquicia.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la franquicia.", toFocus: self.tfFranquicia)
        }
        
        //self.tfCupoAsignado.text = ""
        if !self.tfCupoAsignado.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el cupo asignado.", toFocus: self.tfCupoAsignado)
        }
        
        //self.tfTEAVigente.text = ""
        if !self.tfTEAVigente.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la tasa efectiva anual vigente.", toFocus: self.tfTEAVigente)
        }
        
        if isComplete {
            if self.boolEsNuevo {
                
                let tarjeta = NSEntityDescription.insertNewObject(forEntityName: "Tarjeta", into: self.moc)
                
                let nuevoIndice: Double = (tarjeta as! Tarjeta).obtenerNuevoIndice()
                
                tarjeta.setValue(nuevoIndice, forKey: "indice")
                
                tarjeta.setValue(self.tfNumeroTarjeta.text, forKey: "numero")
                
                tarjeta.setValue(self.tfBanco.text, forKey: "banco")
                
                tarjeta.setValue(self.tfFranquicia.text, forKey: "franquicia")
                
                tarjeta.setValue(fmtMon.number(from: self.tfCupoAsignado.text!)?.doubleValue, forKey: "cupo")
                
                tarjeta.setValue(fmtMon.number(from: self.tfCupoAsignado.text!)?.doubleValue, forKey: "disponible")

                tarjeta.setValue(fmtFloat.number(from:  self.tfTEAVigente.text!), forKey: "teaVigente")
                
            } else if self.boolEsModificacion {
                
                self.tarjeta?.setValue(self.tfNumeroTarjeta.text, forKey: "numero")
                
                self.tarjeta?.setValue(self.tfBanco.text, forKey: "banco")
                
                self.tarjeta?.setValue(self.tfFranquicia.text, forKey: "franquicia")
                
                self.tarjeta?.setValue(fmtMon.number(from: self.tfCupoAsignado.text!)?.doubleValue, forKey: "cupo")
                
                self.tarjeta?.setValue(fmtMon.number(from: self.tfCupoAsignado.text!)?.doubleValue, forKey: "disponible")

                self.tarjeta?.setValue(fmtFloat.number(from:  self.tfTEAVigente.text!), forKey: "teaVigente")
            }
        }
    }
    
    // MARK: - Precedimiento de guardado
    func guardar() -> Bool {
        var canISave: Bool = true
        do {
            prepararDatos(isDataReady: &canISave)
            
            if canISave {
                
                try self.moc.save()
                
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la tarjeta fueron grabados con éxito.", toFocus: nil)
                
                self.loadPreferences()
            }
        } catch let error as NSError {
            print("No se pudo guardar los datos de la tarjeta.  Error: \(error)")
        }
        return canISave
    }

    // MARK: - Botón Guardar
    @objc func btnGuardarOnTouchUpInside(_ sender: AnyObject) {
        // code for saving here
        
        _ = self.guardar()
    }

    @IBAction func tfAnyOnEditingDidEnd(_ sender: UITextField) {
        
        if sender == tfNumeroTarjeta {
            //NSString *formattedCCNumber
            
            let creditCardNumber: NSString? = sender.text! as NSString
            var creditCardNumberFormatted: NSString?
            
            let longitudNumeroTC = (sender.text?.characters.count)!
            
            if longitudNumeroTC == 16 {
                //formattedCCNumber = [self.creditCardNumber stringByReplacingOccurrencesOfString:@"(\\d{4})(\\d{4})(\\d{4})(\\d+)" withString:@"$1-$2-$3-$4" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.creditCardNumber length])];
                
                creditCardNumberFormatted = creditCardNumber?.replacingOccurrences(of: "(\\d{4})(\\d{4})(\\d{4})(\\d+)", with: "$1 $2 $3 $4", options: String.CompareOptions.regularExpression, range: NSRange(location: 0, length: longitudNumeroTC)) as? NSString
                
            } else if longitudNumeroTC == 15 {
                //formattedCCNumber = [self.creditCardNumber stringByReplacingOccurrencesOfString:@"(\\d{4})(\\d{6})(\\d+)" withString:@"$1-$2-$3" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.creditCardNumber length])];
                
                creditCardNumberFormatted = creditCardNumber?.replacingOccurrences(of: "(\\d{4})(\\d{6})(\\d+)", with: "$1 $2 $3", options: String.CompareOptions.regularExpression, range: NSRange(location: 0, length: longitudNumeroTC)) as? NSString
                
                //NSRange(location:0, length: longitudNumeroTC))
            } else if longitudNumeroTC == 19 || longitudNumeroTC == 17 {
                if (longitudNumeroTC == 19 && (creditCardNumber! as String).occurrencies(" ") == 3) {
                    creditCardNumberFormatted = sender.text! as NSString
                } else if (longitudNumeroTC == 17 && (creditCardNumber! as String).occurrencies(" ") == 2) {
                    creditCardNumberFormatted = sender.text! as NSString
                } else {
                    //creditCardNumberFormatted = (sender.text! as NSString).substring(to: 16) as NSString
                    creditCardNumberFormatted = sender.text! as NSString
                    sender.text = ""
                    showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Por favor verifique el número de la tarjeta de crédito.", toFocus: self.tfNumeroTarjeta)
                    return
                }
                
            } else {
                //creditCardNumberFormatted = (sender.text! as NSString).substring(to: 16) as NSString
                creditCardNumberFormatted = sender.text! as NSString
                sender.text = ""
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Por favor verifique el número de la tarjeta de crédito.", toFocus: self.tfNumeroTarjeta)
                return
            }
            
            //self.ccNumberTextField.text = formattedCCNumber;
            sender.text = creditCardNumberFormatted! as String
            
        } else if sender == tfCupoAsignado {
            
            if sender.hasText {
                var cupo: Double = 0
                
                if fmtMon.number(from: sender.text!)?.doubleValue == nil {
                    cupo = fmtFloat.number(from: sender.text!)!.doubleValue
                } else {
                    cupo = fmtMon.number(from: sender.text!)!.doubleValue
                }
                sender.text = valorFormateado(valor: cupo, decimales: 2, estilo: .currency)
            }
            
        } else if sender == tfTEAVigente {
            if sender.hasText {
                let tasa: Double = fmtFloat.number(from: sender.text!)!.doubleValue
                sender.text = valorFormateado(valor: tasa, decimales: 2, estilo: .decimal)
            }
        }
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

extension VCMasterTarjetas: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
}
