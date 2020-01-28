//
//  MovieCell.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/20/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 30
        image.backgroundColor = UIColor.gray
        return image
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.textColor = .black
        title.text = "Yee"
        return title
    }()
    
    var ratingLabel: UILabel = {
        let rating = UILabel()
        rating.translatesAutoresizingMaskIntoConstraints = false
        rating.textAlignment = .center
        rating.textColor = .black
        rating.text = "5/5"
        return rating
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
