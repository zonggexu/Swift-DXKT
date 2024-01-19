//
//  BookListModel.swift
//  GMChat
//
//  Created by GXT on 2019/6/17.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import SwiftyJSON

struct BookListModel: ModelProtocol {
    
    var id: String
    var name: String
    var photo: String
    var phone: String
    var firstCharactor: String
    var eMail: String
    var address: String
    var textLog: String
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.photo = json["photo"].stringValue
        self.phone = json["phone"].stringValue
        self.eMail = json["eMail"].stringValue
        self.address = json["address"].stringValue
        self.textLog = json["textLog"].stringValue
        
        self.firstCharactor = self.name.firCharactor()
    }
    
}
