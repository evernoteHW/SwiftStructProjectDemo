//
//  BaseNetworkConfig.swift
//  SwiftStructProject
//
//  Created by WeiHu on 2016/10/17.
//  Copyright © 2016年 WeiHu. All rights reserved.
//

import Foundation

let networkConfig = BaseNetworkConfig()
class BaseNetworkConfig: NSObject {
    class var sharedNetworkConfig: BaseNetworkConfig {
        return networkConfig
    }
}
