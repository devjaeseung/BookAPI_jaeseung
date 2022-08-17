//
//  SearchListTableViewCell.swift
//  BookAPI_jaeseung
//
//  Created by jaeseung lim on 2022/08/12.
//

import UIKit
import SnapKit

class SearchListTableViewCell: UITableViewCell {

    static let identifier = "SearchListTableViewCell"
    
    let bookImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "book")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
        
    }()
    
    let titleLabel: UILabel = {
       
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.text = "책 제목"
        return label
        
    }()
    
    let authorLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.text = "지은이"
        return label
        
    }()
    
    let dateLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.text = "2022-08-12"
        return label
        
    }()
    
    private let stackView: UIStackView = {
       
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
    
        
        return stackView
        
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContentView() {
        
        [bookImageView,titleLabel,authorLabel,dateLabel,stackView].forEach {
            contentView.addSubview($0)
        }
        
        [titleLabel, authorLabel, dateLabel].map {
            self.stackView.addArrangedSubview($0)
        }
        
    }
    
    private func autoLayout() {
        
        bookImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(80)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(bookImageView.snp.trailing).offset(10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
    }

}
