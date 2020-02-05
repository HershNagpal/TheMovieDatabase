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
    
    let ratingView:RatingView = {
        let ratingView = MiniRatingView()
        ratingView.clipsToBounds = true
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
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
    /**
     Adds all elements to the subview and calls constraining helper methods.
     */
    private func createElementsAndConstraints() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(typeLabel)
        addSubview(favoriteButton)
        addSubview(ratingView)
        imageViewConstraints()
        titleLabelConstraints()
        typeLabelConstraints()
        favoriteButtonConstraints()
        ratingViewConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createElementsAndConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
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
            titleLabel.bottomAnchor.constraint(equalTo: ratingView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
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
    
    func ratingViewConstraints() {
            NSLayoutConstraint.activate([
                ratingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                ratingView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3),
    //            ratingView.widthAnchor.constraint(equalToConstant: 500),
                ratingView.heightAnchor.constraint(equalToConstant: ratingView.getStarHeight())
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
