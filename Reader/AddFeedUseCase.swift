//
//  AddFeedUseCase.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/07/31.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation
import RxSwift
import Action


final class AddFeedUseCase {
    enum State {
        case initial
        case loading
        case loaded
        case completed
    }
    
    static let didRegisterFeed = Notification.Name("AddFeedUseCaseDidRegisterFeed")
    
    let state = Variable<State>(.initial)
    let feedInfo = Variable<Feed?>(nil)
    let errors = PublishSubject<Error>()
    
    private let fetchFeedInfoAction: Action<URL, Feed>
    private let registerFeedAction: Action<Feed, Void>
    
    init(feedAPI: FeedAPI, feedStore: FeedStore) {
        self.fetchFeedInfoAction = Action { url in
            return feedAPI.fetchFeedInfo(url: url)
        }
        self.registerFeedAction = Action { feed in
            return feedStore.register(feed: feed)
        }
        
        _ = fetchFeedInfoAction.elements.bind(to: feedInfo)
        _ = Observable.merge(fetchFeedInfoAction.errors, registerFeedAction.errors)
            .flatMapLatest { (e) -> Observable<Error> in
                switch e {
                case .notEnabled:
                    return .empty()
                case .underlyingError(let error):
                    return .just(error)
                }
            }
            .bind(to: errors)
    }
    
    func fetchFeedInfo(url: URL) {
        _ = fetchFeedInfoAction.execute(url)
            .do(onCompleted: { self.state.value = .loaded }, onSubscribed: { self.state.value = .loading })
            .subscribe()
    }
    
    func registerFeed() {
        precondition(feedInfo.value != nil)
        
        _ = registerFeedAction.execute(feedInfo.value!)
            .subscribe(onCompleted: {
                self.state.value = .completed
                NotificationCenter.default.post(name: AddFeedUseCase.didRegisterFeed, object: self)
            })
    }
}
