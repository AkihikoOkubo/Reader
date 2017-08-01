//
//  AddFeedPresenter.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/07/31.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


protocol AddFeedNavigator: class {
    func goNext()
    func cancel()
}

final class AddFeedPresenter {

    let input = (
        urlText: BehaviorSubject(value: ""),
        goNext: PublishSubject<Void>(),
        cancel: PublishSubject<Void>()
    )
    
    var canGoNext: Driver<Bool> {
        return Driver.combineLatest(input.urlText.asDriver(onErrorDriveWith: .empty()), isLoading) { (text, isLoading) in
            return !text.isEmpty && !isLoading
        }
    }
    var isLoading: Driver<Bool> {
        return usecase.state.asDriver().map { $0 == .loading }
    }
    var errors: Observable<Error> {
        return usecase.errors
    }
    
    private let usecase: AddFeedUseCase
    private let bag = DisposeBag()
    
    init(usecase: AddFeedUseCase, navigator: AddFeedNavigator) {
        self.usecase = usecase
        
        input.goNext
            .subscribe(onNext: { [weak self] _ in
                if let s = self, let urlText = try? s.input.urlText.value(), let url = URL(string: urlText) {
                    usecase.fetchFeedInfo(url: url)
                }
            })
            .addDisposableTo(bag)
        input.cancel
            .subscribe(onNext: { [weak navigator] _ in
                navigator?.cancel()
            })
            .addDisposableTo(bag)
        
        usecase.state
            .asObservable()
            .subscribe(onNext: { [weak navigator] state in
                if state == .loaded {
                    navigator?.goNext()
                }
            })
            .addDisposableTo(bag)
    }
    
}
