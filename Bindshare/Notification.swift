//
//  Notification.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/6/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class Notification: NSObject {
    var message: String?
    var time: Int!
    var sender: String!
    var senderUsername: String!
    var imageUrl: String?
    var senderUid: String!
    var key: String!
    var friendRequest: String?
    var binderRequest: String?
    var binderKey: String?
    var binderTitle: String?
    var unseenMessage: String?
}
