//
//  DeclinationExtension.swift
//  Notes
//
//  Created by Natalia Pashkova on 22.03.2023.
//

import Foundation

extension Int {
     func notes() -> String {
         var note: String!
         if "1".contains("\(self % 10)"){
             note = "заметка"
         }
         if "234".contains("\(self % 10)"){
             note = "заметки"
         }
         if "567890".contains("\(self % 10)"){
             note = "заметок"
         }
         if 11...14 ~= self % 100{
             note = "заметок"
         }
         return "\(self) \(note!)"
    }
}
