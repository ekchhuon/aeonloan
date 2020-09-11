//
//  HomeViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/7/20.
//

import UIKit
import SideMenu

extension HomeViewController {
    static func instantiate() -> HomeViewController {
        return HomeViewController()
    }
}

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    private let viewModel = HomeViewModel()
    private let siderViewModel = SliderViewModel()
    
    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var contactusView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    
    var timer = Timer()
    var counter = 0
    var longPressed: Bool = false
    var defaultInterval: TimeInterval = 3
    
    var imageArray = [UIImage?]()
    
    var numbers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindSliderData()
    }
    
    func bindSliderData() {
        siderViewModel.images.bind { [weak self] images in
            guard let images = images, let self = self else { return }
            self.imageArray = images
            self.sliderCollectionView.reloadData()
            self.setupPageControl()
        }
        
        siderViewModel.numbers.bind { [weak self] numbers in
            guard let numbers = numbers, let self = self else { return }
            self.numbers = numbers
        }
        
        siderViewModel.loading.bind { [weak self] loading in
            guard let self = self else {return}
            self.loadingLabel.text = loading ? "loading..." : ""
            self.indicator.startAnimating()
            self.indicator.isHidden = !loading
        }
    }
}

// MARK: Collection
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == sliderCollectionView {
            return imageArray.count
        }else {
            return 6
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == sliderCollectionView {
            let slider : SliderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as! SliderCollectionViewCell
            slider.sliderLabel.text = numbers[indexPath.row]
            
            return slider
        }else {
            let cell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("indexPath", indexPath.row)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = sliderCollectionView.contentOffset
        visibleRect.size = sliderCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = sliderCollectionView.indexPathForItem(at: visiblePoint) else { return }
        
        counter = indexPath.row
        changeSlideShow()
        timer.invalidate()
        startTimer()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case sliderCollectionView:
            navigateToSliderDetail(index: indexPath, item: numbers[indexPath.row])
        case gridCollectionView:
            switch indexPath.row {
            case 0: break
            case 1:
                navigateToApplyLoan()
            default: break
            }
        default: break
        }

    }
    
    func navigateToApplyLoan() {
        let detailed = ApplyLoanViewController.instantiate()
        navigationController?.pushViewController(detailed, animated: true)
    }
    
    func navigateToSliderDetail(index: IndexPath, item: String) {
        let detailed = SliderDetailViewController.instantiate(index: index, item: item)
        navigationController?.pushViewController(detailed, animated: true)
    }
}

// MARK: Private
extension HomeViewController{
    private func setupView() {
        setupSliderView()
        setupGridView()
        setupNavigationBar()
//        setupPageControl()
        changeSlideShow()
        setupLongGestureRecognizerOnCollection()
        // setupRefreshControl()
        customView()
    }
    
    private func setupNavigationBar() {
        let bannerIcon = UIImage(named: "banner")?.withRenderingMode(.alwaysOriginal)
        let notificationIcon = UIImage(named: "notification")?.withRenderingMode(.alwaysTemplate)
        let menuIcon = UIImage(named: "hamburger_icon")?.withRenderingMode(.alwaysTemplate)
        let userIcon = UIImage(named: "user")?.withRenderingMode(.alwaysTemplate)
        
        
        let banner = UIBarButtonItem( image: bannerIcon, style: .plain, target: self, action: #selector(handleClick))
        
        let notificationButton : UIButton = UIButton.init(type: .custom)
        notificationButton.setImage(notificationIcon, for: .normal)
        notificationButton.addTarget(self, action: #selector(navigateToNotification), for: .touchUpInside)
        notificationButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let notification = UIBarButtonItem(customView: notificationButton)
        
        let menuButton : UIButton = UIButton.init(type: .custom)
        menuButton.setImage(menuIcon, for: .normal)
        menuButton.addTarget(self, action: #selector(showSideMenu), for: .touchUpInside)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let menu = UIBarButtonItem(customView: menuButton)
        
        let userButton : UIButton = UIButton.init(type: .custom)
        userButton.setImage(userIcon, for: .normal)
        userButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        userButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let user = UIBarButtonItem(customView: userButton)
        
        navigationItem.setRightBarButtonItems([menu, notification, user], animated: false)
        navigationItem.leftBarButtonItems = [banner]
    }
    
    private func customView() {
        locationView.roundCorners([.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 10, borderColor: .brandMaginta, borderWidth: 1)
        contactusView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner], radius: 10, borderColor: .brandMaginta, borderWidth: 1)
    }
    
    private func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .red
        sliderCollectionView.alwaysBounceHorizontal = true
        sliderCollectionView.refreshControl = refreshControl // iOS 10+
    }
    
    private func setupGridView() {
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        self.gridCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        setupGridLayout()
    }
    
    private func setupSliderView() {
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        self.sliderCollectionView.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderCollectionViewCell")
        sliderCollectionView.showsHorizontalScrollIndicator = false
        sliderCollectionView.isPagingEnabled = true
        
        setupSliderLayout()
    }
    
    private func setupGridLayout() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let size = gridCollectionView.frame.size
        layout.sectionInset = UIEdgeInsets(top:15,left:15,bottom:0,right:15)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/2 - 20, height: size.height/3 - 40)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        gridCollectionView.collectionViewLayout = layout
    }
    
    private func setupSliderLayout() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let size = sliderCollectionView.frame.size
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
        layout.itemSize = CGSize(width: size.width, height: size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        sliderCollectionView.collectionViewLayout = layout
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = imageArray.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .brandYellow
        startTimer()
    }
    
    private func startTimer() {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: self.defaultInterval, target: self, selector: #selector(self.changeSlideShow), userInfo: nil, repeats: true)
        }
    }
    
    // stop slider when long press began
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        sliderCollectionView?.addGestureRecognizer(longPressedGesture)
    }
    
    private func sideMenuSetting() -> SideMenuSettings {
        var presentation: SideMenuPresentationStyle = SideMenuPresentationStyle()
        presentation = .menuSlideIn
        presentation.menuStartAlpha = 1
        presentation.menuScaleFactor = 1
        presentation.onTopShadowOpacity = 0
        presentation.presentingEndAlpha = 0.5 // overlay::alpha
        presentation.presentingScaleFactor = 1
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentation
        settings.menuWidth = UIScreen.main.bounds.width/1.5
        settings.blurEffectStyle = .none
        settings.statusBarEndAlpha = 0
        settings.presentDuration = 0.5
        
        return settings
    }
}

// MARK: @objc
extension HomeViewController {
    @objc
    private func changeSlideShow() {
        guard longPressed == false else { return }
        if counter < imageArray.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
    }
    
    @objc
    private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        longPressed = gestureRecognizer.state == .began
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        // stuff here
        refreshControl.endRefreshing()
    }
    
    @objc
    private func handleClick(){
        let login = LoginViewController.instantiate()
        navigationController?.pushViewController(login, animated: true)
    }
    
    @objc
    private func navigateToNotification() {
        let notification = NotificationViewController.instantiate()
        navigationController?.pushViewController(notification, animated: true)
    }
    
    @objc
    private func showSideMenu() {
        let menu = SideMenuNavigationController(rootViewController: SideMenuViewController.instantiate())
        menu.leftSide = false
        menu.navigationBar.barTintColor = .brandPurple
        menu.settings = sideMenuSetting()
        present(menu, animated: true, completion: nil)
    }
}
