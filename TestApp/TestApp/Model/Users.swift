//
//  Users.swift
//  TestApp
//
//  Created by Dimitar on 9.1.21.
//

import Foundation

struct User: Codable {
    var email: String?
    var fullName: String?
    var id: String?
    
    init(id: String) {
        self.id = id
    }
}

