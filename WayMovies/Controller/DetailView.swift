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
    private let imageHeight:CGFloat = 500
    private let labelHeight:CGFloat = 40
    
    let imageView:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .gray
        return image
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "ads i;fl vdksjf; lkad s kfl ;advs kjlfj l;sf; ;slda kjf;ls adkj f;lads kjf;alsd kf ;lka ds; lkf ja sd klfj ads;lkf jas ;lkfj ds; lkjfs; dkljf a;kljf ;als dkj f;l ksd jfl ;akds f;k las jfl;ka s djf;l akds jf;lk adsf"
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "My Sweet Boi"
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "TVShow"
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "5/5"
        return label
    }()
    
    func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
        Request.getImage(searchTerms: searchTerms) { result in
            completion(result)
        }
    }
    
    func setDetails(item:TVItem) {
        if(item.title != nil) {
            //Case Movie
            typeLabel.text = "Movie"
            titleLabel.text = item.title
            ratingLabel.text = "Average User Rating: \(String(item.vote_average!))"
            imageView.image = UIImage(named: "movie_default.jpg")
        } else if(item.known_for_department != nil) {
            //Case Actor
            typeLabel.text = "Person"
            titleLabel.text = item.name
            imageView.image = UIImage(named: "profile_default.jpg")
        } else {
            //Case Show
            typeLabel.text = "Show"
            titleLabel.text = item.name
            ratingLabel.text = "Average User Rating: \(String(item.vote_average!))"
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
        imageViewConstraints()
        descriptionLabelConstraints()
        nameLabelConstraints()
        typeLabelConstraints()
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
            descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    
    func typeLabelConstraints() {
        NSLayoutConstraint.activate([
            typeLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            typeLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            typeLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    func ratingLabelConstraints() {
        NSLayoutConstraint.activate([
            typeLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            typeLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            typeLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
