//
//  VCMasterCompras.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 7/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCMasterCompras: UIViewController {

    @IBOutlet weak var tfDescripcion: UITextField!

    @IBOutlet weak var tfComercio: UITextField!
    
    @IBOutlet weak var tfFecha: UITextField!
    
    @IBOutlet weak var tfValor: UITextField!
    
    @IBOutlet weak var tfPlazo: UITextField!
    
    @IBOutlet weak var ivCompra: UIImageView!
    
    @IBOutlet weak var tfTEA: UITextField!
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    
    var viImagen: UIImageView!
    var ipcControlador: UIImagePickerController!
    var nombreArchivoImagen: String? = nil
    var nombreImagenSeleccionada: String? = nil
    
    var boolEsNuevo: Bool = false
    var boolEsModificacion: Bool = false
    var boolEsConsulta: Bool = false
    
    let dpFecha: UIDatePicker = UIDatePicker()
    
    let fmtDate: DateFormatter = DateFormatter()
    let fmtFloat: NumberFormatter = NumberFormatter()
    let fmtMon: NumberFormatter = NumberFormatter()
    let fmtPor: NumberFormatter = NumberFormatter()
    
    var compra: Compra? = nil
    var tarjeta: Tarjeta? = nil
    
    // MARK: - Inicializa formateadores numéricos
    func initFormatters() {
        // Preparación del formateador de fecha
        fmtDate.dateFormat = "dd/MM/yyyy"
        
        // Preparación de los formateadores númericos
        fmtFloat.numberStyle = .none
        fmtFloat.maximumFractionDigits = 2
        
        fmtMon.numberStyle = .currency
        fmtMon.maximumFractionDigits = 2
        
        fmtPor.numberStyle = .percent
        fmtPor.maximumFractionDigits = 2
        
    }

    // MARK: - Inicializador de los textfields
    func initTextFields(_ lTarjeta: Tarjeta? = nil) {
        if lTarjeta == nil {
            
            self.tfDescripcion.text = ""
            self.tfComercio.text = ""
            self.tfFecha.text = ""
            self.tfValor.text = ""
            self.tfPlazo.text = ""
            self.tfTEA.text = ""
            
            self.tfValor.keyboardType = .decimalPad
            self.tfPlazo.keyboardType = .decimalPad
            self.tfTEA.keyboardType = .decimalPad
            
            self.ivCompra.image = UIImage(named: "icono-bolsocompra.png")

            //loadPickerView(&self.pckrFranquicias, indiceSeleccionado:  Global.defaultIndex.franquicia, indicePorDefecto: Global.defaultIndex.franquicia, tag: 1, textField: self.tfFranquicia, opciones: Global.arreglo.franquicias, accionDone: #selector(donePicker(for:)), accionCancel: #selector(cancelPicker(for:)))
            
        } else {
            // se cargan los datos si la vista es para consultar un programa
        }
    }

    // MARK: - Manipulación de DatePicker
    @objc func handleDatePicker(_ sender: UITextField) {
        let picker: UIDatePicker = tfFecha.inputView as! UIDatePicker
        
        tfFecha.text = fmtDate.string(from: picker.date)
        
        //presupuesto?.setValue(picker.date, forKey: smModelo.smPresupuesto.colFechaIni)
        
        tfFecha.resignFirstResponder()
    }

    // MARK: - Inicializador de los UIDatePickers
    func initDatePickers() {
        dpFecha.date = Date()
        dpFecha.datePickerMode = UIDatePickerMode.date
        //datePickerIni.addTarget(self, action: #selector(TVCPresupuesto.handleDatePickerIni(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tfFecha.inputView = dpFecha
        
        let tbFecha         = UIToolbar()
        tbFecha.barStyle    = UIBarStyle.default
        tbFecha.isTranslucent = true
        
        //toolBar.tintColor = UIColor.whiteColor()
        tbFecha.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.handleDatePicker(_:)))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let btnCancel = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.handleDatePicker(_:)))
        
        tbFecha.setItems([btnCancel, btnSpace, btnDone], animated: false)
        tbFecha.isUserInteractionEnabled = true
        
        self.tfFecha.inputAccessoryView = tbFecha
    }

    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initToolBar(toolbarColor: UIColor.customOceanBlue())
        
        self.nombreImagenSeleccionada = ""
        
        if self.boolEsNuevo {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Nueva Compra")
        } else if self.boolEsModificacion {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Modificación de Compra")
        } else {
            initToolBar(toolbarDesign: .toLeftBackToRightStyle, actions: [nil], title: "Consulta de Compra")
        }
        
        //self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        initFormatters()
        
        initDatePickers()
        
        // Inicializa los textfields y los pickerviews
        initTextFields()
        
        // initViewForPicker()
        self.showData()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPreferences()
        
        hideKeyboardWhenTappedAround()
        
        //restrictRotation(restrict: false)
    }

    // MARK: - Función para recuperar la data de la BD
    func getData() {
        
        
    }
    
    // MARK: - Función para desplegar los datos recuperados por pantalla
    func showData() {
        if self.compra != nil {
            self.tfDescripcion.text = self.compra?.descripcion
            self.tfComercio.text = self.compra?.comercio
            self.tfFecha.text = fmtDate.string(from: (self.compra?.fecha)! as Date)
            self.tfValor.text = fmtMon.string(from: NSNumber.init(value: (self.compra?.valor)!))
            self.tfPlazo.text = fmtFloat.string(from: NSNumber.init(value: (self.compra?.plazo)!))!

            self.tfTEA.text = fmtFloat.string(from: NSNumber.init(value: (self.compra?.tea)!))!

            if (self.compra?.imagen != nil) {
                if self.nombreImagenSeleccionada != "" {
                    self.nombreArchivoImagen = self.nombreImagenSeleccionada
                } else {
                    self.nombreArchivoImagen = self.compra?.imagen!
                }
                
                //self.ivCompra.image = getImageFrom(directory: Global.Path.imagenes, fileName: (self.compra?.imagen!)!)
                self.ivCompra.image = getImageFrom(directory: Global.Path.imagenes, fileName: (self.nombreArchivoImagen)!)
            } else {
                self.ivCompra.image = UIImage(named: "icono-bolsocompra.png")
            }
        } else {
            self.tfDescripcion.text = ""
            self.tfComercio.text = ""
            self.tfFecha.text = ""
            self.tfValor.text = ""
            self.tfPlazo.text = ""
            
            self.tfTEA.text = fmtFloat.string(from: NSNumber.init(value: (self.tarjeta?.teaVigente)!))!
            
            self.nombreArchivoImagen = nil
            //self.nombreImagenSeleccionada = ""
                
            //self.ivCompra.image = UIImage(named: "icono-bolsocompra.png")
            if (self.nombreImagenSeleccionada != "") {
                self.nombreArchivoImagen = self.nombreImagenSeleccionada

                //if self.nombreImagenSeleccionada != "" {
                //    self.nombreArchivoImagen = self.nombreImagenSeleccionada
                //} else {
                //    self.nombreArchivoImagen = self.compra?.imagen!
                //}
                
                //self.ivCompra.image = getImageFrom(directory: Global.Path.imagenes, fileName: (self.compra?.imagen!)!)
                self.ivCompra.image = getImageFrom(directory: Global.Path.imagenes, fileName: (self.nombreArchivoImagen)!)
            } else {
                self.ivCompra.image = UIImage(named: "icono-bolsocompra.png")
            }

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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let isOk = self.guardar()
        
        if isOk {
            if self.boolEsNuevo {
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la compra fueron grabados con éxito.", toFocus: nil)
            } else {
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la compra fueron actualizados con éxito.", toFocus: nil)
            }
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
        if !self.tfDescripcion.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la descripción de la compra", toFocus: self.tfDescripcion)
        }
        
        //self.tfBanco.text = ""
        if !self.tfComercio.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre del establecimiento o negocio donde resalizó la compra.", toFocus: self.tfComercio)
        }
        
        //self.tfFranquicia.text = ""
        if !self.tfFecha.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la fecha de compra.", toFocus: self.tfFecha)
        }
        
        //self.tfCupoAsignado.text = ""
        if !self.tfValor.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el valor de la compra.", toFocus: self.tfValor)
        }
        
        //self.tfTEAVigente.text = ""
        if !self.tfPlazo.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el plazo que seleccionó para el pago de la compra.", toFocus: self.tfPlazo)
        }
        
        if !self.tfTEA.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la tasa que se aplicará para el cálculo de los intereses.", toFocus: self.tfPlazo)
        }
        
        if isComplete {
            if self.boolEsNuevo {
                
                let compra = NSEntityDescription.insertNewObject(forEntityName: "Compra", into: self.moc)
                
                let nuevoIndice: Double = (compra as! Compra).obtenerNuevoIndice()
                
                compra.setValue(nuevoIndice, forKey: "indice")
                
                compra.setValue(self.tfDescripcion.text, forKey: "descripcion")
                
                compra.setValue(self.tfComercio.text, forKey: "comercio")
                
                compra.setValue(fmtDate.date(from: (self.tfFecha.text)!), forKey: "fecha")
                
                compra.setValue(fmtMon.number(from: self.tfValor.text!)?.doubleValue, forKey: "valor")
                
                compra.setValue(fmtFloat.number(from:  self.tfPlazo.text!), forKey: "plazo")
                
                compra.setValue(fmtFloat.number(from:  self.tfTEA.text!), forKey: "tea")
                
                if self.nombreArchivoImagen != nil {
                    compra.setValue(self.nombreArchivoImagen, forKey:"imagen")
                } else {
                    compra.setValue("icono-bolsocompra.png", forKey: "imagen")
                }
                
                self.tarjeta?.addToCompras(compra: compra as! Compra)
                
            } else if self.boolEsModificacion {
                
                //self.compra.setValue(nuevoIndice, forKey: "indice")
                
                self.compra?.setValue(self.tfDescripcion.text, forKey: "descripcion")
                
                self.compra?.setValue(self.tfComercio.text, forKey: "comercio")
                
                self.compra?.setValue(fmtDate.date(from: (self.tfFecha.text)!), forKey: "fecha")
                
                //self.compra?.setValue(fmtFloat.number(from: self.tfValor.text!)?.doubleValue, forKey: "valor")
                
                let valorCompra: Double = (fmtMon.number(from: self.tfValor.text!)?.doubleValue)!
                //print("valor de la compra a modificar: \(valorCompra)")
                self.compra?.actualizar(valor: valorCompra)
                
                self.compra?.setValue(fmtFloat.number(from:  self.tfPlazo.text!), forKey: "plazo")

                self.compra?.setValue(fmtFloat.number(from:  self.tfTEA.text!), forKey: "tea")

                if self.nombreArchivoImagen != "icono-bolsocompra.png" {
                    self.compra?.setValue(self.nombreArchivoImagen, forKey:"imagen")
                //} else {
                //    self.compra?.setValue("icono-bolsocompra.png", forKey: "imagen")
                }
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
                
                self.loadPreferences()
            }
        } catch {
            print("No se pudo guardar los datos de la compra.  Error: \(error.localizedDescription)")
        }
        return canISave
    }
    
    // MARK: - Botón Guardar
    @objc func btnGuardarOnTouchUpInside(_ sender: AnyObject) {
        // code for saving here
        
        let isOk = self.guardar()
        
        if isOk {
            if self.boolEsNuevo {
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la compra fueron grabados con éxito.", toFocus: nil)
            } else {
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la compra fueron actualizados con éxito.", toFocus: nil)
            }
        }
    }
    
    @IBAction func btnCalcularCuotasOnTouchUpInside(_ sender: UIButton) {
    }
    
    
    @IBAction func tfAnyOnEditingDidEnd(_ sender: UITextField) {
        
        if sender == tfValor {
            if sender.hasText {
                let valor: Double = fmtFloat.number(from: sender.text!)!.doubleValue
                sender.text = valorFormateado(valor: valor, decimales: 2, estilo: .currency)
            }
        } else if sender == tfPlazo {
            if sender.hasText {
                let plazo: Double = fmtFloat.number(from: sender.text!)!.doubleValue
                sender.text = valorFormateado(valor: plazo, decimales: 0)
            }
        } else if sender == tfTEA {
            if sender.hasText {
                let tasa: Double = fmtFloat.number(from: sender.text!)!.doubleValue
                sender.text = valorFormateado(valor: tasa, decimales: 2, estilo: .decimal)
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension VCMasterCompras: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Acciones de los botones de la vista
    @IBAction func btnTomarFotoOnTouchUpInside(_ sender: UIButton) {
        ipcControlador = UIImagePickerController()
        ipcControlador.delegate = self
        ipcControlador.sourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(ipcControlador, animated: true, completion: nil)
        } else {
            //print("No se ha detectado la presencia de cámara!")
            
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "No se ha detectado cámara en el dispositivo.  No es posible hacer la captura.", toFocus: nil)
        }
        
    }
    
    @IBAction func btnLibreriaFotosOnTouchUpInside(_ sender: UIButton) {
        ipcControlador = UIImagePickerController()
        ipcControlador.delegate = self
        ipcControlador.sourceType = .savedPhotosAlbum
        present(ipcControlador, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var iImagenParaGuardar: UIImage!
        
        ipcControlador.dismiss(animated: true, completion: nil)
        
        //self.ivCompra.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        iImagenParaGuardar = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        // Si se utilizó la cámara, se procede con la compresión y guardado.
        if picker.sourceType == .camera {
            
            //let resultado = guardarImagen(imagen: iImagenParaGuardar)
            
            self.nombreImagenSeleccionada = ""
            
            let resultado = saveImageIn(directory: Global.Path.imagenes, image: iImagenParaGuardar, fullFileName: &self.nombreImagenSeleccionada!)
            
            self.ivCompra.image = iImagenParaGuardar!
            
            if !resultado {
                self.nombreImagenSeleccionada = ""
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "La imagen no pudo ser guardada", toFocus: nil)
            //} else {
                //_ = guardar()
                
                //let isOk = self.guardar()
                
                //if isOk {
                //    if self.boolEsNuevo {
                //        showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la compra fueron grabados con éxito.", toFocus: nil)
                //    } else {
                //        showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la compra fueron actualizados con éxito.", toFocus: nil)
                //    }
                //}

            }
            // obtiene la data de la imagen con compresión al 0.6
            //let imageDataCompressed = UIImageJPEGRepresentation(iImagenParaGuardar!, 0.6)
            //let compressedJPEGImage = UIImage(data: imageDataCompressed!)!
            //UIImageWriteToSavedPhotosAlbum(compressedJPEGImage, nil, nil, nil)
        } else {
            //let copiado = guardarImagen(imagen: iImagenParaGuardar)
            //if self.nombreArchivoImagen == nil {
            self.nombreImagenSeleccionada = ""
            //}
            
            let copiado = saveImageIn(directory: Global.Path.imagenes, image: iImagenParaGuardar, fullFileName: &self.nombreImagenSeleccionada!)
            
            if !copiado {
                self.nombreImagenSeleccionada = ""
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "La imagen no pudo ser guardada", toFocus: nil)
            //} else {
                // _ = guardar()
                //let isOk = self.guardar()
                
                //if isOk {
                //    if self.boolEsNuevo {
                //        showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la compra fueron grabados con éxito.", toFocus: nil)
                //    } else {
                //        showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la compra fueron actualizados con éxito.", toFocus: nil)
                //    }
                //}

            }
        }
    }
    
}
