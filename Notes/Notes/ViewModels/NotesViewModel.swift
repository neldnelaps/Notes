//
//  NotesViewModel.swift
//  Notes
//
//  Created by Natalia Pashkova on 21.03.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class NotesViewModel {
    private let disposeBag = DisposeBag()
    var notesSection = BehaviorSubject(value: [SectionModel(model: "", items: [Note]())])
    var notesArray : [Note]
    var countNotes = BehaviorRelay<String?>(value: nil)
    
    var token : NotificationToken?
    let realm = try! Realm()
    
    init() {
        notesArray = [Note]()
        fetchNotes ()
        countNotes.accept(notesArray.count.notes())
        token = realm.observe({[weak self] _, realm in
            self?.fetchNotes()
            self?.countNotes.accept(self?.notesArray.count.notes())
        })
    }

    func fetchNotes () {
        notesArray = try! Realm().objects(Note.self).sorted(byKeyPath: "time").map({$0})
        
        var sectionFirst = [Note]()
        var sectionSecond = [Note]()
        
        for item in notesArray {
            if Calendar.current.compare(Date(), to: item.time, toGranularity: .day) == ComparisonResult.orderedSame {
                sectionFirst.insert(item, at: 0)
            }
            else {
                sectionSecond.insert(item, at: 0)
            }
        }
        
        var sections = [SectionModel(model: "", items: [Note]())]
        if sectionSecond.count != 0{
            sections.insert(SectionModel(model: "Остальное", items: sectionSecond), at: 0)
        }
        if sectionFirst.count != 0{
            sections.insert(SectionModel(model: "Cегодня", items: sectionFirst), at: 0)
        }
        self.notesSection.on(.next(sections))
    }

    func deleteNote(indexPath: IndexPath) {
        do {
            var index: Int = getIndex(indexPath: indexPath)!
            try realm.write {
                realm.delete(notesArray[index])
                notesArray.remove(at: index)
            }
        }
        catch let error as NSError {
            print("Error deleting note: \(error)")
        }
    }
    
    func editNote(note: Note, indexPath: IndexPath) {
        var index: Int = getIndex(indexPath: indexPath)!
        var noteNew = notesArray[index]
        
        do {
            try realm.write {
                noteNew.time =  note.time
                noteNew.title =  note.title
                noteNew.depiction =  note.depiction
            }
        }
        catch let error as NSError {
            print("Error edit note: \(error)")
        }
    }
    
    func getIndex(indexPath: IndexPath) -> Int? {
        var index: Int
        if indexPath.section == 0{
            index = notesArray.count - indexPath.row - 1
        }
        else {
            guard let sections = try? notesSection.value() else {return nil}
            index = notesArray.count - (sections[0].items.count + indexPath.row) - 1
        }
        return index
    }
}
