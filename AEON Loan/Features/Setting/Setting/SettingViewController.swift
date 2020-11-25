//
//  SettingViewController.swift
//  AEON Loan
//
//  Created by aeon on 11/25/20.
//

import UIKit

extension SettingViewController {
    static func instantiate() -> SettingViewController {
        return SettingViewController()
    }
}

class SettingViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let data = [["0,0", "0,1", "0,2"], ["1,0", "1,1", "1,2"]]
    let headerTitles = [" ", " "]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print( data[indexPath.section][indexPath.row]  ) 
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }

        return nil
    }
}
