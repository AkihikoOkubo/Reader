//
//  FeedListUseCase.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/08/01.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation
import RxSwift
import Action


final class FeedListUseCase {
    let list = Variable<[Feed]>([])
    let errors = PublishSubject<Error>()
    
    private let refreshAction: Action<Void, [Feed]>
    private let bag = DisposeBag()
    
    init(feedStore: FeedStore) {
        refreshAction = Action(workFactory: { _ in
            return feedStore.getAll()
        })
        
        _ = refreshAction.elements.bind(to: list)
        
        NotificationCenter.default.rx.notification(AddFeedUseCase.didRegisterFeed)
            .subscribe(onNext: { [weak self] _ in
                self?.refresh()
            })
            .addDisposableTo(bag)
    }
    
    func refresh() {
        refreshAction.execute()
    }
}
