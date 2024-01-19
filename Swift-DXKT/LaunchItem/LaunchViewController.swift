//  启动页
//  LaunchViewController.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/10.
//


import UIKit

class LaunchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        /// 启动页
        let launchImageView = UIImageView(frame: view.bounds)
        launchImageView.image = UIImage(named: "WSLaunchImage4.1")
        launchImageView.contentMode = .scaleAspectFill
        view.addSubview(launchImageView)
        SLog("进入app")
        getFetchAllAddressBookList()
        self.toHomeVc()
    
    }
}
