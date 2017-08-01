//
//  FeedListViewController.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/07/31.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import UIKit
import RxSwift


final class FeedListViewController: UITableViewController {
    private let usecase = FeedListUseCase(feedStore: FeedStoreImpl(realm: Environment.defaultRealm))
    private var presenter: FeedListPresenter!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = FeedListPresenter(usecase: usecase, navigator: self)
        presenter.list.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView?.reloadData()
            })
            .addDisposableTo(bag)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter.cellData(at: indexPath) {
        case .feed(let feed):
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath)
            cell.textLabel?.text = feed.title
            return cell
        case .addNewFeed:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewFeedCell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCell(at: indexPath)
    }
}


extension FeedListViewController: FeedListNavigator {
    func presentAddView() {
        present(AddFeedViewController.instantiate(), animated: true)
    }
}
