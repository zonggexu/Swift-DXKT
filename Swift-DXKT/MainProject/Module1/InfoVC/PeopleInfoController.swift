//
//  PeopleInfoController.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/11.
//

import UIKit

class PeopleInfoController: BaseViewController {
    var name: String!
    var phone: String!
    var eMail: String!
    var address: String!
    var textLog: String!
    var id: String!
    var isChanged = false
    
    let publishSub = PublishSubject<[String:String]>()
    var removeInfoDic: [String:String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "联系人详情"
        setupViews()
        reloadData()
    }

    func setupViews() {
        view.addSubview(tableView)
        removeInfoDic = ["remove":""]
    }
    
    func reloadData() {
        
        infoView.nameLab.text = name
        infoView.phoneNumLab.text = "TEL: " + phone
        infoView.mailLab.text = "邮箱: " + eMail
        infoView.addressLab.text = "地址: " + address
        infoView.textLab.text = "简介: " + textLog
        
        infoView.textLab.superview?.layoutIfNeeded()
        var frame = infoView.frame
        frame.size.height = infoView.textLab.Jh_bottom + 50
        infoView.frame = frame
        tableView.tableHeaderView = self.infoView
        tableView.reloadData()
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kTableViewY, width: kScreenWidth, height: kScreenHeight - kTableViewY - kTabBarHeight), style: .grouped)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = self.infoView
        return tableView
    }()

    lazy var infoView: MineMainPageUserInfoView = {
        let infoView = MineMainPageUserInfoView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 144))

        return infoView
    }()

    lazy var dataArray: [String] = {
        let dataArray: [String] = [
            "修改信息",
            "删除联系人",
        ]
        return dataArray
    }()
}

extension PeopleInfoController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:

            let changeVC = AddInfoController()
            changeVC.isChangeData = true
            changeVC.changeArray = [name,phone,eMail,address,textLog]
            navigationController?.pushViewController(changeVC, animated: true)
            changeVC.publishSub.subscribe(onNext: { dict in
                SLog("订阅到了: \(dict)")
                var dic = dict
                if dic["add"]!.isEmpty {
                    self.name = dic["name"]
                    self.phone = dic["phone"]
                    self.eMail = dic["eMail"]
                    self.address = dic["address"]
                    self.textLog = dic["textLog"]
                    self.reloadData()
                    dic["id"] = self.id
                    dic["remove"] = ""
                    /// 已经修改
                    self.isChanged = true
                    self.publishSub.onNext(dic)
                }
            })
            .disposed(by: disposeBag)
        default:
            removeInfoDic["remove"] = "YES"
            removeInfoDic["name"] = name
            publishSub.onNext(removeInfoDic)
            navigationController?.popViewController(animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellStr = dataArray[indexPath.section]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = cellStr
        cell.textLabel?.textAlignment = .center
        cell.accessoryType = .none
        cell.selectionStyle = .gray
        cell.backgroundColor = .white
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.textColor = .black
        default:
            cell.textLabel?.textColor = .red
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommonWidth(45)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CommonWidth(10)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kTableViewNoneSectionHeight
    }
}
