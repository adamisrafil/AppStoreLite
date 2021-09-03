//
//  iTunesAppModel.swift
//  IBM
//
//  Created by Adam Israfil on 8/31/21.
//

import Foundation

struct iTunesSearchResultModel: Codable {
    
    var resultCount: Int
    var results: [iTunesAppModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try container.decode(Int.self, forKey: .resultCount)

        let appResponses = try container.decode([iTunesAppModel].self, forKey: .results)
        results = appResponses
    }
}

struct iTunesAppModel: Codable {
    
    var advisories: [String]
    var artistName: String
    var artistViewUrl: String
    var artworkUrl100: String
    var artworkUrl512: String
    var artworkUrl60: String
    var averageUserRatingForCurrentVersion: Double
    var contentAdvisoryRating: String
    var description: String
    var features: [String]
    var fileSizeBytes: String
    var formattedPrice: String
    var genres: [String]
    var languageCodesISO2A: [String]
    var minimumOsVersion: String
    var price: Double
    var primaryGenreName: String
    var screenshotUrls: [String]
    var sellerName: String
    var supportedDevices: [String]
    var trackName: String
    var userRatingCountForCurrentVersion: Int
    var version: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        advisories = try container.decode([String].self, forKey: .advisories)
        artistName = try container.decode(String.self, forKey: .artistName)
        artistViewUrl = try container.decode(String.self, forKey: .artistViewUrl)
        artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
        artworkUrl512 = try container.decode(String.self, forKey: .artworkUrl512)
        artworkUrl60 = try container.decode(String.self, forKey: .artworkUrl60)
        averageUserRatingForCurrentVersion = try container.decode(Double.self, forKey: .averageUserRatingForCurrentVersion)
        contentAdvisoryRating = try container.decode(String.self, forKey: .contentAdvisoryRating)
        description = try container.decode(String.self, forKey: .description)
        features = try container.decode([String].self, forKey: .features)
        fileSizeBytes = try container.decode(String.self, forKey: .fileSizeBytes)
        formattedPrice = try container.decode(String.self, forKey: .formattedPrice)
        genres = try container.decode([String].self, forKey: .genres)
        languageCodesISO2A = try container.decode([String].self, forKey: .languageCodesISO2A)
        minimumOsVersion = try container.decode(String.self, forKey: .minimumOsVersion)
        price = try container.decode(Double.self, forKey: .price)
        primaryGenreName = try container.decode(String.self, forKey: .primaryGenreName)
        screenshotUrls = try container.decode([String].self, forKey: .screenshotUrls)
        sellerName = try container.decode(String.self, forKey: .sellerName)
        supportedDevices = try container.decode([String].self, forKey: .supportedDevices)
        trackName = try container.decode(String.self, forKey: .trackName)
        userRatingCountForCurrentVersion = try container.decode(Int.self, forKey: .userRatingCountForCurrentVersion)
        version = try container.decode(String.self, forKey: .version)
    }
}

enum AppPriceFilter: Int {
    
    case all = 0
    case free = 1
    case paid = 2
    static var count: Int { return AppPriceFilter.paid.rawValue + 1 }
    
    var description: String {
        switch self {
        case .all: return "All"
        case .free: return "Free"
        case .paid: return "Paid"
        }
    }
}

enum GenresFilters: Int {
    
    case all = 0
    case books = 1
    case medical = 2
    case business = 3
    case music = 4
    case developerTools = 5
    case navigation = 6
    case education = 7
    case news = 8
    case entertainment = 9
    case photoVideo = 10
    case finance = 11
    case productivity = 12
    case foodDrink = 13
    case reference = 14
    case games = 15
    case safariExtensions = 16 //macOS only
    case graphicsDesign = 17
    case shopping = 18
    case healthFitness = 19
    case lifestyle = 20
    case socialNetworking = 21
    case kids = 22
    case sports = 23
    case magazinesNewspapers = 24
    case travel = 25
    case utilities = 26
    case weather = 27
    static var count: Int { return GenresFilters.weather.rawValue + 1 }
    
    var description: String {
        switch self {
        case .all: return "All"
        case .books: return "Books"
        case .medical: return "Medical"
        case .business: return "Business"
        case .music: return "Music"
        case .developerTools: return "Developer Tools"
        case .navigation: return "Navigation"
        case .education: return "Education"
        case .news: return "News"
        case .entertainment: return "Entertainment"
        case .photoVideo: return "Photo & Video"
        case .finance: return "Finance"
        case .productivity: return "Productivity"
        case .foodDrink: return "Food & Drink"
        case .reference: return "Reference"
        case .games: return "Games"
        case .safariExtensions: return "Safari Extensions" //macOS only
        case .graphicsDesign: return "Graphics & Design"
        case .shopping: return "Shopping"
        case .healthFitness: return "Health & Fitness"
        case .lifestyle: return "Lifestyle"
        case .socialNetworking: return "Social Networking"
        case .kids: return "Kids"
        case .sports: return "Sports"
        case .magazinesNewspapers: return "Magazines & Newspapers"
        case .travel: return "Travel"
        case .utilities: return "Utilities"
        case .weather: return "Weather"
        }
    }
}
