//
//  VCListaCompras.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 7/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCListaCompras: UIViewController {
    
    @IBOutlet weak var tvCompras: UITableView!
    
    @IBOutlet weak var lblIntereses: UILabel!
    
    @IBOutlet weak var lblCuota: UILabel!
    
    @IBOutlet weak var lblBanco: UILabel!
    
    @IBOutlet weak var lblTotalCuota: UILabel!
    
    
    var tarjeta: Tarjeta? = nil
    var compra: Compra? = nil
    var compras = [AnyObject]()
    var comprasFiltradas = [AnyObject]()
    var cuotas = [AnyObject]()
    

    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    let scSearchController = UISearchController(searchResultsController: nil)
    
    var modo: ModoVista?

    let fmtFloat: NumberFormatter = NumberFormatter()
    let fmtMon: NumberFormatter = NumberFormatter()
    let fmtPer: NumberFormatter = NumberFormatter()
    let fmtDate: DateFormatter = DateFormatter()

    // MARK: - Inicializa formateadores numéricos
    func initFormatters() {
        // Preparación del formateador de fecha
        fmtDate.dateFormat = "dd/MM/yyyy"
        
        // Preparación de los formateadores númericos
        fmtFloat.numberStyle = .none
        fmtFloat.maximumFractionDigits = 2
        
        fmtMon.numberStyle = .currency
        fmtMon.maximumFractionDigits = 2
        
        fmtPer.numberStyle = .percent
        fmtPer.maximumFractionDigits = 2
    }

    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initTableView(tableView: self.tvTarjetas, backgroundColor: UIColor.customUltraLightBlue())
        
        initTableView(tableView: self.tvCompras, backgroundColor: UIColor.clear)
        
        initToolBar(toolbarDesign: .toLeftBackToRightEditNewStyle, actions: [nil, #selector(self.btnEditOnTouchUpInside(_:)), #selector(self.btnNuevoOnTouchUpInside(_:))], title: "Mis Compras")
        
        //initSearchBar(tableView: tvEvaluaciones)
        
        configSearchBar(tableView: tvCompras)
        
        //self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        //self.tvPeriodos.isHidden = true
        
        //initViewForPicker()
        
        initFormatters()
        
        //initDatePickers()

    }

    // MARK: - Procedimiento para recuperar los datos de la BD
    func getData() {
        if self.tarjeta != nil {
            self.cuotas.removeAll()
            self.compras = (self.tarjeta?.obtenerCompras())!
            
            
            self.lblBanco.text = self.tarjeta?.banco
            
            for cObj in self.compras {
                let compra = cObj as! Compra
                
                if let proyeccion = compra.obtenerProyeccionDelMes() {
                    self.cuotas.append(proyeccion)
                }
                
            }
            
            let extracto = InfoExtracto()
            
            for cObj in self.cuotas {
                let cuota = cObj as! Proyeccion
                
                //print("Cuota: \(cuota)")
                
                extracto?.totalPagoCuotas += cuota.valorCuota
                extracto?.totalIntereses += cuota.interes
                extracto?.totalAPagar += cuota.valorCuota + cuota.interes
            }
            
            self.lblIntereses.text = valorFormateado(valor: (extracto?.totalIntereses)!, decimales: 2, estilo: .currency)
            
            self.lblCuota.text = valorFormateado(valor: (extracto?.totalPagoCuotas)!, decimales: 2, estilo: .currency)
            
            let total: Double = (extracto?.totalIntereses)! + (extracto?.totalPagoCuotas)!
            
            self.lblTotalCuota.text = total.doubleFormatter(decimales: 2, estilo: .currency)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPreferences()
        
        //restrictRotation(restrict: false)
        
        //let dbLoc =
        //print("\(getPath("BDTarjetasCredito.sqlite"))")
        
        //let identifier = "customCellTarjeta"
        //let myBundle = Bundle(for: VCListaTarjetas.self)
        //let nib = UINib(nibName: "CustomCellTarjeta", bundle: myBundle)
        
        //self.tvPeriodos.register(nib, forCellReuseIdentifier: identifier)
        //self.tvTarjetas.register(nib, forCellReuseIdentifier: identifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getData()
        self.tvCompras.reloadData()
        
        //print("viewDidAppear exec...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getData()
        
        //print("viewWillAppear exec...")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Acciones de botones
    @objc func btnNuevoOnTouchUpInside(_ sender: AnyObject) {
        self.modo = .nuevo
        self.performSegue(withIdentifier: "segueMasterCompras", sender: self)
    }
    
    @objc func btnEditOnTouchUpInside(_ sender: UIBarButtonItem) {
        if self.tvCompras.isEditing {
            sender.title = "Editar"
            self.tvCompras.setEditing(false, animated: true)
            self.modo = .lectura
        } else {
            // el UIBarButtonItem debe tener como posible titulo cada titulo
            sender.title = "Aceptar"
            self.tvCompras.setEditing(true, animated: true)
            self.modo = .edicion
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueMasterCompras" {
            
            if self.modo == .nuevo {
                let vcMC = segue.destination as! VCMasterCompras
                vcMC.boolEsNuevo = true
                vcMC.tarjeta = self.tarjeta
                vcMC.compra = nil
            } else if self.modo == .edicion {
                let vcMC = segue.destination as! VCMasterCompras
                vcMC.boolEsModificacion = true
                vcMC.compra = self.compra
                vcMC.tarjeta = self.tarjeta
            }
        } else if segue.identifier == "segueProyectarCompra" {
            let vcPC = segue.destination as! VCProyectarCompra
            vcPC.tarjeta = self.tarjeta
            vcPC.compra = self.compra
        }
    }


}

// MARK: - Extension para UISearchBar
extension VCListaCompras: UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Configuración de la UISearchBar
    func configSearchBar(tableView: UITableView) {
        // Carga un controlador de búsqueda para implementar una barra de búsqueda de presupuestos.
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        scSearchController.searchResultsUpdater = self
        
        scSearchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        self.scSearchController.searchBar.placeholder = "Buscar compra..."
        
        //scSearchController.searchBar.scopeButtonTitles = ["Actives", "All", "Preserveds"]
        
        scSearchController.searchBar.delegate = self
        
        scSearchController.searchBar.sizeToFit()
        
        scSearchController.searchBar.showsCancelButton = false
        
        tableView.tableHeaderView = scSearchController.searchBar
        
        self.scSearchController.hidesNavigationBarDuringPresentation = false
        
        self.scSearchController.searchBar.searchBarStyle = .prominent
        
        self.scSearchController.searchBar.barStyle = .default
        
        //self.navigationItem. = self.scSearchController.searchBar
        
        let bottom: CGFloat = 0 // 50 // init value for bottom
        let top: CGFloat = 0 // 0 init value for top
        let left: CGFloat = 0
        let right: CGFloat = 0
        
        tableView.contentInset = UIEdgeInsetsMake(top, left, bottom, right)
        
        //self.tableView.tableHeaderView?.contentMode = .scaleToFill
        
        let coordY = 0 // self.view.frame.size.height - 94
        let initCoord: CGPoint = CGPoint(x:0, y:coordY)
        
        tableView.setContentOffset(initCoord, animated: true)
        
    }
    
    // MARK: - Procedimientos para la UISearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //let initPointForSearchBar: CGPoint = CGPoint(x:0, y:-44)
        //self.tableView.setContentOffset(initPointForSearchBar, animated: true)
        self.scSearchController.searchBar.resignFirstResponder()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        /*
         if scope == scopeActives {
         presupuestosFiltrados = presupuestos.filter { budget in return ((budget as! Presupuesto).descripcion?.lowercased().contains(searchText))! &&  (budget as! Presupuesto).activo?.boolValue == true }
         } else if scope == scopePreserveds {
         presupuestosFiltrados = presupuestos.filter { budget in return ((budget as! Presupuesto).descripcion?.lowercased().contains(searchText))! &&  (budget as! Presupuesto).activo?.boolValue == false }
         } else if scope == scopeAll {
         presupuestosFiltrados = presupuestos.filter { budget in return ((budget as! Presupuesto).descripcion?.lowercased().contains(searchText))! }
         }
         
         //presupuestosFiltrados = presupuestos.filter { budget in return ((budget as! Presupuesto).descripcion?.lowercased().contains(searchText))! &&  (budget as! Presupuesto).activo?.boolValue == true }
         
         //presupuestosFiltrados = presupuestos.filter( { (($0 as! Presupuesto).descripcion?.lowercased().range(of: searchText) != nil)} )
         
         self.tableView.reloadData()
         */
        
        if !searchText.isEmpty {
            self.comprasFiltradas = self.compras.filter {
                compra in return (
                    !((compra as! Compra).descripcion != nil) ? false: (compra as! Compra).descripcion!.lowercased().contains(searchText)
                        ||
                        !((compra as! Compra).comercio != nil) ? false: (compra as! Compra).comercio!.lowercased().contains(searchText)
                    
                )
            }
        }
        self.tvCompras.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // nothing yet
        /*
         let searchBar = searchController.searchBar
         let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
         
         if searchController.searchBar.selectedScopeButtonIndex == 0 {
         filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!, scope: scopeActives)
         } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
         filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!, scope: scopeAll)
         } else if searchController.searchBar.selectedScopeButtonIndex == 2 {
         filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!, scope: scopePreserveds)
         } else {
         filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!, scope: scope)
         }
         */
        
        filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: scSearchController)
    }
}

