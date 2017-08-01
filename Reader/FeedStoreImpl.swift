//
//  FeedStoreImpl.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/08/01.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

final class FeedStoreImpl: FeedStore {
    
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func register(feed: Feed) -> Observable<Void> {
        let realm = self.realm
        return Observable.create({ (observer) -> Disposable in
            do {
                try realm.write {
                    let obj = FeedObject.from(feed)
                    realm.add(obj)
                }
                observer.onCompleted()
            } catch (let e) {
                observer.onError(e)
            }
            
            return BooleanDisposable()
        })
    }
    
    func getAll() -> Observable<[Feed]> {
        let realm = self.realm
        return Observable.create({ (observer) -> Disposable in
            let objects = realm.objects(FeedObject.self)
            do {
                let feeds = try objects.map { try $0.feed() }
                observer.onNext([Feed](feeds))
                observer.onCompleted()
            } catch (let e) {
                observer.onError(e)
            }
            return BooleanDisposable()
        })
    }
}
