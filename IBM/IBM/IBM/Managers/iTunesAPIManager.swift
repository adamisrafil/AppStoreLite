//
//  iTunesAPIManager.swift
//  IBM
//
//  Created by Adam Israfil on 8/31/21.
//

import Foundation

final class iTunesAPIManager {
    
    // MARK: Public
    
    func getSoftwareForSearchTerm(searchTerm: String, completion: @escaping (_ appList: [iTunesAppModel]?, _ errorMessage: String?) -> Void) {
        guard let url = buildURLFromTerm(searchTerm: searchTerm) else {
            completion(nil, "Could not genertate URL")
            return
        }
        
        var softwareListRequest = URLRequest(url: url)
        softwareListRequest.httpMethod = "GET"
        
        let softwareListRequestSession = URLSession.shared.dataTask(with: softwareListRequest) { (data, responseInformation, error) in
            guard let data = data, error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            
            guard let responseInformation = responseInformation as? HTTPURLResponse, (200...299).contains(responseInformation.statusCode) else {
                completion(nil, "Invalid response code")
                return
            }
            
            do {
                let appList = try JSONDecoder().decode(iTunesSearchResultModel.self, from: data)
                
                completion(appList.results, nil)
                return
            } catch {
                completion(nil, "Could not decode data into JSON")
                return
            }
        }
        
        softwareListRequestSession.resume()
    }
    
    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // MARK: Private
    
    private func buildURLFromTerm(searchTerm: String) -> URL? {
        var URLString = apiConstants.iTunesBaseURL
        URLString += "&term=\(searchTerm)"
        
        return URL(string: URLString)
    }
}

extension iTunesAPIManager {
    
    private struct apiConstants {
        
        static let iTunesBaseURL = "https://itunes.apple.com/search?country=us&entity=software&explicit=false&limit=25"
    }
}
