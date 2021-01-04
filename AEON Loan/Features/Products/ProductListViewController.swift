//
//  ProductListViewController.swift
//  AEON Loan
//
//  Created by aeon on 11/27/20.
//

import UIKit


extension ProductListViewController {
    static func instantiate() -> ProductListViewController {
        return ProductListViewController()
    }
}

class ProductListViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let products = [Menu(icon: UIImage(named: "banner.aeon.card")!, title: AeonProduct.card.title), Menu(icon: UIImage(named: "banner.aeon.loan")!, title: AeonProduct.loan.title), Menu(icon: UIImage(named: "banner.aeon.installment")!, title: AeonProduct.installment.title), Menu(icon: UIImage(named: "banner.aeon.digital")!, title: AeonProduct.digital.title) ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("AEON Products".localized)
        setupTableView()
        tableView.alwaysBounceVertical = false
    }
    
    private func setupTableView() {
        
        let height = self.navigationController!.navigationBar.frame.height
        
        self.tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((tableView.frame.height - 15) / 4)
    }
    
    private func navigateToWebview(with request: WKRequest) {
        let controller = WKViewController.instantiate(request: request)
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: Collection
//extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return products.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
//        
//        cell.setup(data: products[indexPath.row])
//        
//        return cell
//    
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        switch indexPath.row {
//        case 0: navigateToWebview(with: .product(.card))
//        case 1: navigateToWebview(with: .product(.loan))
//        case 2: navigateToWebview(with: .product(.installment))
//        case 3: navigateToWebview(with: .product(.digital))
//        default: break
//        }
//        
//        
//    }
//    
//    private func navigateToWebview(with request: WKRequest) {
//        let controller = WKViewController.instantiate(request: request)
//        navigationController?.pushViewController(controller, animated: true)
//    }
//
//}



//class ProductListViewController: BaseViewController {
//    @IBOutlet weak var tableView: UITableView!
//
//    let products = [Menu(icon: .actions, title: "Aeon Card"), Menu(icon: .actions, title: "Aeon Loan"), Menu(icon: .actions, title: "Aeon Installments"), Menu(icon: .actions, title: "Digital Products") ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
//
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//
//    }
//
//}
//
extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.setup(data: products[indexPath.row])
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: navigateToWebview(with: .product(.card))
        case 1: navigateToWebview(with: .product(.loan))
        case 2: navigateToWebview(with: .product(.installment))
        case 3: navigateToWebview(with: .product(.digital))
        default: break
        }
    }
    
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20
//    }
}

