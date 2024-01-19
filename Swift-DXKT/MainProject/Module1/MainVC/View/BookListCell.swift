//
//  BookListCell.swift
//  GMChat
//
//  Created by GXT on 2019/6/17.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class BookListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @objc func showDefaultDataWithRowModel(_ rowModel: RowModel) {
        headerImageView.image = UIImage(named: rowModel.imageName!)
        nameLab.text = rowModel.title
    }
    
    @objc func showDataWithRowModel(_ rowModel: RowModel) {
        let listModel = rowModel.dataModel as! BookListModel
    
        headerImageView.image = UIImage(named: "common_user_header_image_place")
        
        nameLab.text = listModel.name
    }
    
    func setupViews() {
        headerImageView.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalTo(self.contentView.snp.centerY).offset(0)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(10)
            make.centerY.equalTo(self.contentView.snp.centerY).offset(0)
        }
    }
    
    lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: UIImage(named: "common_user_header_image_place"))
        headerImageView.layer.cornerRadius = 4
        headerImageView.layer.masksToBounds = true
        self.contentView.addSubview(headerImageView)
        return headerImageView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.textColor = UIColorFromRGB("#000000")
        nameLab.font = JhFont(16)
        self.contentView.addSubview(nameLab)
        return nameLab
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
