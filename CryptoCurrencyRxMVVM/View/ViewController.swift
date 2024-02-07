//
//  ViewController.swift
//  CryptoCurrencyRxMVVM
//
//  Created by Oğuzhan Gümüş on 6.02.2024.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableview: UITableView!
    let cryptoVM = CryptoViewmodel()
    let disposeBag = DisposeBag()
    
    var cryptoList = [Crypto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        setupBinding()
        cryptoVM.RequestData()
        
        

    }
    private func setupBinding(){
        cryptoVM.loading
            .bind(to: self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
                
            

        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { errorString in
                print(errorString)
            } .disposed(by:disposeBag) // -String- Variable that returns from func
        cryptoVM
            .cyptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { cryptos in
                self.cryptoList = cryptos
                self.tableview.reloadData()
            }.disposed(by: disposeBag)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }

}

