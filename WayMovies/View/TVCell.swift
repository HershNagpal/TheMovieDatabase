//
//  TVCell.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/20/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

/**
 Each collection that displays any information about TVItems uses the TVCell to show information to the user.
 */
class TVCell: UICollectionViewCell {
    
    // The TVItem associated with this TVCell
    private var item:TVItem = TVItem(id: 0)
    
    // The height of all labels on the TVCell
    private let labelHeight:CGFloat = 50
    
    // The width of all labels on the TVCell
    private let labelWidth:CGFloat = 175
    
    // The height of the favorite button element
    private let favoriteButtonHeight:CGFloat = 40
    
    // The width of the favorite button element
    private let favoriteButtonWidth:CGFloat = 40
    
    /**
     Sets this TVCell's item attribute to the given item.
     
    `Parameter item: The item to set this TVCell's item attribute to.`
     */
    func setItem(item: TVItem) {
        self.item = item
        if(FavoritesCollection.isInFavorites(item: item)) {
            favoriteButton.isSelected = true
        }
    }
    
    // Shows the image of the movie, show, or person associated with the TVItem this TVCell represents.
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = UIColor.darkGray
        image.layer.cornerRadius = 5
        return image
    }()
    
    
    // Shows the image of the movie, show, or person associated with the TVItem this TVCell represents.
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    // Shows whether this TVCell represents a Show, Movie, or Person.
    var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    // Shows the rating of the movie, show associated with the TVItem this TVCell represents. Empty if representing a Person.
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    // Shows a filled in heart if this TVCell represents a favorited TVItem; otherwise is empty.
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = .magenta
        button.addTarget(self, action: #selector(favoriteButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "love.png")?.withTintColor(red), for: .selected)
        button.setImage(UIImage(named: "love.png")?.withTintColor(gray), for: .normal)
        
        return button
    }()
    
    // Adds all elementts to the subview and calls constraining helper methods.
    private func createElementsAndConstraints() {
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
    
    override init(frame: CGRect) {
//        self.item = item
        super.init(frame: frame)
        createElementsAndConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets up constraints for the imageView of this TVCell.
     */
    private func imageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    /**
     Sets up constraints for the titleLabel of this TVCell.
     */
    private func titleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            titleLabel.widthAnchor.constraint(equalToConstant: labelWidth)
            
        ])
    }
    
    /**
     Sets up constraints for the typeLabel of this TVCell.
     */
    private func typeLabelConstraints() {
        NSLayoutConstraint.activate([
            typeLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            typeLabel.heightAnchor.constraint(equalToConstant: labelHeight)
            
        ])
    }
    
    /**
     Sets up constraints for the favoriteButton of this TVCell.
     */
    private func favoriteButtonConstraints() {
        NSLayoutConstraint.activate([
            favoriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(favoriteButtonHeight/10)),
            favoriteButton.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -(favoriteButtonHeight/10)),
            favoriteButton.heightAnchor.constraint(equalToConstant: favoriteButtonHeight),
            favoriteButton.widthAnchor.constraint(equalToConstant: favoriteButtonWidth)
        ])
    }
    
    /**
     Sets up constraints for the ratingLabel of this TVCell.
     */
    private func ratingLabelConstraints() {
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: labelHeight/2),
            ratingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            ratingLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    /**
     Adds or removes the this TVCell's item from the global favorites list when the favorite button is clicked.
     */
    @objc private func favoriteButtonClicked() {
        if(!FavoritesCollection.isInFavorites(item: item)) {
            FavoritesCollection.addToFavorites(item: item)
        } else {
            FavoritesCollection.removeFromFavorites(item: item)
        }
        favoriteButton.isSelected = !favoriteButton.isSelected
    }
}
