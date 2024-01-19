//
//  AddInfoController.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/11.
//

import UIKit

class AddInfoController: BaseViewController,UITextFieldDelegate {
    var name: String!
    var isChangeData = false
    var changeArray: [String]!
    
    let publishSub = PublishSubject<[String:String]>()
    var addInfoDic: [String:String]!
    deinit {
        SLog("销毁")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "新建联系人"
        navRightTitle = "完成"
        
        addInfoDic = ["add":"YES"]
        
        ClickNavRightItemBlock = { [weak self] in
            SLog("点击右侧导航栏")
            
            self?.view.endEditing(true)
            if self!.addInfoDic.keys.count > 4{
                if self!.isChangeData {
                    self?.addInfoDic["add"] = ""
                } else {
                    self?.addInfoDic["add"] = "YES"
                    self?.addInfoDic["id"] = String(format: "%04d", arc4random_uniform(10000))
                }
                self?.publishSub.onNext(self!.addInfoDic)
                self?.navigationController?.popViewController(animated: true)
                self?.addInfoDic.removeAll()
                self?.tableView.reloadData()
               
            }else{
                YItoast("请完善信息")
            }
            
        }
        setupViews()
    }

    func setupViews() {
        view.addSubview(tableView)
    }
    

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kTableViewY, width: kScreenWidth, height: kTableViewHeight), style: .grouped)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = self.infoView
        return tableView
    }()

    lazy var infoView: UIView = {
        let infoView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 10))
        infoView.backgroundColor = JhGrayColor(246)
        return infoView
    }()

    lazy var dataArray: [String] = {
        let dataArray: [String] = [
            "姓名: ",
            "手机号: ",
            "邮箱号: ",
            "地址: ",
            "简介: ",
        ]
        return dataArray
    }()
    
    /// 文本栏
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count <= 0 {
            return
        }
        
        switch textField.tag {
            
        case 100:
            addInfoDic["name"] = textField.text
        case 101:
            addInfoDic["phone"] = textField.text
        case 102:
            addInfoDic["eMail"] = textField.text
        case 103:
            addInfoDic["address"] = textField.text
        case 104:
            addInfoDic["textLog"] = textField.text
        default: break
            
        }
    }
}

extension AddInfoController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellStr = dataArray[indexPath.section]
        let cell = AddInfoCell(style: .default, reuseIdentifier: nil)
        cell.leftLab?.text = cellStr
        cell.peopleTextField?.text = ""
        cell.peopleTextField?.textAlignment = .left
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.peopleTextField.tag = 100 + indexPath.section
        cell.peopleTextField.delegate = self
        // 修改详细信息
        if isChangeData {
            cell.peopleTextField?.text = changeArray[indexPath.section]
            switch cell.peopleTextField?.tag {
                
            case 100:
                addInfoDic["name"] = cell.peopleTextField?.text
            case 101:
                addInfoDic["phone"] = cell.peopleTextField?.text
            case 102:
                addInfoDic["eMail"] = cell.peopleTextField?.text
            case 103:
                addInfoDic["address"] = cell.peopleTextField?.text
            case 104:
                addInfoDic["textLog"] = cell.peopleTextField?.text
            default: break
                
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommonWidth(80)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headV = UIView()
        headV.backgroundColor = .white
        return headV
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headV = UIView()
        headV.backgroundColor = .white
        return headV
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTableViewNoneSectionHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kTableViewNoneSectionHeight
    }
}



