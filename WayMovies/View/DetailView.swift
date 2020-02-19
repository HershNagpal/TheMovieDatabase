//
//  DetailView.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/28/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//


import Foundation
import UIKit

class DetailView: UIView {
    // The height of the main poster image
    private let imageHeight:CGFloat = 630
    
    // The height of labels in the page
    private let labelHeight:CGFloat = 40
    
    // The width of labels in the page
    private let labelWidth:CGFloat = 170
    
    // The view showing the poster image
    let imageView:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .gray
        return image
    }()

    // The label showing the description of the item in the detail page
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        // Filler text
        label.text = "ads i;fl vdksjf; lkad s kfl ;advs kjlfj l;sf; ;slda kjf;ls adkj f;lads kjf;alsd kf ;lka ds; lkf ja sd klfj ads;lkf jas ;lkfj ds; lkjfs; dkljf a;kljf ;als dkj f;l ksd jfl ;akds f;k las jfl;ka s djf;l akds jf;lk adsf"
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    // The label showing the title of the movie or show or the name of the actor
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // The label showing whether the item is a show, movie, or actor
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Colors.blue
        label.font = label.font.withSize(40)
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.drawText(in: CGRect().inset(by: insets))
        label.backgroundColor = Colors.translucentGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingView:RatingView = {
        let ratingView = RatingView()
        ratingView.clipsToBounds = true
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    /**
     Calls the API retrieval of the poster image of a TVItem in the Request class and returns the image location when escaping
     */
    func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
        Request.getImage(searchTerms: searchTerms) { result in
            completion(result)
        }
    }
    
    /**
     Sets the details of the page based on the given item
     `Parameter item: The item which contains the information needed to show on the page`
     */
    func setDetails(item:TVItem) {
        if(item.title != nil) {
            //Case Movie
            typeLabel.text = "MOVIE"
            titleLabel.text = item.title
            ratingView.widthAnchor.constraint(equalToConstant: ratingView.calculateWidth(item: item)).isActive = true
            imageView.image = UIImage(named: "movie_default.jpg")
        } else if(item.known_for_department != nil) {
            //Case Actor
            typeLabel.text = "PERSON"
            titleLabel.text = item.name
            imageView.image = UIImage(named: "profile_default.jpg")
        } else {
            //Case Show
            typeLabel.text = "SHOW"
            titleLabel.text = item.name
            ratingView.widthAnchor.constraint(equalToConstant: ratingView.calculateWidth(item: item)).isActive = true
            imageView.image = UIImage(named: "movie_default.jpg")
        }
        
        if item.poster_path != "" && item.poster_path != nil {
            getImage(searchTerms: item.poster_path!) { (result) in
                switch result {
                    case .failure(let error):
                       print(error)
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                    }
                }
            }
        } else if item.profile_path != "" && item.profile_path != nil {
            getImage(searchTerms: item.profile_path!) { (result) in
                switch result {
                    case .failure(let error):
                       print(error)
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createElementsAndConstraints()
    }
    
    init(item:TVItem) {
        super.init(frame: CGRect())
        createElementsAndConstraints()
        setDetails(item: item)
    }
    
    func createElementsAndConstraints() {
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(titleLabel)
        addSubview(typeLabel)
//        addSubview(ratingLabel)
        addSubview(ratingView)
        imageViewConstraints()
        descriptionLabelConstraints()
        nameLabelConstraints()
        typeLabelConstraints()
//        ratingLabelConstraints()
        ratingViewConstraints()
    }
    
    func imageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageHeight)
        ])
    }
    
    func nameLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -labelHeight-10),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    func descriptionLabelConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5)
        ])
    }

    
    func typeLabelConstraints() {
        NSLayoutConstraint.activate([
            typeLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            typeLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            typeLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            typeLabel.widthAnchor.constraint(equalToConstant: labelWidth)
        ])
    }
    
    func ratingViewConstraints() {
        NSLayoutConstraint.activate([
            ratingView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            ratingView.leftAnchor.constraint(equalTo: typeLabel.rightAnchor, constant: 20),
            ratingView.heightAnchor.constraint(equalToConstant: ratingView.getStarHeight())
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
