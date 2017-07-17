//
//  HistoryVC.swift
//  FitFood
//
//  Created by YiGan on 19/06/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class HistoryVC: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func config(){
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    private func createContents(){
        
    }
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell = tableview.dequeueReusableCell(withIdentifier: identifier) as! HistoryCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
