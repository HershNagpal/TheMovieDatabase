//
//  TVItem.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/21/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import UIKit

struct TVItem: Decodable {
    var id: Int
    var vote_average: Double?
    var title: String?
    var name: String?
    var known_for_department: String?
    var poster_path: String?
    var backdrop_path: String?
    var profile_path: String?
    var media_type: String?
}

struct Response: Decodable {
    var total_results: Int
    var total_pages: Int
    var results: [TVItem]
}