// MARK: - Extensión para UITableView
extension VCListaCompras: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Inicializador de la tableView de la vista
    func initTableView(tableView: UITableView, backgroundColor color: UIColor) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth]
        
        tableView.backgroundColor = color
        
        let identifier = "customCellCompra"
        let myBundle = Bundle(for: VCListaCompras.self)
        let nib = UINib(nibName: "CustomCellCompra", bundle: myBundle)
        
        //self.tvPeriodos.register(nib, forCellReuseIdentifier: identifier)
        //self.tvTarjetas.register(nib, forCellReuseIdentifier: identifier)
        
        //self.tvPeriodos.register(nib, forCellReuseIdentifier: identifier)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.allowsSelectionDuringEditing = true
        
        initTableViewRowHeight(tableView: tableView)
    }
    
    func initTableViewRowHeight(tableView: UITableView) {
        tableView.rowHeight = Global.tableView.MAX_ROW_HEIGHT_TARJETAS
    }
    
    // MARK: - TableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections exec...")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if self.comprasFiltradas.count > 0 {
                return self.comprasFiltradas.count
            }
        } else {
            if self.compras.count > 0 {
                return self.compras.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("cellForRowAt exec...")
        
        let identifier = "customCellCompra"
        var cell: CustomCellCompra? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CustomCellCompra
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier) as? CustomCellCompra
        }
        
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.compra = self.comprasFiltradas[indexPath.row] as? Compra
        } else {
            self.compra = self.compras[indexPath.row] as? Compra
        }
        
        //cell?.backgroundColor = UIColor.customUltraLightBlue()
        
        //cell?.textLabel?.textColor = UIColor.customLightColor()
        
        cell?.lblDescripcion.text = self.compra?.descripcion
        cell?.lblComercio.text = self.compra?.comercio
        cell?.lblFecha.text = fmtDate.string(from: (self.compra?.fecha)! as Date)
        cell?.lblValor.text = fmtMon.string(from: NSNumber.init(value: (self.compra?.valor)!))
        cell?.lblPlazo.text = fmtFloat.string(from: NSNumber.init(value: (self.compra?.plazo)!))
        
        if self.compra?.imagen == nil {
            cell?.ivImagen.image = UIImage(named: "icono-bolsocompra.png")
        } else {
            cell?.ivImagen.image = getImageFrom(directory: Global.Path.imagenes, fileName: (self.compra?.imagen!)!)

        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.customUltraLightBlue()
        cell?.selectedBackgroundView = backgroundView

        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.compra = self.comprasFiltradas[indexPath.row] as? Compra
        } else {
            self.compra = self.compras[indexPath.row] as? Compra
        }
        
        
        if self.tvCompras.isEditing {
            self.performSegue(withIdentifier: "segueMasterCompras", sender: self)
        } else {
            self.performSegue(withIdentifier: "segueProyectarCompra", sender: self)
        }
        
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            //#if LITE_VERSION
            //self.showCustomWarningAlert("This is the demo version.  To enjoy the full version of \(self.strAppTitle) we invite you to obtain the full version.  Thank you!.", toFocus: nil)
            //#endif
            
            //#if FULL_VERSION
            
            if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                self.compra = self.comprasFiltradas[indexPath.row] as? Compra
            } else {
                self.compra = self.compras[indexPath.row] as? Compra
            }
            
            
            self.tarjeta?.removeFromCompras(compra: self.compra!)
            
            if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                self.comprasFiltradas.remove(at: indexPath.row)
            } else {
                self.compras.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }
}


