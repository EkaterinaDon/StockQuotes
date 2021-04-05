//
//  FavoriteQuotesTableViewCell.swift
//  StockQuotes
//
//  Created by Ekaterina on 1.03.21.
//

import UIKit

class FavoriteQuotesTableViewCell: UITableViewCell {

    // MARK: - Subviews
    
    private(set) lazy var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    private(set) lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var changesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
        
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    
    // MARK: - UI
    
    override func prepareForReuse() {
        [self.titleLabel, self.subtitleLabel, self.priceLabel, self.changesLabel].forEach { $0.text = nil }
    }
    
    private func configureUI() {
        self.addImage()
        self.addTitleLabel()
        self.addSubtitleLabel()
        self.addPriceLabel()
        self.addChangesLabel()
    }
    
    private func addImage() {
        self.contentView.addSubview(self.companyImageView)
        NSLayoutConstraint.activate([
            self.companyImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.companyImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.companyImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.companyImageView.heightAnchor.constraint(equalToConstant: 50.0),
            self.companyImageView.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    private func addTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4.0),
            self.titleLabel.leftAnchor.constraint(equalTo: self.companyImageView.rightAnchor, constant: 12.0),
            self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -140.0)
            ])
    }
    
    private func addSubtitleLabel() {
        self.contentView.addSubview(self.subtitleLabel)
        NSLayoutConstraint.activate([
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.subtitleLabel.leftAnchor.constraint(equalTo: self.companyImageView.rightAnchor, constant: 12.0),
            self.subtitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -140.0)
            ])
    }
    
    private func addPriceLabel() {
        self.contentView.addSubview(self.priceLabel)
        NSLayoutConstraint.activate([
            self.priceLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4.0),
            self.priceLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12.0)
            ])
    }
    
    private func addChangesLabel() {
        self.contentView.addSubview(self.changesLabel)
        NSLayoutConstraint.activate([
            self.changesLabel.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 4.0),
            self.changesLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12.0)
            ])
    }
    
    // MARK: - Methods
    
    func configure(with cellModel: FavoriteQuote) {
        self.titleLabel.text = cellModel.symbol
        self.subtitleLabel.text = cellModel.longName
        //self.priceLabel.text = cellModel.currency! + "\(String(describing: cellModel.regularMarketDayHigh))"
        //self.changesLabel.text = "\(String(describing: cellModel.regularMarketDayLow))"
    }
    
}
