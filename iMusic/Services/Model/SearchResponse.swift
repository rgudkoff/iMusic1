//
//  SearchResponse.swift
//  iMusic
//
//  Created by Роман Гудков on 04.01.2023.
//

import Foundation


struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var artistName: String
    var collectionName: String?
    var artworkUrl100: String?
    var previewUrl: String?
    
}
