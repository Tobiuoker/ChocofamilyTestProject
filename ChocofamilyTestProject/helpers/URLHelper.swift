//
//  URLHelper.swift
//  ChocofamilyTestProject
//
//  Created by Khaled on 21.06.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import Foundation

//extension for countries code substitution in url
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
            var components = URLComponents(url: self,
            resolvingAgainstBaseURL: true)
            components?.queryItems = queries.map
            { URLQueryItem(name: $0.0, value: $0.1) }
            return components?.url
        }
}
