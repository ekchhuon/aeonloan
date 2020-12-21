//
//  SubLocationListViewController.swift
//  AEON Loan
//
//  Created by aeon on 12/16/20.
//

import UIKit

//class SubLocationListViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}



extension SubLocationListViewController {
    static func instantiate(code: String, for type: LocationType) -> SubLocationListViewController {
        let controller = SubLocationListViewController()
        controller.locationCode = code
        controller.locationType = type
        return controller
    }
}

class SubLocationListViewController: BaseViewController {
    private let viewModel = LocationListViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    private var locationCode: String?
    private var locationType: LocationType?
    private var selectedLocation: Location.Data?
    private var locations: [Location.Data]?
    
    var writeBackDelegate: WriteValueBackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tableView.delegate = self
        tableView.dataSource = self
        bind()
        fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            if let delegate = self.writeBackDelegate {
                let data = (self.selectedLocation, self.locationType )
                delegate.writeBack(value: data)
            }
        }
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "Login".localized ,message: msg)
        }
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "Login".localized, message: err.localized)
        }
        
        viewModel.response.bind { [weak self] data in
            guard let self = self else { return }
            self.locations = data
            self.tableView.reloadData()
        }
    }
    
    private func fetch() {
        guard let code = locationCode, let type = locationType else {
            debugPrint("Unable to fetch location")
            return
        }
        switch type {
        case .province: viewModel.fetchLocaiton(for: .province, with: code)
        case .district: viewModel.fetchLocaiton(for: .district, with: code)
        case .commune: viewModel.fetchLocaiton(for: .commune, with: code)
        case .village: viewModel.fetchLocaiton(for: .village, with: code)
        }
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            if let delegate = self.writeBackDelegate {
                delegate.writeBack(value: self.selectedLocation ?? nil)
            }
        }
    }
}

extension SubLocationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
//        cell.textLabel?.text = locations[indexPath.row]
        cell.textLabel?.text = locations?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected index", indexPath.row)
        self.selectedLocation = locations?[indexPath.row]
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let vw = UIView()
//        vw.backgroundColor = UIColor.red
//
//        return vw
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locationType?.value
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension SubLocationListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    }
}
