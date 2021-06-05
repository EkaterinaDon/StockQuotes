//
//  RealTimeDataViewModel.swift
//  StockQuotes
//
//  Created by Ekaterina on 6.05.21.
//

import UIKit

class RealTimeDataViewModel: UIView {

    // MARK: - Subviews
    
    private(set) lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private(set) lazy var tickerLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 20.0)
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    private(set) lazy var priceLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 20.0)
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    private(set) lazy var timeLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .lightGray
        textLabel.font = UIFont.systemFont(ofSize: 14.0)
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.addSubview(self.logoImageView)
        self.addSubview(self.tickerLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.timeLabel)
        
        setupConstraints()
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.logoImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 250.0),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 250.0),
            
            self.tickerLabel.bottomAnchor.constraint(equalTo: self.logoImageView.topAnchor, constant: -5.0),
            self.tickerLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.tickerLabel.widthAnchor.constraint(equalToConstant: 250.0),
            self.tickerLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            self.priceLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 5.0),
            self.priceLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.priceLabel.widthAnchor.constraint(equalToConstant: 250.0),
            self.priceLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            self.timeLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10.0),
            self.timeLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.timeLabel.widthAnchor.constraint(equalToConstant: 250.0),
            self.timeLabel.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }
}
