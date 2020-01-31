//
//  ContentView.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/20/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

let gray:UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
let red:UIColor = UIColor(red: 0.7, green: 0.05, blue: 0.05, alpha: 0.9)
let green:UIColor = UIColor(red: 1/256, green: 210/256, blue: 119/256, alpha: 1.0)
let translucent_green:UIColor = UIColor(red: 1/256, green: 210/256, blue: 119/256, alpha: 0.8)
let blue:UIColor = UIColor(red: 8/256, green: 28/256, blue: 36/256, alpha: 1.0)

class HomeViewController: UIViewController {
    
    let moveUpHeight:CGFloat = 100
    let logoHeight:CGFloat = 150
    let logoWidth:CGFloat = 170
    
    let backgroundImage:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "theater.jpg")
        image.tintColor = .black
        return image
    }()
    
    let blur:UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffect = UIVisualEffectView(effect: blur)
        blurEffect.translatesAutoresizingMaskIntoConstraints = false
        return blurEffect
    } ()
    
    let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = gray
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.placeholder = "Search Movies, Actors, and TV Shows"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let homeLogo:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "tmdb_green.jpg")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let browseButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = translucent_green
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
    
    func createElementsAndConstraints() {
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
    
    func backgroundImageConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func blurConstraints() {
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: view.topAnchor),
            blur.leftAnchor.constraint(equalTo: view.leftAnchor),
            blur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blur.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func searchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            searchBar.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])
    }
    
    func homeLogoConstraints() {
        NSLayoutConstraint.activate([
            homeLogo.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -100),
            homeLogo.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            homeLogo.heightAnchor.constraint(equalToConstant: logoHeight),
            homeLogo.widthAnchor.constraint(equalToConstant: logoWidth)
        ])
    }
    
    func browseButtonConstraints() {
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
    
    func fadeInBlur() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.blur.alpha = 1.0
        }, completion: nil)
    }

    func fadeOutBlur() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.blur.alpha = 0.0
        }, completion: nil)
    }
    
    func moveElementsUp() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.searchBar.frame.origin.y -= self.moveUpHeight
            self.homeLogo.frame.origin.y -= (self.moveUpHeight-40)
            self.browseButton.frame.origin.y -= (self.moveUpHeight+15)
        }, completion: nil)
    }
    
    func moveElementsDown() {
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
