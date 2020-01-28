//
//  DetailViewController.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/22/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {

    private let item: TVItem
    
    let detailView:DetailView = {
        let detailView = DetailView()
        detailView.translatesAutoresizingMaskIntoConstraints = false
        return detailView
    }()
    
    /*
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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sob Baget"
        return label
    }()
 
    */
    
    init(item: TVItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        self.item = TVItem(id:00)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createElementsAndConstraints()
    }
    
    func createElementsAndConstraints() {
        view.addSubview(detailView)
        detailViewConstraints()
    }
    
    func detailViewConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    /*
    func createElementsAndConstraints() {
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        
        imageViewConstraints()
        nameLabelConstraints()
        descriptionLabelConstraints()
    }
    
    func imageViewConstraints() {
        let height:CGFloat = 300
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func nameLabelConstraints() {
        let height:CGFloat = 30
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -height-10),
            nameLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    
    func descriptionLabelConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])
    }
 */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
