//
//  FeedAPI.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/07/31.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation
import RxSwift


protocol FeedAPI {
    func fetchFeedInfo(url: URL) -> Observable<Feed>
}

protocol FeedFormatAPI {
    
}
