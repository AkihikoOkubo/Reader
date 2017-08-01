//
//  AddFeedViewController.swift
//  Reader
//
//  Created by kazuyuki takahashi on 2017/07/31.
//  Copyright © 2017年 kazuyuki takahashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import RealmSwift


final class AddFeedViewController: UITableViewController {
    
    static func instantiate() -> UIViewController {
        return UIStoryboard(name: "AddFeedViewController", bundle: nil).instantiateInitialViewController()!
    }
    
    fileprivate let usecase = AddFeedUseCase(feedAPI: FeedAPIImpl(), feedStore: FeedStoreImpl(realm: Environment.defaultRealm))
    private var presenter: AddFeedPresenter!
    private var bag = DisposeBag()
    
    @IBOutlet private weak var urlField: UITextField!
    @IBOutlet private weak var goNextButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AddFeedPresenter(usecase: usecase, navigator: self)
        
        presenter.canGoNext
            .drive(goNextButton.rx.isEnabled)
            .addDisposableTo(bag)
        presenter.isLoading
            .asObservable()
            .subscribe(onNext: { isLoading in
                if isLoading {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            })
            .addDisposableTo(bag)
        presenter.errors
            .subscribe(onNext: { [weak self] e in
                self?.present(Alert(error: e).alertController(), animated: true)
            })
            .addDisposableTo(bag)
        
        urlField.rx.text.asObservable()
            .map({ $0 ?? "" })
            .bind(to: presenter.input.urlText)
            .addDisposableTo(bag)
        goNextButton.rx.tap.asDriver()
            .drive(presenter.input.goNext)
            .addDisposableTo(bag)
        cancelButton.rx.tap.asDriver()
            .drive(presenter.input.cancel)
            .addDisposableTo(bag)
        
    }
}

extension AddFeedViewController: AddFeedNavigator {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Next"?:
            let vc = segue.destination as! AddFeedConfirmViewController
            vc.usecase = usecase
        default:
            fatalError()
        }
    }
    
    func goNext() {
        performSegue(withIdentifier: "Next", sender: nil)
    }
    
    func cancel() {
        dismiss(animated: true)
    }
}
