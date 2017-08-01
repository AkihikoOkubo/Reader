//
//  FeedAPIImpl.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/07/31.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation
import RxSwift


final class FeedAPIImpl: FeedAPI {
    func fetchFeedInfo(url: URL) -> Observable<Feed> {
        return Observable.just(Feed(title: "test", link: url, description: "testtest", format: .rss)).delay(1.0, scheduler: MainScheduler.asyncInstance)
    }
}
