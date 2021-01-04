//
//  NotificationViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/9/20.
//

import UIKit
import SkeletonView

extension NotificationViewController {
    static func instantiate() -> NotificationViewController {
        return NotificationViewController()
    }
}

class NotificationViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var shouldAnimate = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle("Notifications".localized)
        self.tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        tableView.rowHeight = 50
        tableView.estimatedRowHeight = 60
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.shouldAnimate = false
            self.tableView.reloadData()
        }
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        if !shouldAnimate  {
            cell.hideSkeleton()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
