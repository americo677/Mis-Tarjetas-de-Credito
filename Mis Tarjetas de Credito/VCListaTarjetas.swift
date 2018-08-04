//
//  VCListaTarjetas.swift
//  Mis Tarjetas de Credito
//
//  Created by Américo Cantillo on 7/06/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCListaTarjetas: UIViewController {

    
    @IBOutlet weak var tvTarjetas: UITableView!
    
    var tarjeta: Tarjeta? = nil
    var tarjetas = [AnyObject]()
    var tarjetasFiltradas = [AnyObject]()
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    let scSearchController = UISearchController(searchResultsController: nil)
    
    var modo: ModoVista?
    
    let fmtFloat: NumberFormatter = NumberFormatter()
    let fmtMon: NumberFormatter = NumberFormatter()
    let fmtPer: NumberFormatter = NumberFormatter()
    
    // MARK: - Inicializa formateadores numéricos
    func initFormatters() {
        // Preparación del formateador de fecha
        //dtFormatter.dateFormat = "dd/MM/yyyy"
        
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
        
        initTableView(tableView: self.tvTarjetas, backgroundColor: UIColor.clear)

        initToolBar(toolbarDesign: .toLeftBackToRightEditNewStyle, actions: [nil, #selector(self.btnEditOnTouchUpInside(_:)), #selector(self.btnNuevoOnTouchUpInside(_:))], title: "Mis Tarjetas")
        
        configSearchBar(tableView: tvTarjetas)
        
        //self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        //self.tvPeriodos.isHidden = true
        
        //initViewForPicker()
        
        initFormatters()
        
        //initDatePickers()
    }

    // MARK: - Procedimiento para recuperar los datos de la BD
    func getData() {
        self.tarjetas = fetchData(entity: .tarjeta)
        
        for object in self.tarjetas {
            let t = object as! Tarjeta
            t.sincronizarCupoDisponible()
        }
        
        if self.tarjetas.count > 0 {
            self.tarjeta = self.tarjetas.first as? Tarjeta
        }
    }

    // MARK: - Carga inicial de la vista
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPreferences()
        
        //restrictRotation(restrict: false)
        
        _ = copyFileFromBundleToDirectory(directory: Global.Path.imagenes, file: "icono-bolsocompra.png")
        
        //print("\(getPath("BDTarjetasCredito.sqlite"))")

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getData()
        self.tvTarjetas.reloadData()
        
        //print("viewDidAppear exec...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Acciones de botones
    @objc func btnNuevoOnTouchUpInside(_ sender: AnyObject) {
        self.modo = .nuevo
        self.performSegue(withIdentifier: "segueMasterTarjetas", sender: self)
    }
    
    @objc func btnEditOnTouchUpInside(_ sender: UIBarButtonItem) {
        if self.tvTarjetas.isEditing {
            sender.title = "Editar"
            self.tvTarjetas.setEditing(false, animated: true)
            self.modo = .lectura
        } else {
            // el UIBarButtonItem debe tener como posible titulo cada titulo
            sender.title = "Aceptar"
            self.tvTarjetas.setEditing(true, animated: true)
            self.modo = .edicion
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueMasterTarjetas" {
            
            if self.modo == .nuevo {
                let vcMT = segue.destination as! VCMasterTarjetas
                vcMT.boolEsNuevo = true
                vcMT.tarjeta = nil
            } else if self.modo == .edicion {
                let vcMT = segue.destination as! VCMasterTarjetas
                vcMT.boolEsModificacion = true
                vcMT.tarjeta = self.tarjeta
            }
        } else if segue.identifier == "segueListaCompras" {
            let vcC = segue.destination as! VCListaCompras
            vcC.tarjeta =  self.tarjeta
        }
    }
 

}

// MARK: - Extension para UISearchBar
extension VCListaTarjetas: UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Configuración de la UISearchBar
    func configSearchBar(tableView: UITableView) {
        // Carga un controlador de búsqueda para implementar una barra de búsqueda de presupuestos.
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        scSearchController.searchResultsUpdater = self
        
        scSearchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        self.scSearchController.searchBar.placeholder = "Buscar tarjeta..."
        
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
            self.tarjetasFiltradas = self.tarjetas.filter {
                tarjeta in return (
                    !((tarjeta as! Tarjeta).franquicia != nil) ? false: (tarjeta as! Tarjeta).franquicia!.lowercased().contains(searchText)
                    ||
                    !((tarjeta as! Tarjeta).banco != nil) ? false: (tarjeta as! Tarjeta).banco!.lowercased().contains(searchText)
                    
                )
            }
        }
        self.tvTarjetas.reloadData()
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
extension VCListaTarjetas: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Inicializador de la tableView de la vista
    func initTableView(tableView: UITableView, backgroundColor color: UIColor) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth]
        
        tableView.backgroundColor = color
        
        let identifier = "customCellTarjeta"
        let myBundle = Bundle(for: VCListaTarjetas.self)
        let nib = UINib(nibName: "CustomCellTarjeta", bundle: myBundle)
        
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
            if self.tarjetasFiltradas.count > 0 {
                return self.tarjetasFiltradas.count
            }
        } else {
            if self.tarjetas.count > 0 {
                return self.tarjetas.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("cellForRowAt exec...")
        
        let identifier = "customCellTarjeta"
        var cell: CustomCellTarjeta? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CustomCellTarjeta
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier) as? CustomCellTarjeta
        }
        
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.tarjeta = self.tarjetasFiltradas[indexPath.row] as? Tarjeta
        } else {
            self.tarjeta = self.tarjetas[indexPath.row] as? Tarjeta
        }
        
        //cell?.backgroundColor = UIColor.customUltraLightBlue()
        
        //cell?.textLabel?.textColor = UIColor.customLightColor()
        
        //cell?.textLabel?.text = self.rango?.descripcion
        
        //cell?.detailTextLabel?.text = "\((self.rango?.limiteInferior)!) a \( (self.rango?.limiteSuperior)!)"
        
        //self.rango?.limiteInferior,
        //if self.rango?.indiceDuracion != nil {
        //    let nsIndice = Int((self.rango?.indiceDuracion)!)
        //    cell?.detailTextLabel?.text = Global.arreglo.nombreDuracion[nsIndice]
        //} else {
        //    cell?.detailTextLabel?.text = ""
        //}
        
        cell?.lblBancoFranquicia.text = (self.tarjeta?.banco)!
            
        if (self.tarjeta?.franquicia)?.lowercased() == "visa" {
            cell?.ivImageTarjeta.image = UIImage(named: "brand-visa.jpg")
        } else if (self.tarjeta?.franquicia)?.lowercased() == "mastercard" {
            cell?.ivImageTarjeta.image = UIImage(named: "brand-mastercard.jpg")
        } else if (self.tarjeta?.franquicia)?.lowercased() == "american express" {
            cell?.ivImageTarjeta.image = UIImage(named: "brand-americanexpress.jpg")
        } else if (self.tarjeta?.franquicia)?.lowercased() == "diners club" {
            cell?.ivImageTarjeta.image = UIImage(named: "brand-dinersclub.jpg")
        } else if (self.tarjeta?.franquicia)?.lowercased() == "local" {
            cell?.ivImageTarjeta.image = UIImage(named: "brand-local.png")
        }
        
        cell?.lblNumeroTarjeta.text = self.tarjeta?.numero
        
        cell?.lblCupoDisponible.text = fmtMon.string(from: NSNumber.init(value: (self.tarjeta?.disponible)!))
        
        cell?.lblTEAVigente.text = fmtFloat.string(from: NSNumber.init(value: (self.tarjeta?.teaVigente)!))! + "%"
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.customUltraLightBlue()
        cell?.selectedBackgroundView = backgroundView
        
        return cell!
        
        /*
         cell?.backgroundView?.backgroundColor = UIColor.customUltraLightBlue()
         cell?.backgroundColor = UIColor.customUltraLightBlue()
         
         cell?.textLabel?.text = self.periodo?.nombre?.capitalized
         
         cell?.textLabel?.textColor = UIColor.darkGray
         cell?.textLabel?.shadowColor = UIColor.lightGray
         cell?.textLabel?.shadowOffset = CGSize(width: 1, height: 1)
         
         return cell!
         */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.tarjeta = self.tarjetasFiltradas[indexPath.row] as? Tarjeta
        } else {
            self.tarjeta = self.tarjetas[indexPath.row] as? Tarjeta
        }
        
        
        if self.tvTarjetas.isEditing {
            self.performSegue(withIdentifier: "segueMasterTarjetas", sender: self)
        } else {
            self.performSegue(withIdentifier: "segueListaCompras", sender: self)
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
                self.tarjeta = self.tarjetasFiltradas[indexPath.row] as? Tarjeta
            } else {
                self.tarjeta = self.tarjetas[indexPath.row] as? Tarjeta
            }
            
            
            //let boolPreservar: Bool = self.rango!.preservar as! Bool
            
            //if boolPreservar {
            //self.presupuesto?.setValue(false, forKey: smModelo.smPresupuesto.colActivo)
            //} else {
            self.moc.delete(self.tarjeta!)
            //}
            
            if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                self.tarjetasFiltradas.remove(at: indexPath.row)
            } else {
                self.tarjetas.remove(at: indexPath.row)
            }
            
            do {
                try self.moc.save()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                let deleteError = error as NSError
                print(deleteError)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }
}

