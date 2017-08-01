//
//  FeedListPresenter.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/07/31.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import Foundation
import RxSwift


protocol FeedListNavigator: class {
    func presentAddView()
}


final class FeedListPresenter {
    
    enum CellData {
        case feed(Feed)
        case addNewFeed
    }
    
    let list = Variable<[CellData]>([])
    
    private let usecase: FeedListUseCase
    private weak var navigator: FeedListNavigator?
    private let bag = DisposeBag()
    
    init(usecase: FeedListUseCase, navigator: FeedListNavigator) {
        self.usecase = usecase
        self.navigator = navigator
        
        usecase.list.asObservable()
            .map { list -> [CellData] in
                return list.map({ .feed($0) }) + [.addNewFeed]
            }
            .bind(to: list)
            .addDisposableTo(bag)
        
        usecase.refresh()
    }
    
    func numberOfRows() -> Int {
        return list.value.count
    }
    
    func cellData(at indexPath: IndexPath) -> CellData {
        return list.value[indexPath.row]
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        switch list.value[indexPath.row] {
        case .feed:
            break
        case .addNewFeed:
            navigator?.presentAddView()
        }
    }
}
