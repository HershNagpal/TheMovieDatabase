//
//  MiniRatingView.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 2/5/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

class MiniRatingView: RatingView {
    // Width of each star
    let miniStarWidth:CGFloat = 18
    
    // Height of each star
    let miniStarHeight:CGFloat = 18

    /**
     Returns the star height
     */
    override func getStarHeight() -> CGFloat {
        return miniStarHeight
    }
    
    
    /**
     Calculates the width of the star rating based on the given TVItem
     `Parameter item: The TVItem which holds the rating`
     */
    override func calculateWidth(item:TVItem) -> CGFloat {
        if let rating = item.vote_average {
            return CGFloat( (rating/10)*Double(Int(miniStarWidth)*starList.count) )
        }
        return .zero
    }
    
    override func createRatingStars() {
        
        for i in 0...4 {
            let star:UIImageView = {
                let image = UIImageView()
                image.image = UIImage(named: "star.png")
                image.clipsToBounds = true
                image.image = image.image?.withTintColor(yellow)
                image.translatesAutoresizingMaskIntoConstraints = false
                return image
            }()
//            self.addSubview(star)
            starList.append(star)
            self.addSubview(starList[i])
            if i == 0 {
                NSLayoutConstraint.activate([
                    star.leftAnchor.constraint(equalTo: self.leftAnchor),
                    star.heightAnchor.constraint(equalToConstant: miniStarHeight),
                    star.widthAnchor.constraint(equalToConstant: miniStarWidth)
                ])
            } else {
                NSLayoutConstraint.activate([
                    star.leftAnchor.constraint(equalTo: starList[i-1].rightAnchor),
                    star.heightAnchor.constraint(equalToConstant: miniStarHeight),
                    star.widthAnchor.constraint(equalToConstant: miniStarWidth)
                ])
            }
            self.addSubview(star)
        }
    }
}
