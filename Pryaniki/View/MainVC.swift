//
//  MainVC.swift
//  Pryaniki
//
//  Created by Wermod on 14.03.2021.
//

import UIKit
import RxCocoa
import RxSwift
import ObjectMapper

class MainVC: UIViewController {
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    private var tableView = UITableView()
    private var infoLabel: UILabel!
    
    let activityIndicator: UIActivityIndicatorView = { () -> UIActivityIndicatorView in
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.backgroundColor = .black
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barHeight: CGFloat = getStatusBarHeight()
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        infoLabel = UILabel(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        //        self.infoLabel.isHidden = true
        view.addSubview(infoLabel)
        self.registerObserver()
        self.setupTableView()
        self.view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.isHidden = true
    }
    
    func registerObserver() {
        
        viewModel.itemList.drive(onNext: { [unowned self] (itemList) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        viewModel.dataList.drive(onNext: { [unowned self] (dataList) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        viewModel.error.drive(onNext: { [unowned self] (error) in
            self.infoLabel.isHidden = !self.viewModel.hasError
            self.infoLabel.text = error
        }).disposed(by: disposeBag)
        viewModel.isFetching.drive(activityIndicator.rx.isHidden).disposed(by: disposeBag)
    }
    
    
    func setupTableView() {
        let barHeight: CGFloat = getStatusBarHeight()
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(TextCell.self, forCellReuseIdentifier: "textCell")
        tableView.register(SelectorCell.self, forCellReuseIdentifier: "selectorCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "imageCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
}


extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.prepareCellForDisplay(tableView: tableView, indexPath: indexPath)
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let elements = ["hz", "selector", "picture", "hz"]
        cell?.isSelected = false
        print("Выбрана ячейка таблицы с индексом: \(indexPath.row), в ней находится элемент \(elements[indexPath.row] ) ")
    }
}
