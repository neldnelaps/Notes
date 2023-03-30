//
//  NotesTests.swift
//  NotesTests
//
//  Created by Natalia Pashkova on 30.03.2023.
//

import XCTest
import RealmSwift
@testable import Notes

final class NotesTests: XCTestCase {
    var sut: Note!
    var realm: Realm!
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = Note()
        sut.title = "Title"
        sut.depiction = "Depiction"
        realm = try! Realm()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testPerformanceExample() throws {
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAddNote() throws {
        try! realm.write {
            realm.add(sut)
        }

        let note = realm.objects(Note.self).first(where: { $0.title == "Title" })!

        XCTAssert(note.title == "Title")
        XCTAssert(note.depiction == "Depiction")
    }
    
    func testUpdateNote() throws {
        try! realm.write {
            realm.add(sut)
        }

        let note = realm.objects(Note.self).first(where: { $0.title == "Title" })!

        try! realm.write {
            note.title = "New Title"
            note.depiction = "New Depiction"
        }

        XCTAssert(note.title == "New Title")
        XCTAssert(note.depiction == "New Depiction")
    }
    
    func testDeleteNote() throws {
        try! realm.write {
            realm.add(sut)
        }

        let note = realm.objects(Note.self).first(where: { $0.title == "Title"})!

        try! realm.write {
            realm.deleteAll()
        }
        XCTAssertNil(realm.objects(Note.self).first(where: { $0.title == "Title" }))
    }
}
