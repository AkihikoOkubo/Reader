//
//  Feed.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/07/28.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation


struct Feed {
    enum Format {
        case rss
    }
    
    var title: String
    var link: URL
    var description: String
    var format: Format

}
