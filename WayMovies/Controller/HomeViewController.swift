//
//  ContentView.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/20/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // The distance that elements on the page move up when the search bar is selected
    private let moveUpHeight:CGFloat = 100
    
    // The height of the app logo
    private let logoHeight:CGFloat = 150
    
    // The width of the app logo
    private let logoWidth:CGFloat = 170
    
    // The background image on the home screen
    private let backgroundImage:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "theater.jpg")
        image.tintColor = .black
        return image
    }()
    
    // The blur effect applied when the search bar is selected
    private let blur:UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffect = UIVisualEffectView(effect: blur)
        blurEffect.translatesAutoresizingMaskIntoConstraints = false
        return blurEffect
    } ()
    
    // The search bar in the center of the home screen
    private let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = Colors.gray
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.placeholder = "Search Movies, Actors, and TV Shows"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // The logo on the home screen
    private let homeLogo:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "tmdb_green.jpg")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // The button that navigates to the browse screen
    private let browseButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.translucentGreen
        button.layer.cornerRadius = 10
        button.setTitle("Browse", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(browseButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        createElementsAndConstraints()
    }
    
    /**
     Adds all elements to the subview and calls constraining helper methods.
     */
    private func createElementsAndConstraints() {
        view.addSubview(backgroundImage)
        view.addSubview(blur)
        view.addSubview(searchBar)
        view.addSubview(homeLogo)
        view.addSubview(browseButton)
        backgroundImageConstraints()
        blurConstraints()
        searchBarConstraints()
        homeLogoConstraints()
        browseButtonConstraints()
        blur.isHidden = true
    }
    
    /**
      Sets up constraints for the FavoritesCollection
    */
    private func backgroundImageConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    /**
      Sets up constraints for the blur effect
    */
    private func blurConstraints() {
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: view.topAnchor),
            blur.leftAnchor.constraint(equalTo: view.leftAnchor),
            blur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blur.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    /**
      Sets up constraints for the search bar
    */
    private func searchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            searchBar.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])
    }
    
    /**
      Sets up constraints for the logo view
    */
    private func homeLogoConstraints() {
        NSLayoutConstraint.activate([
            homeLogo.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -100),
            homeLogo.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            homeLogo.heightAnchor.constraint(equalToConstant: logoHeight),
            homeLogo.widthAnchor.constraint(equalToConstant: logoWidth)
        ])
    }
    
    /**
      Sets up constraints for the browse butotn
    */
    private func browseButtonConstraints() {
        NSLayoutConstraint.activate([
            browseButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            browseButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            browseButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func browseButtonClicked() {
        navigationController?.pushViewController(BrowseViewController(), animated: true)
    }
    
    /**
     Fades in the blur effect over 0.5 seconds
     */
    private func fadeInBlur() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.blur.alpha = 1.0
        }, completion: nil)
    }

    /**
     Fades out the blur effect over 0.5 seconds
     */
    private func fadeOutBlur() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.blur.alpha = 0.0
        }, completion: nil)
    }
    
    /**
     Animates the elements on the screen moving upwards
     */
    private func moveElementsUp() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.searchBar.frame.origin.y -= self.moveUpHeight
            self.homeLogo.frame.origin.y -= (self.moveUpHeight-40)
            self.browseButton.frame.origin.y -= (self.moveUpHeight+15)
        }, completion: nil)
    }
    
    /**
     Animates the elements on the screen moving downwards
     */
    private func moveElementsDown() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.searchBar.frame.origin.y += self.moveUpHeight
            self.homeLogo.frame.origin.y += (self.moveUpHeight-40)
            self.browseButton.frame.origin.y += (self.moveUpHeight+15)
        }, completion: nil)
    }
    
}

extension HomeViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Request.searchMulti(searchTerms: searchBar.text!) { [weak self] result in
        switch result {
             case .failure(let error):
                 print(error)
             case .success(let items):
                 DispatchQueue.main.async {
                    let vc = SearchViewController()
                    vc.applySearch(searchItems: items)
                    self?.navigationController?.pushViewController(vc, animated: true)
                 }
             }
         }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.blur.alpha = 0.0
        blur.isHidden = false
        moveElementsUp()
        fadeInBlur()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        fadeOutBlur()
        moveElementsDown()
        blur.isHidden = true
    }
}
