//
//  OneViewController.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/11.
//

import UIKit

class OneViewController: BaseViewController{
    var lastOffsetY: CGFloat = 0
    var isUpScroll: Bool = false
    var lastHeaderView: BookListHeaderView?
    var nextHeaderView: BookListHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav()
        
        
        ClickNavRightItemBlock = { [weak self] in
            let addVC = AddInfoController()
            let dissPub = DisposeBag()
            addVC.publishSub.subscribe(onNext: { [weak self] dict in
                guard let self = self else { return }
                SLog("订阅到了: \(dict)")
                if dict["add"]!.isEmpty {
                    // do nothing
                } else {
                    //添加
                    let addModel = BookListModel(json: JSON(dict))
                    self.addFetchAddressBookList(addModel)
                }
            })
            .disposed(by: dissPub)
            self?.navigationController?.pushViewController(addVC, animated: true)
        }
        
        
        setupViews()
        fetchAddressBookList()
    }
    
    func initNav() {
        navTitle = "通讯录"
        navRightTitle = "添加"
    }
    
    
    /// 群聊列表
    @objc func teamAdvanceList(_ rowModel: RowModel) {
        YItoast("暂未开放")
    }
    
    /// 服务号列表
    @objc func subscriptionList(_ rowModel: RowModel) {
        YItoast("暂未开放")
        
    }
    
    /// 黑名单
    @objc func blackList(_ rowModel: RowModel) {
        YItoast("暂未开放")
    }
    
    /// 跳转详情
    @objc func clickedTheCell(_ rowModel: RowModel) {
        
        var listModel: BookListModel = rowModel.dataModel as! BookListModel
        SLog(listModel.name)
        let peopleVC = PeopleInfoController()
        peopleVC.name = listModel.name
        peopleVC.phone = listModel.phone
        peopleVC.id = listModel.id
        if listModel.textLog.isEmpty {
            listModel.eMail = String(arc4random_uniform(900000) + 100000) + "@qq.com"
            listModel.address = "中国 北京"
            listModel.textLog = "你好,这是一个测试,测试通讯录demo,很高兴认识你,期待一起合作,你好,这是一个测试,测试通讯录demo,很高兴认识你,期待一起合作"
        }
        peopleVC.eMail = listModel.eMail
        peopleVC.address = listModel.address
        peopleVC.textLog = listModel.textLog
        
        peopleVC.publishSub.subscribe(onNext: { dict in
            SLog("订阅到了: \(dict)")
            if dict["remove"]!.isEmpty {
                //更改
                let addModel = BookListModel(json: JSON(dict))
                self.changeFetchAddressBookList(addModel)
            }else{
                //删除
                let addModel = BookListModel(json: JSON(dict))
                self.removeFetchAddressBookList(addModel)
            }
        })
        .disposed(by: disposeBag)
        navigationController?.pushViewController(peopleVC, animated: true)
    }
    
    /// UI
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(indexView)
    }

    /// lazy
    lazy var searchBar: SearchBar = {
        let searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavHeight, width: kScreenWidth, height: kScreenHeight - kNavHeight - kTabBarHeight), style: .plain)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = JhGrayColor(246)
        tableView.tableHeaderView = self.searchBar
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var dataArray: [SectionModel] = {
        let dataArray: [SectionModel] = []
        return dataArray
    }()
    
    lazy var allFriendsListArray: [BookListModel] = {
        let allFriendsListArray: [BookListModel] = []
        return allFriendsListArray
    }()
    
    lazy var charactorsArray: [String] = {
        let charactorsArray: [String] = []
        return charactorsArray
    }()
    
    lazy var indexView: BookListIndexView = {
        let indexView = BookListIndexView(frame: .zero)
        indexView.delegate = self
        return indexView
    }()

}

