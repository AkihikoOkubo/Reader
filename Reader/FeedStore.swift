//
//  FeedStore.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/08/01.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation
import RxSwift


protocol FeedStore {
    func register(feed: Feed) -> Observable<Void>
    func getAll() -> Observable<[Feed]>
}
