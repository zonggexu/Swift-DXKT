//
//  ThreeViewController.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2021/12/27.
//

import SwiftyJSON
import UIKit
import WebKit
import SwiftUI

class ThreeViewController: BaseViewController {
    var buttonOne: UIButton!
    let fileURL = Bundle.main.url(forResource: "testJson", withExtension: "geojson")
    var testModelArray: [MainCarModel]!
    var viewModel: testViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "测试"
        
        let data = try! Data(contentsOf: fileURL!)

        let cityDicData = JSON(data)

        if let cityDic = cityDicData.dictionaryObject {
            if cityDic.keys.contains("池州市") {
                SLog("\(cityDic["池州市"]!)")
            }
        }
        
        guard let jsonModel = jsonDataToModel(JsonModel.self, data) else {
            return
        }
        SLog(jsonModel.testStr)
        
        guard let jsonStr = modelToJsonString(jsonModel) else { return
        }
        SLog(jsonStr)

        viewModel = testViewModel()

        buttonOne = UIButton(type: .custom)
        buttonOne.backgroundColor = .systemPink
        buttonOne.setTitle("测试8", for: UIControl.State())
        view.addSubview(buttonOne)
        buttonOne.rx.tap
            .subscribe(onNext: {
                self.changeViewModel()
            })
            .disposed(by: disposeBag)

        buttonOne.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.snp.centerY)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(CommonWidth(100))
            make.left.equalTo(self.view.snp.left).offset(CommonWidth(14))
            make.right.equalTo(self.view.snp.right).offset(-CommonWidth(14))
        }

        let tsetLable = UILabel()
        tsetLable.text = "asd"
        view.addSubview(tsetLable)
        tsetLable.snp.makeConstraints { make in

            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.buttonOne.snp.top).offset(CommonWidth(-14))
        }

        viewModel.text
            .bind(to: tsetLable.rx.text)
            .disposed(by: disposeBag)
    }

    func changeViewModel() {
        SLog(lastSevenDays(from: Date(), andNum: 7))
    }

    func lastSevenDays(from date: Date, andNum: Int) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.dateFormat = "M月d日"
        var backStrs = [dateFormatter.string(from: date)]

        for i in 1 ..< andNum {
            if let previousDate = Calendar.current.date(byAdding: .day, value: -i, to: date) {
                backStrs.append(dateFormatter.string(from: previousDate))
            }
        }
        return backStrs
    }

    func testCostomSheetView() {
        let v = ZSSheetView(gradeH: 300)
        v.changeHeightSub.subscribe(onNext: { str, dic in
            SLog("订阅到了: \(str)")
            SLog("订阅到了: \(dic)")
            v.gradeView.Jh_height = 600
            UIView.animate(withDuration: 0.2) {
                v.gradeView.frame.origin.y = v.frame.height - v.gradeView.frame.height
                v.gradeView.backgroundColor = .white
            }

        })
        .disposed(by: disposeBag)
        view.addSubview(v)
        v.show()
    }

    func testHttp() {
        let severDic = ["referral_code": "1234"]
//        HttpTool.request(API.ServiceInterfaceTypeGetTnx(Dic: severDic)) { [weak self] _, _, ReturnAllJson in
//            SLog(ReturnAllJson)
//
//        } failure: { code, msg in
//
//            SLog("code : \(code!)")
//            SLog("message : \(msg)")
//        }
    }
}

/// 支付视图
class ZSSheetView: UIView {
    let changeHeightSub = PublishSubject<(String, [String: String])>()
    let disposeBag = DisposeBag()
    /// 推出视图
    var gradeView: UIView!
    /// 推出高度
    var gradeH: CGFloat!
    /// 分割线
    var fgView: UIView!
    /// 支付金额
    var payNumLb: UILabel!

    // 初始化方法
    init(gradeH: CGFloat) {
        self.gradeH = gradeH
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        backgroundColor = UIColor.black.withAlphaComponent(0)
        gradeView = UIView(frame: CGRect(x: 0, y: Jh_height, width: Jh_width, height: self.gradeH))
        gradeView.backgroundColor = .white
        addSubview(gradeView)
        loadSubViews()
    }

    /// 展示
    func show() {
        UIView.animate(withDuration: 0.5) {
            self.gradeView.frame.origin.y = self.frame.height - self.gradeView.frame.height
            self.backgroundColor = UIColor.black.withAlphaComponent(0.33)
        }
    }

    /// 关闭
    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.gradeView.frame.origin.y = self.frame.height
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { _ in
            self.removeFromSuperview()
        }
    }

    /// UI
    func loadSubViews() {
        creatBaseUI()
        creatPayLb()
    }

    /// 金额
    func creatPayLb() {
        payNumLb = UILabel()
//        payNumLb.text = "\(shopOrder.price)元"
        payNumLb.text = "189.11元"
        payNumLb.font = UIFont.systemFont(ofSize: 38, weight: .medium)
        payNumLb.textColor = UIColorFromRGB("#454545")
        payNumLb.textAlignment = .center
        gradeView.addSubview(payNumLb)
        payNumLb.snp.makeConstraints { make in
            make.top.equalTo(self.fgView.snp.bottom).offset(CommonWidth(26))
            make.centerX.equalTo(self.gradeView.snp.centerX)
        }
    }

    /// 基础UI
    func creatBaseUI() {
        let closebtn = UIButton()
        closebtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closebtn.rx.tap
            .subscribe(onNext: {
                self.hide()
            })
            .disposed(by: disposeBag)
        gradeView.addSubview(closebtn)

        let tipsLab = UILabel()
        tipsLab.textColor = .black
        tipsLab.font = JhBoldFont_20
        tipsLab.text = "团购支付"
        tipsLab.sizeToFit()
        gradeView.addSubview(tipsLab)

        fgView = UIView()
        fgView.backgroundColor = UIColorFromRGB("#EEEEEE")
        gradeView.addSubview(fgView)

        tipsLab.snp.makeConstraints { make in
            make.top.equalTo(self.gradeView.snp.top).offset(CommonWidth(18))
            make.centerX.equalTo(self.gradeView.snp.centerX)
        }
        closebtn.snp.makeConstraints { make in
            make.centerY.equalTo(tipsLab.snp.centerY)
            make.left.equalTo(self.gradeView.snp.left).offset(CommonWidth(18))
            make.height.equalTo(CommonWidth(15))
            make.width.equalTo(CommonWidth(15))
        }
        fgView.snp.makeConstraints { make in
            make.top.equalTo(tipsLab.snp.bottom).offset(CommonWidth(14))
            make.centerX.equalTo(self.gradeView.snp.centerX)
            make.height.equalTo(CommonWidth(1))
            make.width.equalTo(CommonWidth(375))
        }
    }

    func makeSheetBtn() {
        let buttonTwo = UIButton(type: .custom)
        buttonTwo.backgroundColor = .systemPink
        buttonTwo.setTitle("测试8", for: UIControl.State())
        gradeView.addSubview(buttonTwo)
        buttonTwo.rx.tap
            .subscribe(onNext: {
                self.changeHeightSub.onNext(("你好", ["a": "b"]))
            })
            .disposed(by: disposeBag)

        buttonTwo.snp.makeConstraints { make in
            make.centerY.equalTo(self.gradeView.snp.centerY)
            make.centerX.equalTo(self.gradeView.snp.centerX)
            make.height.equalTo(CommonWidth(100))
            make.width.equalTo(CommonWidth(100))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    PreviewContainer {
        let controller = ThreeViewController()
        return controller
    }
}
