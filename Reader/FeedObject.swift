//
//  FeedObject.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/08/01.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation
import RealmSwift

final class FeedObject: RealmSwift.Object {
    enum Format: String {
        case rss = "rss"
        
        init(_ format: Feed.Format) {
            switch format {
            case .rss:
                self = .rss
            }
        }
        
        var format: Feed.Format {
            switch self {
            case .rss:
                return .rss
            }
        }
    }
    
    dynamic var title = ""
    dynamic var link = ""
    dynamic var descript = ""
    dynamic var format = ""
    
    static func from(_ feed: Feed) -> FeedObject {
        let obj = FeedObject()
        obj.title = feed.title
        obj.link = feed.link.absoluteString
        obj.descript = feed.description
        obj.format = Format(feed.format).rawValue
        return obj
    }
    
    func feed() throws -> Feed {
        guard let url = URL(string: link), let format = Format(rawValue: format)?.format else {
            throw Error.conversionFailed
        }
        return Feed(title: title, link: url, description: descript, format: format)
    }
    
    enum Error: Swift.Error {
        case conversionFailed
    }
}

