//
//  TVCell.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/20/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit


class TVCell: UICollectionViewCell {
    
    private let labelHeight:CGFloat = 50
    private let labelWidth:CGFloat = 175
    private let favoriteButtonHeight:CGFloat = 25
    private let favoriteButtonWidth:CGFloat = 25
    
    let imageView: UIImageView = {
        let label = UIImageView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        label.backgroundColor = UIColor.darkGray
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonClicked), for: .touchDown)
        button.setImage(UIImage(named: "love.png"), for: .selected)
        button.setImage(UIImage(named: "unlove.png"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(ratingLabel)
        addSubview(typeLabel)
        addSubview(favoriteButton)
        imageViewConstraints()
        titleLabelConstraints()
        ratingLabelConstraints()
        typeLabelConstraints()
        favoriteButtonConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    func titleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            titleLabel.widthAnchor.constraint(equalToConstant: labelWidth)
            
        ])
    }
    
    func typeLabelConstraints() {
        NSLayoutConstraint.activate([
            typeLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            typeLabel.heightAnchor.constraint(equalToConstant: labelHeight)
            
        ])
    }
    
    func favoriteButtonConstraints() {
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant:favoriteButtonHeight/2),
            favoriteButton.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -favoriteButtonHeight/2),
            favoriteButton.heightAnchor.constraint(equalToConstant: favoriteButtonHeight),
            favoriteButton.widthAnchor.constraint(equalToConstant: favoriteButtonWidth)
        ])
    }
    
    func ratingLabelConstraints() {
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: labelHeight/2),
            ratingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            ratingLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    @objc func favoriteButtonClicked() {
//        FavoritesCollection.addToFavorites(item: )
        print("Yee yee")
        favoriteButton.isSelected = !favoriteButton.isSelected
    }
}
