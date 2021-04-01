//
//  CustomCellView.swift
//  Pryaniki
//
//  Created by Wermod on 12.03.2021.
//

import UIKit
import Kingfisher
import DropDown

class TextCell: UITableViewCell {
    
    lazy var textlabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data text: String) {
        textlabel.text = text
    }
    
    func setupUI() {
        textlabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the UI components
        contentView.addSubview(textlabel)
        NSLayoutConstraint.activate([
            textlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textlabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textlabel.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
}

class ImageCell: UITableViewCell {
    
    var picLabel = UILabel()
    var picView: UIImageView = {
        let picView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        picView.contentMode = .scaleAspectFit
        
        return picView
        }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
//        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(url: String, text: String) {
        picLabel.text = text
        picView.downloadImage(with :url){image in
            guard let image = image else {return}
            self.picView.image = image
        }
        
    }
    
    func setupUI() {
                        
        picLabel.translatesAutoresizingMaskIntoConstraints = false
        picView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the UI components
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        stackView.addArrangedSubview(picLabel)
        stackView.addArrangedSubview(picView)
        NSLayoutConstraint.activate([
            picView.heightAnchor.constraint(equalToConstant: picView.frame.height),
            picView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            picView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            picLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            picLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            picLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            picLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
    }
}

class SelectorCell: UITableViewCell {
        
    var variants: [String] = []
    var selectedId: Int?
    let dropDown = DropDown()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(selectedId: Int, variants: [String]) {
        self.selectedId = selectedId
        self.variants = variants
        setupUI()
    }
    
    func setupUI() {
        let cellDropButton: UIButton = {
            let but = UIButton(frame: CGRect(x: 0, y: 0, width: 500 , height: 40))
                but.backgroundColor = UIColor.gray
                but.setTitle(String(selectedId!), for: .normal)
                but.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                but.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                but.translatesAutoresizingMaskIntoConstraints = false
                return but
            }()
        contentView.addSubview(cellDropButton)
        
        NSLayoutConstraint.activate([
            cellDropButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellDropButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellDropButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellDropButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
       
        dropDown.selectRow(at: self.selectedId)
        dropDown.dataSource = self.variants
        dropDown.anchorView = cellDropButton
        dropDown.bottomOffset = CGPoint(x: 0, y: cellDropButton.bounds.height)
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Выбрана ячейка с элементом selector. В ней выбран вариант меню: ( \(item) ) с индексом: \(index+1)")
            cellDropButton.setTitle(String(index+1), for: .normal)
        }
        
        dropDown.hide()
       }
    
    @objc func buttonAction(sender: UIButton!) {
        dropDown.show()
        }
    
    }
