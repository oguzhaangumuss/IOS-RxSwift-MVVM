//
//  CryptoViewmodel.swift
//  CryptoCurrencyRxMVVM
//
//  Created by Oğuzhan Gümüş on 7.02.2024.
//

import Foundation
import RxSwift
import RxCocoa


class CryptoViewmodel {
    
    let cyptos : PublishSubject<[Crypto]> = PublishSubject()
    let error : PublishSubject<String> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject()
    
    func RequestData() {
        self.loading.onNext(true)
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!
        Webservice().downoadCurrencies(url: url) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let cryptos):
                self.cyptos.onNext(cryptos)
                
            case .failure(let error):
                switch error {
                case .serverError: self.error.onNext("Server error..")
                case .parsingError: self.error.onNext("Parsing error")
                }
            
            }
            
        }
        
        
    }
}
