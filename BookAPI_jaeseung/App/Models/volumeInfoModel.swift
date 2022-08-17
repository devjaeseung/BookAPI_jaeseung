//
//  Model.swift
//  BookAPI_jaeseung
//
//  Created by jaeseung lim on 2022/08/12.
//

import Foundation


struct volumeInfoModel: Decodable {
    
    let volumeInfo: VolumeInfo
    
    var title: String { volumeInfo.title }
    var authors: [String] { volumeInfo.authors }
    var publishedDate: String { volumeInfo.publishedDate }
    var smallThumbnail: String { volumeInfo.imageLinks.smallThumbnail }
    var thumbnail: String { volumeInfo.imageLinks.thumbnail }
    var infoLink: String { volumeInfo.infoLink }
    
    struct VolumeInfo: Decodable {
        
        let title: String
        let authors: [String]
        let publishedDate: String
        let imageLinks: ImageLinks
        let infoLink: String
        
    }
    
}

struct ImageLinks: Decodable {
    
    let smallThumbnail: String
    let thumbnail: String
    
}
