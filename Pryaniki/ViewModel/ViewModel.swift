//
//  ViewModel.swift
//  Pryaniki
//
//  Created by Wermod on 11.03.2021.
//

import Foundation
import UIKit
import Moya
import RxSwift
import RxCocoa
import ObjectMapper

class ViewModel {
        private let disposeBag = DisposeBag()
        
        private let _itemList = BehaviorRelay<[String]>(value: [])
        private let _dataList = BehaviorRelay<[Datum]>(value: [Datum]())
        private let _isFetching = BehaviorRelay<Bool>(value: false)
        private let _error = BehaviorRelay<String?>(value: nil)
    
        var isFetching: Driver<Bool> {
            return _isFetching.asDriver()
        }
        
        var itemList: Driver<[String]> {
            return _itemList.asDriver()
        }
        
        var dataList: Driver<[Datum]> {
            return _dataList.asDriver()
        }
    
        var error: Driver<String?> {
            return _error.asDriver()
        }
    
        var hasError: Bool {
            return _error.value != nil
        }
    
        var numberOfList: Int {
            return _itemList.value.count
        }
    
        init() {
            self.getData()
        }
    
    private func getData() {
        
        NetworkService().getData() { data in
            self._isFetching.accept(true)
            
            if let data = data {
                let dataObjects: [Datum] = data.data ?? []
                let itemObjects: [String] = data.view ?? []
                self._dataList.accept(dataObjects)
                self._itemList.accept(itemObjects)
                
            } else {
                print("something wrong")
                self._isFetching.accept(false)
                return
            }
        }
        self._isFetching.accept(false)
    }
    
    func prepareCellForDisplay(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var cellResult: UITableViewCell?
        switch _itemList.value[indexPath.row] {
            case "hz":
                guard let text = _dataList.value[0].data?.text else { return UITableViewCell()}
                if let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as? TextCell {
                cell.configure(data: text)
                cellResult = cell
                }
            case "selector":
                guard let selectedId = _dataList.value[2].data?.selectedId else { return UITableViewCell() }
                let variants: [Variant] = _dataList.value[2].data?.variants ?? []
                var variantsFin: [String] = []
                for item in variants {
                    variantsFin.append(item.text!)
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "selectorCell", for: indexPath) as? SelectorCell {
                cell.configure(selectedId: selectedId, variants: variantsFin)
                cellResult = cell
                }
            case "picture":
                let picText = _dataList.value[1].data?.text ?? ""
                let picUrl = _dataList.value[1].data?.url.value ?? ""
                if let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageCell {
                cell.configure(url: picUrl, text: picText)
                cellResult = cell
                }
            default:
                print("Something wrong happened...")
                break
        }
        if indexPath.section > _itemList.value.count - 1 {
            return UITableViewCell()
        }
        
        return cellResult!

    }
}
