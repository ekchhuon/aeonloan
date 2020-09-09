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
    
    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var contactusView: UIView!
    
    var timer = Timer()
    var counter = 0
    var longPressed: Bool = false
    var defaultInterval: TimeInterval = 3
    
    var imageArray = [UIImage(named: "leaf"), UIImage(named: "leaf.fill"), UIImage(named: "leaf"), UIImage(named: "leaf.fill"), UIImage(named: "leaf"), UIImage(named: "leaf.fill")]
    
    var numbers = ["1", "2", "3", "4", "5", "6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .red
        sliderCollectionView.alwaysBounceHorizontal = true
        sliderCollectionView.refreshControl = refreshControl // iOS 10+
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        // stuff here
        
        // changeSlideShow()
        
        refreshControl.endRefreshing()
    }
    
    @objc
    func handleClick(){
        let login = LoginViewController.instantiate()
        navigationController?.pushViewController(login, animated: true)
    }
    
    @objc
    func navigateToNotification() {
        let notification = NotificationViewController.instantiate()
        navigationController?.pushViewController(notification, animated: true)
    }
    
    @objc
    func showSideMenu() {
        
//        let menu = SideMenuNavigationController(nibName: "SideMenuViewController", bundle: nil)
        let menu = SideMenuNavigationController(rootViewController: SideMenuViewController.instantiate())
         
//        menu.animationOptions = .curveEaseIn
//        menu.menuWidth = 250
//        menu.presentationStyle = .menuSlideIn
//        menu.pushStyle = .preserve
        menu.leftSide = true
//        menu.blurEffectStyle = .extraLight
        
//        menu.navigationBar.barStyle = .default
        menu.navigationBar.backgroundColor = .red
        menu.navigationBar.barTintColor = .brandPurple
        
        menu.settings = sideMenuSetting()
        
        
        present(menu, animated: true, completion: nil)
    }
    
    func setupSideMenu() {
        
    }
    
    func sideMenuSetting() -> SideMenuSettings {
        var presentation: SideMenuPresentationStyle = SideMenuPresentationStyle()
        presentation = .menuSlideIn
//        presentation.menuScaleFactor = 1
//        presentation.onTopShadowOpacity = 0.5
//        presentation.backgroundColor = .red
        
//        presentation.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        presentation.menuStartAlpha = 1
        presentation.menuScaleFactor = 1
        presentation.onTopShadowOpacity = 0
        presentation.presentingEndAlpha = 0.5
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
        if collectionView == sliderCollectionView {
            let detailed = SliderDetailViewController.instantiate(index: indexPath, item: numbers[indexPath.row])
            navigationController?.pushViewController(detailed, animated: true)
        }else {

        }

    }
}

// Private
extension HomeViewController{
    private func setupView() {
        
        setupSliderView()
        setupGridView()
        setupNavigationBar()
        setupPageControl()
        changeSlideShow()
        setupLongGestureRecognizerOnCollection()
        
        locationView.roundCorners([.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 10, borderColor: .brandMaginta, borderWidth: 1)
        contactusView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner], radius: 10, borderColor: .brandMaginta, borderWidth: 1)
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
    
    @objc func changeSlideShow() {
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
    
    // stop slider when long press began
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        sliderCollectionView?.addGestureRecognizer(longPressedGesture)
    }
    
    @objc
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        longPressed = gestureRecognizer.state == .began
    }
}
