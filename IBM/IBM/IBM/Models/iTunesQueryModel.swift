//
//  iTunesQueryModel.swift
//  IBM
//
//  Created by Adam Israfil on 8/31/21.
//

import Foundation

struct iTunesQueryModel {
    
    var term: String
    var country: String
    var media: String?
    var limit: Int?
    var explicit: Bool?
    var entity: String?
    
    // Not currently implemented but part of API
    var attribute: String?
    var callback: String?
    var lang: String?
    var version: Int?
    
    init(searchTerm: String, limit: Int?) {
        self.term = searchTerm
        self.country = "US"
        self.media = mediaTypes.software.rawValue
        self.limit = limit
        self.explicit = false
        self.entity = softwareEntitities.software.rawValue
    }
    
    private enum softwareEntitities: String {
        
        case software
        case iPadSoftware
        case macSoftware
    }
    
    private enum mediaTypes: String {
        
        case movie
        case podcast
        case music
        case musicVideo
        case audiobook
        case shortFilm
        case tvShow
        case software
        case ebook
        case all
    }
}
