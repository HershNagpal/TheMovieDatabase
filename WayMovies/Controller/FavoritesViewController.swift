//
//  FavoritesViewController.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/29/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    
    // The collection that displays the user's favorited movies, shows, and actors
    private var favoritesCollection:FavoritesCollection = {
        let collection = FavoritesCollection()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // The background of the view
    let backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        createElementsAndConstraints()
        setUpDelegates()
    }
    
    /**
     Sets delegates
     */
    func setUpDelegates() {
        favoritesCollection.navDelegate = self
    }
    
    /**
     Adds all elements to the subview and calls constraining helper methods.
     */
    func createElementsAndConstraints() {
        view.addSubview(backgroundView)
        view.addSubview(favoritesCollection)
        backgroundViewConstraints()
        favoritesCollectionConstraints()
    }
    
    /**
      Sets up constraints for the background view
    */
    func backgroundViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    /**
      Sets up constraints for the FavoritesCollection
    */
    func favoritesCollectionConstraints() {
        NSLayoutConstraint.activate([
            favoritesCollection.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            favoritesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoritesCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            favoritesCollection.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

}


extension FavoritesViewController:NavigationDelegate {
    func cellTapped(_ item: TVItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
}
