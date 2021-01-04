//
//  PaymentLocationViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import UIKit

extension PaymentLocationViewController {
    static func instantiate() -> PaymentLocationViewController {
        return PaymentLocationViewController()
    }
}

class PaymentLocationViewController: BaseViewController {
    private let viewModel = PaymentLocationViewModel()
    @IBOutlet weak var tableView: UITableView!
    var channels: [Channel] = [Channel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle("Payment Location".localized)
        self.tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        self.tableView.separatorColor = .lightGray
        self.tableView.delegate = self
        self.tableView.dataSource = self
        bind()
        
    }
    
    private func bind(){
        viewModel.loading.bind { [weak self] (loading) in
            guard let self = self else { return }
            
        }
        
        viewModel.channels.bind { [weak self] (channels) in
            guard let self = self else { return }
            self.channels = channels
        }
    }
    
}

extension PaymentLocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
        cell.setupData(channel: channels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
