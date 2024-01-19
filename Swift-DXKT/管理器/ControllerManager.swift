//
//  ControllerManager.swift
//  Baocase-Baby
//
//  Created by 宗森 on 2023/3/29.
//

import UIKit
import WebKit

class ControllerManager {
    static let SharedInstance = ControllerManager()

    var newStr: String = ""

    var crmWebView: WKWebView = .init()

    var socketVC = TwoViewController()
    
    var mainDataArray: [BookListModel]!
    
    private init() {}

    func doSomething() {
        print("Doing something...")
    }

    /// 缓存crmView
    func laodWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.selectionGranularity = .dynamic
        configuration.preferences = WKPreferences()
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        configuration.preferences.javaScriptEnabled = true
        crmWebView = WKWebView(frame: CGRect(x: 0, y: kTableViewY, width: kScreenWidth, height: kScreenHeight - kNavHeight - kTabBarHeight), configuration: configuration)
        let url = URL(string: "https://sas.baocase.com")
        let request = URLRequest(url: url!)
        crmWebView.load(request)
    }
}
