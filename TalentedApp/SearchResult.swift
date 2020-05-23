//
//  SearchResults.swift
//  TalentedApp
//
//  Created by jess on 5/4/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import Foundation
import UIKit

//struct ResultArray: Codable {
//    //var resultCount = 0
//    let results: [SearchResult]
//}

struct SearchResult: Codable {
    var id: String? = ""
    var type: String? = ""
    var url: String? = ""
    var created_at: String? = ""
    var company: String? = ""
    var company_url: String? = ""
    var location: String? = ""
    var title: String? = ""
    var description: String? = ""
    var how_to_apply: String? = ""
    var company_logo: String? = ""
}
