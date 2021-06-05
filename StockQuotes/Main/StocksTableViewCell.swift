//
//  StocksTableViewCell.swift
//  StockQuotes
//
//  Created by Ekaterina on 23.02.21.
//

import UIKit


class StocksTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    
    private(set) lazy var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private(set) lazy var tickerleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.backgroundColor = .clear
        return button
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
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var changesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    
    // MARK: - UI
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [self.titleLabel, self.subtitleLabel, self.priceLabel, self.changesLabel, self.tickerleLabel].forEach { $0.text = nil }
        self.companyImageView.image = nil
    }
    
    private func configureUI() {
        self.addImage()
        self.addTitleLabel()
        self.addFavoriteButton()
        self.addSubtitleLabel()
        self.addPriceLabel()
        self.addChangesLabel()
    }
    
    private func addImage() {
        self.contentView.addSubview(self.companyImageView)
        NSLayoutConstraint.activate([
            self.companyImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.companyImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.companyImageView.heightAnchor.constraint(equalToConstant: 50.0),
            self.companyImageView.widthAnchor.constraint(equalToConstant: 50.0)
        ])
        
        self.contentView.addSubview(self.tickerleLabel)
        NSLayoutConstraint.activate([
            self.tickerleLabel.leadingAnchor.constraint(equalTo: self.companyImageView.leadingAnchor),
            self.tickerleLabel.trailingAnchor.constraint(equalTo: self.companyImageView.trailingAnchor),
            self.tickerleLabel.centerYAnchor.constraint(equalTo: self.companyImageView.centerYAnchor),
            self.tickerleLabel.heightAnchor.constraint(equalToConstant: 25.0)
        ])
    }
    
    private func addTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4.0),
            self.titleLabel.leftAnchor.constraint(equalTo: self.companyImageView.rightAnchor, constant: 12.0),
            self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -250.0)
            ])
    }
    
    private func addFavoriteButton() {
        self.contentView.addSubview(self.favoriteButton)
        NSLayoutConstraint.activate([
            self.favoriteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4.0),
            self.favoriteButton.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 2.0),
            self.favoriteButton.heightAnchor.constraint(equalToConstant: 20.0),
            self.favoriteButton.widthAnchor.constraint(equalToConstant: 20.0)
            ])
    }
    
    private func addSubtitleLabel() {
        self.contentView.addSubview(self.subtitleLabel)
        NSLayoutConstraint.activate([
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 6.0),
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
    
    func configure(with cellModelFromCoreData: Quote) {
        updateButton(quote: cellModelFromCoreData)
        self.titleLabel.text = cellModelFromCoreData.symbol
        self.subtitleLabel.text = cellModelFromCoreData.longName
        
        guard let symbol = cellModelFromCoreData.symbol else { return }
        self.priceLabel.text = cellModelFromCoreData.currency! + " \(price[symbol] ?? 0.0)"
        
        self.changesLabel.text = (String(format: "%.2f", priceChange[symbol] ?? 0) + "%")
        if (priceChange[symbol] ?? 0.0) > 0.0 {
            self.changesLabel.textColor = .green
        } else if (priceChange[symbol] ?? 0.0) < 0.0 {
            self.changesLabel.textColor = .red
        } else {
            self.changesLabel.textColor = .lightGray
        }
        
        if let image = cellModelFromCoreData.logoImage {
            self.tickerleLabel.isHidden = true
            self.companyImageView.image = UIImage(data: image)
        } else {
            self.tickerleLabel.text = cellModelFromCoreData.symbol
            self.tickerleLabel.isHidden = false
            self.companyImageView.backgroundColor = .clear
        }
        
    }
    
    func configure(with cellModel: FavoriteQuote) {
        self.titleLabel.text = cellModel.symbol
        self.subtitleLabel.text = cellModel.longName
        guard let image = cellModel.logoImage else { return }
        self.companyImageView.image = UIImage(data: image)
        
    }
    
    func updateButton(quote: Quote) {
        if favoriteQuotes.contains(where: {$0.symbol == quote.symbol }) {
            favoriteButton.setImage(UIImage(named: "choosedStar"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "star"), for: .normal)
        }
    }
}
