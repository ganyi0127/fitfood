//
//  MenuVC.swift
//  FitFood
//
//  Created by YiGan on 17/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class MenuTVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        tableView.rowHeight = (tableView.bounds.size.height - 44 - 20) / 7
        navigationController?.navigationBar.clipsToBounds = true //不显示导航栏下面的小阴影
    }
    
    private func createContents(){
        
    }
}

//MARK:- tableview
extension MenuTVC {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItem.shareItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view_size.height / 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        let menuItem = MenuItem.shareItems[indexPath.row]
        
        cell.menuLabel.text = menuItem.titleText
        cell.menuLabel.font = font_big
        
        cell.contentView.backgroundColor = menuItem.backgroundColor
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        (navigationController?.parent as! InitVC).switchTo(withMenuItemType: MenuItem.shareItems[indexPath.row].type)
    }
}
