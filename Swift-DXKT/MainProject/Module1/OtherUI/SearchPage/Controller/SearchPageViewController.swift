//
//  SearchPageViewController.swift
//  GMChat
//
//  Created by GXT on 2019/6/19.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class SearchPageViewController: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchBookList()
    }
    
    @objc func selectedTheUser(_ rowModel: RowModel) {
        var model: BookListModel = rowModel.dataModel as! BookListModel
        let peopleVC = PeopleInfoController()
        peopleVC.name = model.name
        peopleVC.phone = model.phone
        peopleVC.id = model.id
        if model.textLog.isEmpty {
            model.eMail = String(arc4random_uniform(900000) + 100000) + "@qq.com"
            model.address = "中国 北京"
            model.textLog = "你好,这是一个测试,测试通讯录demo,很高兴认识你,期待一起合作,你好,这是一个测试,测试通讯录demo,很高兴认识你,期待一起合作"
        }
        peopleVC.eMail = model.eMail
        peopleVC.address = model.address
        peopleVC.textLog = model.textLog
        navigationController?.pushViewController(peopleVC, animated: true)
        
    }

    
    func fetchBookList() {
        fetchAllAddressBookList { (listArray) in
            bookListArray = listArray
        }
    }
    
    func setupViews() {
        view.addSubview(searchBar)
        searchBar.cancleSearchCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
        view.addSubview(tableView)
    }
    
    lazy var bookListArray: [BookListModel] = {
        let bookListArray: [BookListModel] = []
        return bookListArray
    }()
    
    lazy var dataArray: [SectionModel] = {
        var dataArray: [SectionModel] = []
        let titlesArr = ["联系人"]
        for i in 0..<titlesArr.count {
            let sectionModel = SectionModel(title: titlesArr[i])
            sectionModel.headerHeight = 30
            sectionModel.footerHeigth = 0.1
            dataArray.append(sectionModel)
        }
        return dataArray
    }()
    
    lazy var searchBar: SearchPageSearchBarView = {
        let searchBar = SearchPageSearchBarView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavHeight, width: kScreenWidth, height: kScreenHeight - kNavHeight - kTabBarHeight), style: .plain)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = JhGrayColor(246)
        return tableView
    }()
}

extension SearchPageViewController: SearchPageSearchBarViewDelegate {
    func textFieldShouldClear(_ textField: UITextField) {
        
    }
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        print(text)
        
        dataArray.first?.mutableCells.removeAll()
        dataArray.last?.mutableCells.removeAll()
        // 联系人
        for listModel in bookListArray {
            if listModel.name.range(of: text) != nil {
                let rowModel = RowModel(title: nil, className: NSStringFromClass(BookListCell.self), reuseIdentifier: NSStringFromClass(BookListCell.self))
                rowModel.accessoryType = .none
                rowModel.dataModel = listModel
                rowModel.height = 64
                rowModel.selectorString = "selectedTheUser:"
                dataArray.first?.mutableCells.append(rowModel)
            }
        }
        tableView.reloadData()
    }
}

extension SearchPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionModel = dataArray[indexPath.section]
        let cellModel = sectionModel.mutableCells[indexPath.row]
        let selString = cellModel.selectorString
        if selString != nil {
            let selec = NSSelectorFromString(cellModel.selectorString ?? "")
            if self.responds(to: selec) {
                self.perform(selec, with: cellModel)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = dataArray[section]
        return sectionModel.mutableCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionModel = dataArray[indexPath.section]
        let cellModel = sectionModel.mutableCells[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier!)
        if cell == nil {
            let className = NSClassFromString(cellModel.className!) as? UITableViewCell.Type
            cell = className!.init(style: cellModel.style, reuseIdentifier: cellModel.reuseIdentifier)
        }
        cellModel.indexPath = indexPath
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionModel = dataArray[indexPath.section]
        let cellModel = sectionModel.mutableCells[indexPath.row]
        let selString = cellModel.showDataString
        if selString != nil {
            let selec = NSSelectorFromString(cellModel.showDataString ?? "")
            if cell.responds(to: selec) {
                cell.perform(selec, with: cellModel)
            }
        }
        cell.accessoryType = cellModel.accessoryType
        cell.selectionStyle = cellModel.selectionStyle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = dataArray[indexPath.section]
        let cellModel = sectionModel.mutableCells[indexPath.row]
        return cellModel.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = dataArray[section]
        
        if sectionModel.headerHeight < 1 {
            return nil
        }
        
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(BookListHeaderView.self))
        
        if headerView == nil {
            headerView = BookListHeaderView(reuseIdentifier: NSStringFromClass(BookListHeaderView.self))
        }
        
        (headerView as! BookListHeaderView).title = sectionModel.title
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = dataArray[section]
        return sectionModel.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = dataArray[section]
        return sectionModel.footerHeigth
    }
}
