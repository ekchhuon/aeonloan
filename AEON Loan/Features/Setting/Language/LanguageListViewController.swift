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

struct AppLanguage{
    var language: Language
    var isSelected: Bool
    
    static func set(language lang: Language) {
        UserDefaults.standard.set([lang.identifier], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        Bundle.setLanguage(lang.identifier)
        Preference.language = lang
    }
}

class LanguageListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var languages = [AppLanguage]()
    var selected: Language = Preference.language
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLanguage()
        let doneButton = UIBarButtonItem(title: "Done".localized, style: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "LanguageListCell", bundle: nil), forCellReuseIdentifier: "LanguageListCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.rowHeight = 60
    }
    
    private func setupLanguage() {
        let lang = Preference.language
        let khmer = AppLanguage(language: .km, isSelected: lang == .km)
        let english = AppLanguage(language: .en, isSelected: lang == .en)
        languages = [khmer, english]
    }
    
    @objc
    private func done(){
        AppLanguage.set(language: selected)
        navigates(to: .home(.push(subtype: .fromLeft)))
    }

}

extension LanguageListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageListCell", for: indexPath) as! LanguageListCell
        cell.textLabel?.text = languages[indexPath.row].language.name
        cell.detailTextLabel?.text = languages[indexPath.row].language.identifier
        cell.detailTextLabel?.textColor = .gray
        cell.accessoryType = languages[indexPath.row].isSelected ? .checkmark : .none
        
        if languages[indexPath.row].isSelected {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(languages[indexPath.row], "selected")
        selected = languages[indexPath.row].language
    }
}
