//
//  AddFeedConfirmViewController.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/07/31.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import UIKit
import RxSwift


final class AddFeedConfirmViewController: UITableViewController {
    var usecase: AddFeedUseCase!
    private var presenter: AddFeedConfirmPresenter!
    private let bag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AddFeedConfirmPresenter(usecase: usecase, navigator: self)
        presenter.title
            .drive(titleLabel.rx.text)
            .addDisposableTo(bag)
        presenter.description
            .drive(descriptionLabel.rx.text)
            .addDisposableTo(bag)
        
        doneButton.rx.tap
            .asObservable()
            .bind(to: presenter.done)
            .addDisposableTo(bag)
    }
}

extension AddFeedConfirmViewController: AddFeedConfirmNavigator {
    func done() {
        dismiss(animated: true)
    }
}
