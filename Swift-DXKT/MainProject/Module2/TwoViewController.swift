//
//  TwoViewController.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/11.
//

import UIKit

class TwoViewController: BaseViewController {
    var headerImageView : UIImageView!
    var buttonOne : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "消息"
        makeView()
    }
    func makeView() {
        
        
        buttonOne = UIButton(type: .custom)
        buttonOne.backgroundColor = .systemPink
        buttonOne.setTitle("测试8", for: UIControl.State())
        view.addSubview(buttonOne)
        buttonOne.rx.tap
            .subscribe(onNext: {
                
                self.goCeShiVC()
            })
            .disposed(by: disposeBag)

        buttonOne.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.snp.centerY)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(CommonWidth(100))
            make.width.equalTo(CommonWidth(100))
        }
        
        headerImageView = UIImageView(image: UIImage(named: "pop_num_refresh_btn_normal"))
        headerImageView.layer.cornerRadius = 4
        headerImageView.layer.masksToBounds = true
        view.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { make in
            make.bottom.equalTo(buttonOne.snp.top).offset( -30)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(CommonWidth(100))
            make.width.equalTo(CommonWidth(100))
        }
    }
    func goCeShiVC() {
        let csVC = CeShiController()
        csVC.CSpublishSub.subscribe(onNext: { (str,dic) in
            SLog("订阅到了: \(str)")
            YItoast(str)
            SLog(dic)
        })
        .disposed(by: disposeBag)
        
        
        
        navigationController?.pushViewController(csVC, animated: true)
       
//        let ceShiStr = "abdcefccffkkkzzz"
//        findMostChar(ceShiStr)
//        let asd = get_gcd(100, 20)
//        print(asd)
        
        /// 属性动画
//        UIView.animate(withDuration: 5) {
//            self.buttonOne.backgroundColor = .red
//            self.view.backgroundColor = .yellow
//            self.buttonOne.snp.updateConstraints { make in
//                make.width.equalTo(CommonWidth(200))
//            }
//            self.buttonOne.layoutIfNeeded()
//
//        }
//        /// 转场动画
//        UIView.transition(with: self.headerImageView, duration: 5, options: .transitionCrossDissolve, animations: {
//            self.headerImageView.image = UIImage(named: "pop_num_refresh_btn_bg_normal")
//
//
//        }, completion: {_ in
////            self.headerImageView.image = UIImage(named: "pop_num_refresh_btn_normal")
//            SLog("动画执行完毕")
//        })
    }
    
    /// 求出现次数最多的字符
    func findMostChar(_ input: String) {
        var maxCount = 0
        var maxChar: Character = " "
        var currentCount = 0
        var currentChar: Character = " "
        
        for char in input {
            if char.isLetter && char.isLowercase {
                if char != currentChar {
                    currentChar = char
                    currentCount = 1
                } else {
                    currentCount += 1
                }
                
                if currentCount > maxCount {
                    maxCount = currentCount
                    maxChar = currentChar
                }
            } else {
                print("-1")
                return
            }
        }
        
        if maxCount > 0 {
            print("出现最多的字符: \(maxChar), 出现次数: \(maxCount)")
        }
    }
    /// 求最大公约数
    func get_gcd(_ number1: Int, _ number2: Int) -> Int {
        var a = number1
        var b = number2

        while b != 0 {
            let remainder = a % b
            a = b
            b = remainder
        }
        
        return a
    }
    



}
