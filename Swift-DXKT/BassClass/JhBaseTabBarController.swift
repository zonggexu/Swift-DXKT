//
//  JhBaseTabBarController.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2021/12/27.
//

import UIKit
import AudioToolbox

class JhBaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItemTitleTextAttributes();
        setupChildViewControllers()
    }
    
    /// 设置所有UITabBarItem的文字属性
    func setupItemTitleTextAttributes() {
        let normalColor = BaseTabBarNormalTextColor;
        let selectColor = BaseTabBarSelectTextColor;
        Jh_setTabBarColor(normalColor, selectColor, UIColorFromRGB("#f5f5f5"))
    }
    
    /// 添加所有子控制器
    func setupChildViewControllers() {
        setupOneChildViewController(childVC: OneViewController(), title: "通讯录", image: "tab_address_book_normal", selectedImage: "tab_address_book_selected")
        setupOneChildViewController(childVC: TwoViewController(), title: "消息", image: "tab_session_normal", selectedImage: "tab_session_selected")
    
        setupOneChildViewController(childVC: ThreeViewController(), title: "测试", image: "tab_address_dynamic_normal", selectedImage: "tab_address_dynamic_selected")
        setupOneChildViewController(childVC: FourViewController(), title: "我的", image: "tab_user_normal", selectedImage: "tab_user_selected")
    }
    
    /// 初始化一个子控制器
    fileprivate func setupOneChildViewController(childVC:UIViewController,title:String,image:String,selectedImage:String) {
        //设置tabbar的文字
        childVC.tabBarItem.title = title;
        if (image.count>0) { // 图片名有具体值
            childVC.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
            // 声明：这张图片按照原始的样子显示出来，不要自动渲染成其他颜色（比如蓝色）
            childVC.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        }
        let nav = JhBaseNavigationController.init(rootViewController: childVC)
        self.addChild(nav)
    }
    
    /// 点击震动
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        AudioServicesPlaySystemSound(1519)
//    }
}

// MARK: - 设置TabBar 文字颜色和背景色
func Jh_setTabBarColor(_ normalColor:UIColor,_ selectColor:UIColor,_ bgColor:UIColor?) {
    let tabBarItem = UITabBarItem.appearance()
    
    // 普通状态下的文字属性
    var normalAttrs = Dictionary<NSAttributedString.Key,Any>()
    normalAttrs[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 10)
    normalAttrs[NSAttributedString.Key.foregroundColor] = normalColor
    // 选中状态下的文字属性
    var selectedAttrs = Dictionary<NSAttributedString.Key,Any>()
    selectedAttrs[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 10)
    selectedAttrs[NSAttributedString.Key.foregroundColor] = selectColor
    
    tabBarItem.setTitleTextAttributes(normalAttrs, for: .normal)
    tabBarItem.setTitleTextAttributes(selectedAttrs, for: .selected)
    
    // iOS13适配，处理未选中颜色失效
    if #available(iOS 13.0, *) {
        UITabBar.appearance().unselectedItemTintColor = normalColor
    }
    // iOS15适配，处理tabBar背景和分割线透明，选中颜色失效
    if #available(iOS 15.0, *) {
        let appearance = UITabBarAppearance();
        if (bgColor != nil) {
            appearance.backgroundColor = bgColor; // tabBar背景颜色
        }
        //        appearance.backgroundEffect = nil; // 去掉半透明效果
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs;
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs;
        UITabBar.appearance().standardAppearance = appearance;
        UITabBar.appearance().scrollEdgeAppearance = appearance;
    }
}
