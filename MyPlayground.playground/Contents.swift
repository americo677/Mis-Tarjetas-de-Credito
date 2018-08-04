//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

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
    print("Fecha inicial: \(month)/\(year): \(startDate)")
    
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
    print("Fecha inicial: \(month)/\(year): \(lastDay)")
    
    return lastDay
    
}

let primerDia = firstDayOf(month: 12, year: 2016)
let ultimoDia = lastDayOf(month: 12, year: 2016)

print("\(primerDia) hasta el \(ultimoDia)")

func daysBetween(startDay: NSDate, lastDay: NSDate) -> Int {
    
    //let formatter = DateFormatter()
    //formatter.dateFormat = "dd-MM-yyyy"

    let calendar = Calendar.current
    let dias =  Set<Calendar.Component>([.day])
    //print("\(lastDay)")
    let sDay = calendar.startOfDay(for: startDay as Date)
    let lDay = calendar.startOfDay(for: lastDay as Date)
    
    //var test = calendar.dateComponents(Set<Calendar.Component>([.day, .month, .year]), from: startDay as Date)
    
    //test.hour = 0
    //test.minute = 0
    //test.second = 0
    
    //calendar.date(from: test)
    //print("Test date: \( formatter.string(from: calendar.date(from: test)!))")
    
    //let sDay = formatter.string(from: calendar.date(from: test)!)
    //let sDay = calendar.date(from: test)
    
    //test = calendar.dateComponents(Set<Calendar.Component>([.day, .month, .year]), from: lastDay as Date)
    
    //test.hour = 0
    //test.minute = 0
    //test.second = 0

    //let lDay = formatter.string(from: calendar.date(from: test)!)
    //let lDay = calendar.date(from: test)
    //formatter.date(from: (formatter.string(from: lDay))!)
    //print("\(lDay!)")
    
    let result = calendar.dateComponents(dias, from: sDay as Date,  to: lDay as Date)
    //let result = calendar.dateComponents(dias, from: formatter.date(from: (formatter.string(from: (sDay)!)))!,  to: formatter.date(from: (formatter.string(from: (lDay)!)))!)
    
    return result.day! + 1
}

let dias = daysBetween(startDay: primerDia, lastDay: ultimoDia)
print ("Total dias transcurridos: \(dias)")

let format = DateFormatter()
format.dateFormat = "dd-MM-yyyy"

let fecha: NSDate = format.date(from: "14-06-2017") as NSDate

func daysLeft(startDay: NSDate) -> Int {
    let calendar = Calendar.current
    let dias =  Set<Calendar.Component>([.day])
    let periodo = Set<Calendar.Component>([.month, .year])
    
    let comp = calendar.dateComponents(periodo, from: startDay as Date)
    
    let lastDay = lastDayOf(month: comp.month!, year: comp.year!)
    
    let result = calendar.dateComponents(dias, from: startDay as Date,  to: lastDay as Date)
    
    return result.day! + 1
}


print("\(daysLeft(startDay: fecha!))")
