//
//  AddFeedConfirmPresenter.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/08/01.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddFeedConfirmNavigator: class {
    func completed()
}

final class AddFeedConfirmPresenter {
    
    let done = PublishSubject<Void>()
    
    var title: Driver<String> {
        return usecase.feedInfo.asDriver().map({ $0?.title ?? "" })
    }
    var description: Driver<String> {
        return usecase.feedInfo.asDriver().map({ $0?.description ?? "" })
    }
    
    private let usecase: AddFeedUseCase
    private let bag = DisposeBag()
    
    init(usecase: AddFeedUseCase, navigator: AddFeedConfirmNavigator) {
        self.usecase = usecase
        
        done.asObservable()
            .subscribe(onNext: { _ in
                usecase.registerFeed()
            })
            .addDisposableTo(bag)
        
        usecase.state.asObservable()
            .subscribe(onNext: { [weak navigator] state in
                if state == .completed {
                    navigator?.completed()
                }
            })
            .addDisposableTo(bag)
    }
}
