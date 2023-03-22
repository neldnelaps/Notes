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

class NotesViewModel {
    private let disposeBag = DisposeBag()
    var notes = BehaviorSubject(value: [SectionModel(model: "", items: [Note]())])
    var countNotes = BehaviorRelay<String?>(value: nil)

    init() {
        fetchNotes ()
        countNotes.accept(getCountNotes())
    }

    func fetchNotes () {
        //TODO notes
        let sectionFirst = SectionModel(model: "First Section", items: [
            Note(id: 0, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 1, title: "Новая заметка", description: "Нет дополнительного текста", time: "14/03/2023")])
        let sectionSecond = SectionModel(model: "Second Section", items: [
            Note(id: 0, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 1, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 2, title: "Новая заметка", description: "Нет дополнительного текста", time: "14/03/2023"),
            Note(id: 3, title: "Новая заметка", description: "Нет дополнительного текста", time: "14/03/2023"),
            Note(id: 4, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 5, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 6, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 7, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 8, title: "Новая заметка", description: "Нет дополнительного текста", time: "14/03/2023"),
            Note(id: 9, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 10, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 11, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 12, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 13, title: "Новая заметка", description: "Нет дополнительного текста", time: "14/03/2023"),
            Note(id: 14, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 15, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20"),
            Note(id: 16, title: "Новая заметка", description: "Нет дополнительного текста", time: "14/03/2023")])
        self.notes.on(.next([sectionFirst, sectionSecond]))
    }
    
    func getCountNotes() -> String{
        var count : Int = 0
        guard let sections = try? notes.value() else {return 0.notes()}
        for item in sections {
            count = count + item.items.count
        }
        return count.notes()
    }
    
    func addNote(note: Note){
        guard var sections = try? notes.value() else {return}
        var currentSection = sections[0]
        currentSection.items.insert(note, at: 0)
        sections[0] = currentSection
        self.notes.onNext(sections)
        countNotes.accept(getCountNotes())
    }
    
    func deleteNote(indexPath: IndexPath) {
        guard var sections = try? notes.value() else {return}
        var currentSection = sections[indexPath.section]
        currentSection.items.remove(at: indexPath.row)
        sections[indexPath.section] = currentSection
        self.notes.onNext(sections)
        countNotes.accept(getCountNotes())
    }
    
    func editNote(title: String, indexPath: IndexPath) {
        guard var sections = try? notes.value() else {return}
        var currentSection = sections[indexPath.section]
        currentSection.items[indexPath.row].title = title
        sections[indexPath.section] = currentSection
        self.notes.onNext(sections)
    }
}
