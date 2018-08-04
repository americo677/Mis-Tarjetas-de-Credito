//
//  SideBarTableViewController.swift
//  SideBlurBar
//
//  Created by Américo Cantillo on 7/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

protocol SideBarViewControllerDelegate {
    func sideBarControlDidSelectRowAt(indexPath: NSIndexPath)
}

class SideBarTableViewController: UITableViewController {

    var delegate: SideBarViewControllerDelegate?
    
    var sections: Array<String> = []
    var options: Array<Array<String>> = [[]]
    var images: Array<Array<String>>? = nil
    
    let HEIGHT_HEADER_IN_SECTION: CGFloat = CGFloat(30)
    let HEIGHT_ROW: CGFloat = CGFloat(30)
    let COLOR_FONT_MENU_TITLE = UIColor.yellow
    let COLOR_FONT_MENU_OPTION = UIColor.customDarkColor()
    
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewHeaderFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "header")
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }
    
    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_HEADER_IN_SECTION
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cellHeaderViewIdentifier = "header"
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: cellHeaderViewIdentifier)! //as UITableViewHeaderFooterView

        header.contentView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: HEIGHT_HEADER_IN_SECTION)
        header.contentView.backgroundColor = UIColor.customOceanBlue()
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width - 15, height: HEIGHT_HEADER_IN_SECTION))
        headerLabel.font = UIFont(name: "Futura", size: 14)
        headerLabel.backgroundColor = .clear
        headerLabel.shadowColor = .black
        headerLabel.shadowOffset = CGSize(width: 0, height: 2)
        headerLabel.textColor = COLOR_FONT_MENU_TITLE
        
        headerLabel.text = self.sections[section]
        
        header.contentView.addSubview(headerLabel)

        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return menuData.count
        return self.options[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell?
        
        // Configure the cell...
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        
        cell!.backgroundColor = UIColor.clear
        
        let selectedView: UIView = UIView(frame: CGRect(x:0, y:0, width:cell!.frame.size.width, height:cell!.frame.size.height))
        
        selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        cell!.selectedBackgroundView = selectedView
        
        cell?.textLabel?.font = UIFont(name: "Futura", size: 13)
        
        cell?.textLabel?.textColor = COLOR_FONT_MENU_OPTION
        cell?.textLabel?.text = self.options[indexPath.section][indexPath.row]
        
        if self.images != nil {
            if (self.images?[indexPath.section].count)! - 1 <= indexPath.row {
                cell?.imageView?.image = UIImage(named: (self.images?[indexPath.section][indexPath.row])!)
            }
        }
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_ROW
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sideBarControlDidSelectRowAt(indexPath: indexPath as NSIndexPath)
    }
}
