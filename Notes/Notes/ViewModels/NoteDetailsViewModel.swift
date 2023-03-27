//
//  NoteDetailsViewModel.swift
//  Notes
//
//  Created by Natalia Pashkova on 22.03.2023.
//

import Foundation
import RealmSwift

class NoteDetailsViewModel {
    let realm = try! Realm()
    
    func addNote(note: Note){
        try? realm.write {
            realm.add(note, update: .all)
        }
    }
}