/// 数据组装和排序
extension OneViewController {
    /// 获取通讯录的数据
    func fetchAddressBookList() {
        
        fetchAllAddressBookList { (listArray) in
            
            allFriendsListArray = listArray
            getAllfriendNameMetter(modelList: allFriendsListArray)
            defaultList()
            tableView.reloadData()
            indexView.reloadIndex(charactorsArray: charactorsArray)
        }
        
    }
    /// 添加通讯录的数据
    func addFetchAddressBookList(_ addModel: BookListModel) {
        dataArray.removeAll()
        charactorsArray.removeAll()
        fetchAllAddressBookList { (listArray) in
            allFriendsListArray = listArray
            allFriendsListArray.append(addModel)
            ControllerManager.SharedInstance.mainDataArray.append(addModel)
            getAllfriendNameMetter(modelList: allFriendsListArray)
            defaultList()
            indexView.reloadIndex(charactorsArray: charactorsArray)
            tableView.reloadData()
        }
    }
    /// 删除通讯录的数据
    func removeFetchAddressBookList(_ addModel: BookListModel) {
        dataArray.removeAll()
        charactorsArray.removeAll()
        fetchAllAddressBookList { (listArray) in
            allFriendsListArray = listArray
            for (index, model) in allFriendsListArray.enumerated() {
                if model.name == addModel.name {
                    allFriendsListArray.remove(at: index)
                    ControllerManager.SharedInstance.mainDataArray.remove(at: index)
                    break
                }
            }
            
            getAllfriendNameMetter(modelList: allFriendsListArray)
            defaultList()
            tableView.reloadData()
            indexView.reloadIndex(charactorsArray: charactorsArray)
        }
    }
    /// 更改通讯录的数据
    func changeFetchAddressBookList(_ addModel: BookListModel) {
        dataArray.removeAll()
        charactorsArray.removeAll()
        fetchAllAddressBookList { (listArray) in
            allFriendsListArray = listArray
            for (index, model) in allFriendsListArray.enumerated() {
                if model.id == addModel.id {
                    allFriendsListArray[index] = addModel
                    ControllerManager.SharedInstance.mainDataArray[index] = addModel
                    break
                }
            }
            
            getAllfriendNameMetter(modelList: allFriendsListArray)
            defaultList()
            tableView.reloadData()
            indexView.reloadIndex(charactorsArray: charactorsArray)
        }
    }
    
    
    /// default list
    func defaultList() {
        let imageArray = [ "book_team_advance_normal",  "book_subscription_list_icon", "book_black_list_normal"]
        let titleArray = [ "最近联系人", "服务号", "黑名单"]
        let selStrArray = ["teamAdvanceList:",  "subscriptionList:", "blackList:"]
        let sectionModel = SectionModel()
        for i in 0..<imageArray.count {
            let rowModel = RowModel(title: titleArray[i], className: NSStringFromClass(BookListCell.self), reuseIdentifier: NSStringFromClass(BookListCell.self))
            rowModel.imageName = imageArray[i]
            rowModel.height = 64
            rowModel.accessoryType = .none
            rowModel.showDataString = "showDefaultDataWithRowModel:"
            rowModel.selectorString = selStrArray[i]
            sectionModel.mutableCells.append(rowModel)
        }
        
        dataArray.insert(sectionModel, at: 0)
    }
    
    /// 首字母相同的放在一起
    func getAllfriendNameMetter(modelList: [BookListModel]){
        
        for friendModel in modelList {
            
            let rowModel = RowModel(title: nil, className: NSStringFromClass(BookListCell.self), reuseIdentifier: NSStringFromClass(BookListCell.self))
            rowModel.height = 64
            rowModel.accessoryType = .none
            rowModel.selectorString = "clickedTheCell:"
            rowModel.dataModel = friendModel
            
            
            let charactor = friendModel.firstCharactor
            
            var isNewCharactor = true
            
            for sectionModel in dataArray {
                if sectionModel.title == charactor {
                    isNewCharactor = false
                    sectionModel.mutableCells.append(rowModel)
                    break
                }
            }
            
            if isNewCharactor {
                let currentSectionModel = SectionModel(title: charactor)
                currentSectionModel.headerHeight = 24;
                currentSectionModel.mutableCells.append(rowModel)
                charactorsArray.append(charactor)
                dataArray.append(currentSectionModel)
            }
        }
    }
    
}

/// search
extension OneViewController: SearchBarDelegate, BookListIndexViewDelegate {
    func clickedTheSearchBar() {
        navigationController?.pushViewController(SearchPageViewController(), animated: false)
    }
    
    func touchTheChactor(index: Int, lastIndex: Int, charactor: String) {
        if index > lastIndex {
            isUpScroll = true
        } else {
            isUpScroll = false
        }
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: false)
    }
}

/// tableview delegate datasource
extension OneViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        
        if (self.tableView.isDragging || self.tableView.isDecelerating) && isUpScroll {

            (view as? BookListHeaderView)?.titleColor = UIColorFromRGB("#999999")
            (view as? BookListHeaderView)?.contentView.backgroundColor = JhGrayColor(246)
            
            let nextHeader = tableView.headerView(forSection: section + 1)
            (nextHeader as? BookListHeaderView)?.titleColor = BaseThemeColor
            (nextHeader as? BookListHeaderView)?.contentView.backgroundColor = .white
            
            indexView.changeTheIndex(currentSelectedIndex: section + 1, lastSelectedIndex: section)
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if !isUpScroll && (self.tableView.isDragging || self.tableView.isDecelerating) {

            (view as? BookListHeaderView)?.titleColor = BaseThemeColor
            (view as? BookListHeaderView)?.contentView.backgroundColor = .white
            
            let nextHeader = tableView.headerView(forSection: section + 1)
            (nextHeader as? BookListHeaderView)?.titleColor = UIColorFromRGB("#999999")
            (nextHeader as? BookListHeaderView)?.contentView.backgroundColor = JhGrayColor(246)
            
            indexView.changeTheIndex(currentSelectedIndex: section, lastSelectedIndex: section + 1)
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = dataArray[section]
        return sectionModel.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = dataArray[section]
        return sectionModel.footerHeigth
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isUpScroll = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
    }
}










// MARK: 其他

extension OneViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                // 适配代码
                configureTheme()
            }
        }
    }

    private func configureTheme() {
        initNav()
    }
}
