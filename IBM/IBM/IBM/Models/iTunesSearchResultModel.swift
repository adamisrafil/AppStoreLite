//
//  iTunesSearchResultModel.swift
//  IBM
//
//  Created by Adam Israfil on 8/31/21.
//

import Foundation

struct iTunesSearchResultArrayModel: Decodable {
    
    var resultCount: Int
    var results: [iTunesSearchResultModel]
    
    init(resultCount: Int, results: [iTunesSearchResultModel]) {
        self.resultCount = resultCount
        self.results = results
    }
}

struct iTunesSearchResultModel: Decodable {
    
    var ipadScreenshotUrls: [String]
    var appletvScreenshotUrls: [String]
    var screenshotUrls: [String]
    var advisories: [String]
    var isGameCenterEnabled: Bool
    var supportedDevices: [String]
    var features: [String]
    var kind: String
    var minimumOsVersion: String
    var trackCensoredName: String
    var languageCodesISO2A: [String]
    var fileSizeBytes: String
    var sellerUrl: String
    var formattedPrice: String
    var contentAdvisoryRating: String
    var averageUserRatingForCurrentVersion: Double
    var userRatingCountForCurrentVersion: Int
    var averageUserRating: Double
    var trackViewUrl: String
    var trackContentRating: String
    var genreIds: [String]
    var trackId: Int
    var trackName: String
    var releaseDate: String
    var sellerName: String
    var primaryGenreName: String
    var isVppDeviceBasedLicensingEnabled: Bool
    var currentVersionReleaseDate: String
    var releaseNotes: String
    var primaryGenreId: Int
    var currency: String
    var description: String
    var artistId: Int
    var artistName: String
    var genres: [String]
    var price: Double
    var bundleId: String
    var version: String
    var wrapperType: String
    var userRatingCount: Int
}
