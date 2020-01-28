//
//  MovieRequest.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/22/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation

struct MovieRequest {

    let API_KEY = "71ab1b19293efe581c569c1c79d0f004"
    
    func getTopRated(completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let topRatedURL = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(API_KEY)&language=en-US&page=1")!
        
        let task = URLSession.shared.dataTask(with: topRatedURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let topRatedResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = topRatedResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    func getMovieImage(completion: @escaping(Result<[TVItem], Error>) -> Void) {
        
    }
    
}
