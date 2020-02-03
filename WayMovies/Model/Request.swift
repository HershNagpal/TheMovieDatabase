//
//  Request.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/22/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation

struct Request {
    
    // API Key
    static let API_KEY = "71ab1b19293efe581c569c1c79d0f004"
    
    /**
     Retrieves the current top rated movies from TMDB and returns it as a list of TVitems
     */
    static func getTopRatedMovies(completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let resourceURL = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(API_KEY)&language=en-US&page=1")!
        
        let task = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tvResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = tvResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    /**
     Retrieves the current top rated shows from TMDB and returns it as a list of TVitems
     */
    static func getTopRatedShows(completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let resourceURL = URL(string: "https://api.themoviedb.org/3/tv/top_rated?api_key=\(API_KEY)&language=en-US&page=1")!
        
        let task = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tvResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = tvResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    /**
     Retrieves the current popular movies from TMDB and returns it as a list of TVitems
     */
    static func getPopularMovies(completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let resourceURL = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(API_KEY)&language=en-US&page=1")!
        
        let task = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tvResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = tvResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    /**
     Retrieves the current popular people from TMDB and returns it as a list of TVitems
     */
    static func getPopularPeople(completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let resourceURL = URL(string: "https://api.themoviedb.org/3/person/popular?api_key=\(API_KEY)&language=en-US&page=1")!
        
        let task = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tvResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = tvResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    /**
     Retrieves the current popular shows from TMDB and returns it as a list of TVitems
     */
    static func getPopularShows(completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let resourceURL = URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=\(API_KEY)&language=en-US&page=1")!
        
        let task = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tvResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = tvResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    /**
     Retrieves the current upcoming movies from TMDB and returns it as a list of TVitems
     */
    static func getUpcomingMovies(completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let resourceURL = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(API_KEY)&language=en-US&page=1")!
        
        let task = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tvResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = tvResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    /**
     Searches the list of movies, people, and TV shows on TMDB with the given terms and returns a relevant list of results as TVItems
     `Parameter searchTerms: The search string given by the user`
     */
    static func searchMulti(searchTerms: String, completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let searchURL = URL(string: "https://api.themoviedb.org/3/search/multi?api_key=\(API_KEY)&query=\(replaceSpaces(string: searchTerms))")!
        
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = searchResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    /**
     Searches the list of movies on TMDB with the given terms and returns a relevant list of results as TVItems
     `Parameter searchTerms: The search string given by the user`
     */
    static func searchMovie(searchTerms: String, completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let searchURL = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(API_KEY)&query=\(replaceSpaces(string: searchTerms))")!
        
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = searchResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    /**
     Searches the list of people on TMDB with the given terms and returns a relevant list of results as TVItems
     `Parameter searchTerms: The search string given by the user`
     */
    static func searchPeople(searchTerms: String, completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let searchURL = URL(string: "https://api.themoviedb.org/3/search/person?api_key=\(API_KEY)&query=\(replaceSpaces(string: searchTerms))")!
        
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = searchResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    /**
     Searches the list of shows on TMDB with the given terms and returns a relevant list of results as TVItems
     `Parameter searchTerms: The search string given by the user`
     */
    static func searchShows(searchTerms: String, completion: @escaping(Result<[TVItem], Error>) -> Void) {
        let searchURL = URL(string: "https://api.themoviedb.org/3/search/tv?api_key=\(API_KEY)&query=\(replaceSpaces(string: searchTerms))")!
        
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(Response.self, from: jsonData)
                let tvItems = searchResponse.results
                completion(.success(tvItems))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    /**
     Gets the image data from the given image URL
     `Parameter searchTerms: The url location of the image`
     */
    static func getImage(searchTerms: String, completion: @escaping(Result<Data, Error>) -> Void) {
        
        let searchURL = URL(string: "https://image.tmdb.org/t/p/original\(searchTerms)")!

        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            guard data != nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(data!))
        }
        task.resume()
    }
    
    /**
     Replaces spaces in the given string with %20 for use in API get requests
     */
    static func replaceSpaces(string:String) -> String {
        return string.replacingOccurrences(of: " ", with: "%20")
    }
    
}
