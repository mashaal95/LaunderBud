//
//  JSONDownloader.swift
//  Assignment3
//
//  Created by MAC on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//


import Foundation

class JSONDownloader {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration){
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias JSON = [String: AnyObject]
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping (JSON?, DarkSkyError?) -> Void ) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            
            guard let httpResponse = response as? HTTPURLResponse else {
                
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonParsingFailure)
                    }
                    
                } else {
                    completion(nil, .invalidData)
                }
                
            } else {
                completion(nil, .responseUnsuccessful(statusCode: httpResponse.statusCode))
            }
            
        }
        return task
    }
}
