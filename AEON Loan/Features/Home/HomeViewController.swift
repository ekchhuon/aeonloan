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
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var contactusView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!

    var timer = Timer()
    var counter = 0
    var longPressed: Bool = false
    var defaultInterval: TimeInterval = 3
    
    var imageArray = [UIImage?]()
    var menus: [Menu] = [Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.menus.bind { [weak self] menus in
            guard let self = self else {return}
            self.menus = menus
        }
        
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
            return menus.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == sliderCollectionView {
            let slider : SliderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as! SliderCollectionViewCell
            slider.sliderImage.image = imageArray[indexPath.row]
            
            return slider
        }else {
            let cell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
            cell.setupMenu(menu: menus[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
            navigateToSliderDetail(index: indexPath, item: "\(indexPath.row)")
        case gridCollectionView:
            switch indexPath.row {
            case 0: break
            case 1:
                navigateToApplyLoan()
            case 4:
                navigateToPaymentOption()
            default: break
            }
        default: break
        }
        
    }
    
    func navigateToApplyLoan() {
        let detailed = ApplyLoanViewController.instantiate()
        navigationController?.pushViewController(detailed, animated: true)
    }
    
    func navigateToPaymentOption() {
        let controller = PaymentOptionViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func navigateToSliderDetail(index: IndexPath, item: String) {
        let detailed = SliderDetailViewController.instantiate(index: index, item: item)
        navigationController?.pushViewController(detailed, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case sliderCollectionView:
            return UIEdgeInsets(top:0,left:0,bottom:0,right:0)
        default:
            return UIEdgeInsets(top:20,left:15,bottom:0,right:15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        switch collectionView {
        case sliderCollectionView:
            return 0
        default:
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case sliderCollectionView:
            return 0
        default:
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minimumLineSpacing:CGFloat = 20
        let minimumInteritemSpacing: CGFloat = 10 * 2
        
        switch collectionView {
        case sliderCollectionView:
            return CGSize(width: sliderCollectionView.frame.size.width, height: sliderCollectionView.frame.size.height)
        default:
            let size = gridCollectionView.frame.size
            return CGSize(width: size.width/2 - minimumInteritemSpacing, height: (size.height/3) - minimumLineSpacing)
        }
    }
}

// MARK: Private
extension HomeViewController{
    private func setupView() {
        self.view.backgroundColor = .brandPurple
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
        locationView.roundByCorners(10, for: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        contactusView.roundByCorners(10, for: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner])
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
        gridCollectionView.backgroundColor = .brandPurple
    }
    
    private func setupSliderView() {
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        self.sliderCollectionView.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderCollectionViewCell")
        sliderCollectionView.showsHorizontalScrollIndicator = false
        sliderCollectionView.isPagingEnabled = true
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
