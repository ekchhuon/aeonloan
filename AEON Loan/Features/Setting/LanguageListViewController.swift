//
//  LanguageListViewController.swift
//  AEON Loan
//
//  Created by aeon on 11/25/20.
//

import UIKit

extension LanguageListViewController {
    static func instantiate() -> LanguageListViewController {
        return LanguageListViewController()
    }
}

class LanguageListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var languages = ["ភាសារខ្មែរ", "English"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "LanguageListCell", bundle: nil), forCellReuseIdentifier: "LanguageListCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LanguageListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageListCell", for: indexPath) as! LanguageListCell
        cell.textLabel?.text = languages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(languages[indexPath.row], "selected")
        
        let lang:Language = indexPath.row == 0 ? .km : .en
        Preference.language = lang
        Languages(lang: lang).change()
        Bundle.setLanguage(lang.identifier)
    }
}
