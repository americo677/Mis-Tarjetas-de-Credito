//
//  CGlobal.swift
//  Mi Calculadora de Prestamo
//
//  Created by Américo Cantillo on 1/11/16.
//  Copyright © 2016 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import UIKit


// Struct Global

enum ToolbarButtonDesign {
    case toLeftMenuToRightEditNewStyle
    case toLeftBackToRightEditNewStyle
    case toLeftBackToRightSaveStyle
    case toLeftBackToRightStyle
    case toLeftBackToRightPDFStyle
}

enum CustomClasses {
    case tarjeta
    case proyeccion
    case detalle
    case compra
    case extracto
}

enum ModoVista {
    case nuevo
    case edicion
    case lectura
}

enum Franquicia {
    case visa
    case mastercard
    case americanexpress
    case dinersclub
}

enum Reporte {
    case compra
    case extracto
}

enum Orden {
    case ascendente
    case descendente
}

struct Global {
    
    static let CORNER_RADIUS: CGFloat = 12.0
    static let SHADOW_COLOR: CGFloat = 157.0 / 255.0

    struct Dato {
        var indice: Double = 0
        var descripcion: String = ""
    }
    
    struct Path {
        static let imagenes = "Images"
        static let documentos = "Documents"
    }

    static let APP_NAME = "Mis Tarjetas de Crédito"
    
    var modoAsistido = true
    
    static let defaults = UserDefaults.standard
    
    static let fstExeInstituciones = "primeraEjecucionInstituciones"
    static let fstExeEscalas = "primeraEjecucionEscala"
    
    struct identificador {
        static let MY_FINANCE_CONTROLLER_LITE = "1148364865"
        static let MI_CALCULADORA_PRESTAMOS_LITE = "1124516490"
        static let MIS_REGALOS_LITE = "1201639319"
    }
    
    struct defaultIndex {
        //static let pais = 0
        //static let nivelAcademico = 0
        //static let duracionPeriodo = 0
        static let franquicia = 0
    }
    
    struct arreglo {
        static let seccionesMenu: Array<String> = ["Menú Principal", "Otros productos"]
        static let opcionesMenu: Array<Array<String>> = [["Programa",
                                                   "Escalas", "Periodos", "Asignaturas", "Profesor", "Corte", "Forma de Evaluación", "Evaluación"], ["Mi Calculadora de Préstamo Lite", "My Finance Controller Lite", "Mis Regalos Lite"]]
        
        static let franquicias: Array<String> = ["Seleccione", "Visa", "Mastercard", "American Express", "Diners Club", "Local"]
        
        //static let pais: Array<String> = ["Seleccione", "Colombia", "Venezuela", "Mexico", "Argentina", "Ecuador", "Perú", "Paraguay", "Bolivia", "Chile", "Uruguay", "Nicaragua", "Panamá", "Honduras", "Guatemala", "El Salvador"]
        
        //static let paisIndicativo: Array<Int> = [0, 57, 58, 52, 54, 593, 51, 595, 591, 56, 598, 505, 507, 504, 502, 503]
        
        //static let nivelAcademico: Array<String> = ["Seleccione", "Bachiller", "Bachiller Técnico", "Técnico", "Pregrado", "Diplomado", "Especialización", "Maestría", "Doctorado"]
        
        //static let previoAviso: Array<String> = ["Seleccione", "Minutos", "Horas", "Dias"]
        
        //static let frecuenciaAviso: Array<String> = ["Seleccione", "Minutos", "Horas", "Dias"]
        
        //static let tipoEvaluacion: Array<String> = ["Seleccione", "Exámen corto", "Quiz", "Trabajo escrito", "Exposición", "Laboratorio", "Taller", "Exámen parcial", "Exámen final", "Incompatibilidades de final", "Exámen supletorio", "Examén de validación", "Exámen preparatorio", "Exámen de recuperación", "Otro"]
        
        //static let nombreDuracion: Array<String> = ["Seleccione", "Mensual", "Bimestral", "Trimestral", "Semestral", "Anual"]
        
        //static let diasDuracion: Array<Double> = [0, 30, 60, 90, 180, 360]
    }
    
    struct fuente {
        static let FONT_NAME_TITLE_NAVIGATION_BAR = "Futura"
        static let FONT_NAME_TABLEVIEW_SECTION = "Verdana"
        static let FONT_SIZE_12: CGFloat = 12
        static let FONT_SIZE_13: CGFloat = 13
        static let FONT_SIZE_14: CGFloat = 14
        static let FONT_SIZE_15: CGFloat = 15
    }

    struct tableView {
        static let MAX_ROW_HEIGHT_TARJETAS: CGFloat = 80
        
        //static let MAX_ROW_HEIGHT_PROGRAMAS: CGFloat = 51
        //static let MAX_ROW_HEIGHT_EVALUACIONES: CGFloat = 51
        //static let MAX_ROW_HEIGHT_INSTITUCIONES: CGFloat = 44
        //static let MAX_ROW_HEIGHT_PERIODOS: CGFloat = 44
        //static let MAX_ROW_HEIGHT_RANGOS: CGFloat = 44
        //static let MAX_ROW_HEIGHT_ASIGNATURAS: CGFloat = 44
    }
    
    public class CDInstitucion {
        var indice: Double = -1
        var descripcion: String = ""
        var indicePais: Double = -1
    }
    
    public class CDEscala {
        var indice: Double = -1
        var descripcion: String = ""
        var tipo: Double = -1
        var indicePais: Double = -1
        var valorMinParaAprobacion: Double = 0
    }
    
}
