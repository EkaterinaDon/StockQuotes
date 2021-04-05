//
//  StocksTableViewCell.swift
//  StockQuotes
//
//  Created by Ekaterina on 23.02.21.
//

import UIKit


class StocksTableViewCell: UITableViewCell {
    
    var quoteData = Quote()
    
    // MARK: - Subviews
    
    private(set) lazy var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        
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
        super.prepareForReuse()
        [self.titleLabel, self.subtitleLabel, self.priceLabel, self.changesLabel].forEach { $0.text = nil }
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
            self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -250.0)
            ])
    }
    
    private func addFavoriteButton() {
        self.contentView.addSubview(self.favoriteButton)
        NSLayoutConstraint.activate([
            self.favoriteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4.0),
            self.favoriteButton.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor),
            self.favoriteButton.heightAnchor.constraint(equalToConstant: 20.0),
            self.favoriteButton.widthAnchor.constraint(equalToConstant: 20.0)
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
    
    func configure(with cellModelFromCoreData: Quote) {
        self.titleLabel.text = cellModelFromCoreData.symbol
        self.subtitleLabel.text = cellModelFromCoreData.longName
        guard let symbol = cellModelFromCoreData.symbol else { return }
        self.priceLabel.text = cellModelFromCoreData.currency! + "\(price[symbol] ?? 0.0)"
        self.changesLabel.text = "\(priceChange[symbol] ?? 0.0)"
        if (price[symbol] ?? 0.0) > 0 {
            self.changesLabel.textColor = .green
        } else if (price[symbol] ?? 0.0) < 0 {
            self.changesLabel.textColor = .red
        }
        let image = savedImages[symbol]
        self.companyImageView.image = image
        
        self.updateButton(quote: cellModelFromCoreData)
    }
    
    func updateButton(quote: Quote) {
        if favoriteQuotes.contains(where: {$0.symbol == quote.symbol }) {
            favoriteButton.setImage(UIImage(named: "filledHeart"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
}
