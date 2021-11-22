//
//  ApiConfig.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import Foundation

class APIConfig {
    
    static let shared = APIConfig()
    
    var baseURL = "https://run.mocky.io/"
    let apiKey = Secrets.API_KEY
    var token: String?
        
}
 
