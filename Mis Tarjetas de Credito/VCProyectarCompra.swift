//
//  VCProyectarCompra.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 13/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCProyectarCompra: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tfValorCompra: UITextField!
    
    @IBOutlet weak var tfCuotas: UITextField!
    
    @IBOutlet weak var tfTEA: UITextField!
    
    @IBOutlet weak var tfIntereses: UITextField!
    
    @IBOutlet weak var tfPagoTotal: UITextField!
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()

    var tarjeta: Tarjeta? = nil
    var compra: Compra? = nil
    var proyeccion: Proyeccion? = nil

    let fmtDate: DateFormatter = DateFormatter()
    let fmtFloat: NumberFormatter = NumberFormatter()
    let fmtMon: NumberFormatter = NumberFormatter()
    let fmtPor: NumberFormatter = NumberFormatter()
    let fmtInt: NumberFormatter = NumberFormatter()

    
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
        
        fmtInt.numberStyle = .none
        fmtInt.maximumFractionDigits = 0
    }

    func initTextFields() {
        self.tfTEA.keyboardType = .decimalPad
        self.tfValorCompra.keyboardType = .decimalPad
        self.tfCuotas.keyboardType = .decimalPad
        self.tfIntereses.keyboardType = .decimalPad
        self.tfPagoTotal.keyboardType = .decimalPad
    }
    
    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initToolBar(toolbarColor: UIColor.customOceanBlue())
        
        initToolBar(toolbarDesign: .toLeftBackToRightStyle , actions: [nil], title: "Calcular")
        /*
        if self.boolEsNuevo {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Nueva Compra")
        } else if self.boolEsModificacion {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Modificación de Compra")
        } else {
            initToolBar(toolbarDesign: .toLeftBackToRighStyle, actions: [nil], title: "Consulta de Compra")
        }
 */
        
        //self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        initFormatters()
        
        //initDatePickers()
        
        // Inicializa los textfields y los pickerviews
        initTextFields()
        
        // initViewForPicker()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPreferences()
        
        //restrictRotation(restrict: false)
        
        hideKeyboardWhenTappedAround()
        
        //let separadorDecimal = NSLocale.current.decimalSeparator as String?
        
        //let paislocal = NSLocale.current.localizedString(forCollatorIdentifier: "country") as String!
        
        //let lenguaje = NSLocale.current.languageCode as String!
    
        //print("separador: \(separadorDecimal!) pais: \(paislocal!) lenguaje: \(lenguaje!)")
        
    }

    // MARK: - Función para recuperar la data de la BD
    func getData() {
        
        
    }
    
    // MARK: - Función para desplegar los datos recuperados por pantalla
    func showData() {
        if self.compra != nil {
            
            self.tfValorCompra.text = fmtMon.string(from: NSNumber.init(value: (self.compra?.valor)!))
            
            self.tfCuotas.text = fmtInt.string(from: NSNumber.init(value: (self.compra?.plazo)!))
            
            self.tfTEA.text = fmtFloat.string(from: NSNumber.init(value: (self.compra?.tea)!))
            
            self.tfIntereses.text = valorFormateado(valor: (self.compra?.totalIntereses)!, decimales: 2, estilo: .currency)
            
            self.tfPagoTotal.text = valorFormateado(valor: (self.compra?.totalIntereses)! + (self.compra?.valor)!, decimales: 2, estilo: .currency)
            
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
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        var text=""
        
        switch UIDevice.current.orientation {
        case .portrait:
            text="Portrait"
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            
            self.scrollView.contentSize.height = self.view.frame.height * 1.30
            self.scrollView.contentSize.width = self.view.frame.width
        case .landscapeRight:
            text="LandscapeRight"
            self.scrollView.contentSize.height = self.view.frame.height * 1.30
            self.scrollView.contentSize.width = self.view.frame.width
        default:
            text="Another"
        }
        
        NSLog("You have moved: \(text)")        
    }
    
    func calcularProyecciones() -> Int {
        var resultado: Int = 0
        
        let calendar = Calendar.current
        let comp = Set<Calendar.Component>([.month, .year])
        
        var cuota: Double = 0
        var fecha: NSDate? = (self.compra?.fecha)!
        
        let per = calendar.dateComponents(comp, from: fecha! as Date)
        var corte = lastDayOf(month: per.month!, year: per.year!)
        
        //var corte: NSDate = NSDate()
        
        //let res: Double = (5/4)
        //print("reultado: \(res)")
        //print("TEA: \((self.tfTEA.text)!)" )
        
        let tea: Double = (fmtFloat.number(from: self.tfTEA.text!)?.doubleValue)!
        
        //let tea: Double = Double.init((self.tfTEA.text)!)!
        
        
        let valor: Double = (self.compra?.valor)!
        var saldo: Double = valor
        let plazo: Double = Double.init((self.tfCuotas.text)!)!
        var dias: Double = 0
        let tediaria: Double = tea / 365 / 100
        var interesPeriodo: Double = 0
        var intereses: Double = 0
        var valorCuota: Double = 0
        var cuotaEInteres: Double = 0
        //var nuevoSaldo: Double = 0
        var totalIntereses: Double = 0
        var pagoTotal: Double = 0
        
        valorCuota = valor / plazo
        
        self.compra?.removerProyecciones()
        
        //_ = guardar()
        
        repeat {
            //tediaria = tea / 365 / 100
            dias = Double.init(daysLeft(startDay: fecha!))
            interesPeriodo = tediaria * dias
            saldo = valor - (cuota * valorCuota)
            if plazo == 1 {
                intereses = 0
            } else {
                intereses = saldo * interesPeriodo
            }
            cuotaEInteres = valorCuota + intereses
            totalIntereses += intereses
            pagoTotal += cuotaEInteres
            cuota += 1
            
            //print("Cuota: \(cuota) Fecha: \(fecha!) TEA: \(tea) Valor: \(valor) Plazo: \(plazo) TEDiaria: \(tediaria) Dias: \(dias) Saldo: \(saldo) Intereses: \(intereses) Valor Cuota: \(valorCuota) Pago Total Cuota: \(cuotaEInteres)")
            
            let proyeccion = NSEntityDescription.insertNewObject(forEntityName: "Proyeccion", into: self.moc)
            
            let nuevoIndice: Double = (proyeccion as! Proyeccion).obtenerNuevoIndice()
            
            proyeccion.setValue(nuevoIndice, forKey: "indice")
 
            //@NSManaged public var cuota: Double
            proyeccion.setValue(cuota, forKey: "cuota")
            
            //@NSManaged public var dias: Double
            proyeccion.setValue(dias, forKey: "dias")
            
            //@NSManaged public var fechaCorte: NSDate?
            proyeccion.setValue(corte, forKey: "fechaCorte")
            
            //@NSManaged public var indice: Double
            
            //@NSManaged public var interes: Double
            proyeccion.setValue(intereses, forKey: "interes")
            
            //@NSManaged public var mes: Double
            proyeccion.setValue(cuota, forKey: "mes")
            
            //@NSManaged public var plazo: Double
            proyeccion.setValue(plazo, forKey: "plazo")
            
            //@NSManaged public var saldo: Double
            proyeccion.setValue(saldo, forKey: "saldo")
            
            //@NSManaged public var tea: Double
            proyeccion.setValue(tea, forKey: "tea")
            
            //@NSManaged public var temd: Double
            proyeccion.setValue(tediaria, forKey: "temd")
            
            //@NSManaged public var valor: Double
            proyeccion.setValue(valor, forKey: "valor")
            
            //@NSManaged public var valorCuota: Double
            proyeccion.setValue(valorCuota, forKey: "valorCuota")
            
            //@NSManaged public var valorIntereses: Double
            proyeccion.setValue(totalIntereses, forKey: "valorIntereses")
            
            //@NSManaged public var compra: Compra?
            self.compra?.addToProyecciones(proyeccion: proyeccion as! Proyeccion)
            
            let proximoPeriodo = calendar.date(byAdding: .month, value: 1, to: fecha! as Date)
            
            let periodo = calendar.dateComponents(comp, from: proximoPeriodo!)
            
            fecha = firstDayOf(month: periodo.month!, year: periodo.year!)
            
            corte = lastDayOf(month: periodo.month!, year: periodo.year!)
        } while (cuota < plazo)
        
        self.tfIntereses.text = fmtMon.string(from: NSNumber.init(value: totalIntereses))
        
        self.tfPagoTotal.text = fmtMon.string(from: NSNumber.init(value: pagoTotal))
        
        self.compra?.setValue(totalIntereses, forKey: "totalIntereses")
        
        self.compra?.setValue(plazo, forKey: "plazo")
        
        self.compra?.setValue(tea, forKey: "tea")
        
        let guardado = guardar()
        
        if !guardado {
            resultado = -1
        }
        
        return resultado
    }
    
    // MARK: - Procedimiento de preparación y validación de datos ingresados para guardado
    func prepararDatos(isDataReady isComplete: inout Bool) {
        isComplete = true
    }
        
    // MARK: - Precedimiento de guardado
    func guardar() -> Bool {
        var canISave: Bool = true
        do {
            prepararDatos(isDataReady: &canISave)
            
            if canISave {
                
                try self.moc.save()
                
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la proyección fueron generados con éxito!.", toFocus: nil)
                
                self.loadPreferences()
            }
        } catch {
            let fetchErr = error as NSError
            canISave = false
            print("No se pudo guardar los datos de la compra.  Error: \(fetchErr.localizedDescription)")
        }
        return canISave
    }

    @IBAction func btnCalcularPagoOnTouchUpInside(_ sender: UIButton) {
        var isComplete: Bool = true
        if !self.tfValorCompra.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Asegúrese de ingresar el valor de la compra.", toFocus: self.tfValorCompra)
        }
        
        if !self.tfCuotas.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el número de cuotas que desea proyectar.", toFocus: self.tfCuotas)
        }
        
        if !self.tfTEA.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la tasa efectiva anual que aplicará a la compra.", toFocus: self.tfTEA)
        }
        
        if isComplete {
            let resultado = calcularProyecciones()
            
            if resultado != 0 {
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Ocurrió un error al intentar calcular las cuotas.", toFocus: nil)
            }
        }
        
    }
    
    
    @IBAction func btnVerReporteOnTouchUpInside(_ sender: UIButton) {
        
        if (self.compra?.proyecciones?.count)! > 0 {
            self.performSegue(withIdentifier: "seguePreview", sender: self)
        } else {
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "No se encontraron proyecciones para mostrar.", toFocus: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "seguePreview" {
            let vcPR = segue.destination as! VCPreviewReport
            
            vcPR.tarjeta = self.tarjeta
            vcPR.compra = self.compra
            
        }
        
    }
    

}
