//
//  LocationListViewController.swift
//  AEON Loan
//
//  Created by aeon on 12/16/20.
//

import UIKit

//class LocationListViewController: UIViewController {
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

extension LocationPicker1ViewController {
    static func instantiate(code: String, for type: LocationType, pickedItem: String? ) -> LocationPicker1ViewController {
        let controller = LocationPicker1ViewController()
        controller.locationCode = code
        controller.locationType = type
        controller.pickedItem = pickedItem
        
        return controller
    }
}

class LocationPicker1ViewController: BaseViewController {
    private let viewModel = LocationListViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var locationTitleLable: UILabel!
    
    private var locationCode: String?
    private var locationType: LocationType?
    private var pickedItem: String?
    
    private var selectedLocation: Location.Data?
    private var locations: [Location.Data]?
    
    var writeBackDelegate: WriteValueBackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        setupSearchBar()
        bind()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.fetchLocaiton(for: .province, with: "")
        locationTitleLable.text = locationType?.value
        
        submitButton.rounds(radius: 10)
        submitButton.backgroundColor = .brandPurple
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "".localized ,message: msg)
        }
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "".localized, message: err.localized)
        }
        
        viewModel.response.bind { [weak self] data in
            guard let self = self else { return }
            self.locations = data
            self.tableView.reloadData()
        }
    }
    
    fileprivate func setupSearchBar() {
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.setImage(UIImage(systemName: "mic"), for: .bookmark, state: .normal)
        
        let micImage = UIImage(systemName: "mic.fill")
        searchBar.setImage(micImage, for: .bookmark, state: .normal)
        searchBar.showsBookmarkButton = true
        
        if let cancelButton : UIButton = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            if let delegate = self.writeBackDelegate {
                let data = (self.selectedLocation, self.locationType )
                delegate.writeBack(value: data)
                
                print(" writeback data",data)
            }
        }
    }
}

extension LocationPicker1ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        cell.textLabel?.text = locations?[indexPath.row].name

        if cell.textLabel?.text == pickedItem {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLocation = locations?[indexPath.row]
    }
}

extension LocationPicker1ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    }
}
