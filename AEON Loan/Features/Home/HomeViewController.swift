//
//  HomeViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/7/20.
//

import UIKit

extension HomeViewController {
    static func instantiate() -> HomeViewController {
        return HomeViewController()
    }
}

class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var contactusView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setCollectionLayout()

    }
    
    @objc func handleClick(){
        let login = LoginViewController.instantiate()
        navigationController?.pushViewController(login, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate { }

// Private
extension HomeViewController{
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        setupNavigationBar()
        
        locationView.roundCorners([.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 10, borderColor: .brandMaginta, borderWidth: 1)
        contactusView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner], radius: 10, borderColor: .brandMaginta, borderWidth: 1)
    }
    
    private func setupNavigationBar() {
        let notification = UIBarButtonItem(
            image: UIImage(named: "notification")?.withRenderingMode(.alwaysTemplate),
            style: .plain, target: self, action: #selector(handleClick))
        
        let menu = UIBarButtonItem(
            image: UIImage(named: "hamburger_icon")?.withRenderingMode(.alwaysTemplate),
            style: .plain, target: self, action: #selector(handleClick))
        
        let banner = UIBarButtonItem(
            image: UIImage(named: "banner")?.withRenderingMode(.alwaysOriginal),
            style: .plain, target: self, action: #selector(handleClick))
        
        navigationItem.leftBarButtonItems = [banner]
        navigationItem.rightBarButtonItems = [menu, notification]
        
        // navigationItem.rightBarButtonItem = search
    }
    
    private func setCollectionLayout() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:15,left:15,bottom:0,right:15)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/2 - 20, height: collectionView.frame.size.height/4)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        collectionView.collectionViewLayout = layout
    }
}
