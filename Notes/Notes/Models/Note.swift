//
//  Note.swift
//  Notes
//
//  Created by Natalia Pashkova on 21.03.2023.
//

import RealmSwift

class Note : Object{
    @Persisted var id: String = UUID().uuidString
    @Persisted var title : String
    @Persisted var depiction : String
    @Persisted var time : Date
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
