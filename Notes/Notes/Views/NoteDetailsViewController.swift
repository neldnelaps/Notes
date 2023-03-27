//
//  NoteDetailsViewController.swift
//  Notes
//
//  Created by Natalia Pashkova on 22.03.2023.
//

import UIKit
import RealmSwift

class NoteDetailsViewController: UIViewController, UITextViewDelegate {
    private var viewModel =  NoteDetailsViewModel()
    var note = Note()
    
    var indexPath : IndexPath?
    var delegate : UpdateNoteDelegate?
    
    @IBOutlet weak var textView: UITextView!
    private var firstLineRange = NSRange()
    private var attributedText = NSAttributedString()
    let maximumCharsOfNoteTitle = 20
    
    var titleLines : String = ""
    var depictionLines : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        textView.delegate = self
        textView.layer.cornerRadius = 12

        if note.title.isEmpty && note.depiction.isEmpty {
            return
        }
        textView.text = "\(note.title)\n\(note.depiction)"
        boldFirstLineOfNote()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            updateNote()
        }
    }
    
    func updateNote(){
        getTitleAndDepictionOfNote(textView.text ?? "")
        if note.title == titleLines && note.depiction == depictionLines {
            return
        }
        
        note.title = titleLines
        note.depiction = depictionLines
        if note.title.isEmpty && note.depiction.isEmpty {
            return
        }
        note.time = Date()
        
        if indexPath != nil{
            delegate?.updateNote(note: note, indexPath: indexPath!)
        }
        else {
            self.viewModel.addNote(note: note)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {

        boldFirstLineOfNote()
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
    private func boldFirstLineOfNote() {
          let newAttributedText = textView.attributedText ?? NSAttributedString()

          if attributedText != newAttributedText {
              attributedText = newAttributedText

              // reset style of attributed text
              let currentSelectedRange = textView.selectedRange
              let attributedText = attributedText.string
              let regularStyle = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                  NSAttributedString.Key.foregroundColor : UIColor.label]
              let attributedString = NSMutableAttributedString(string: attributedText, attributes: regularStyle)
              textView.attributedText = attributedString
              
              // bold it
              let textNote = textView.text ?? ""
              let lineBreakIndex = textNote.firstIndex(of: "\n") ?? textNote.endIndex
              let firstLine = String(textNote[..<lineBreakIndex])
              
              let range = NSRange(location: 0, length: firstLine.count)
              
              let attributeOfBold = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30),
                NSAttributedString.Key.foregroundColor : UIColor.label
              ]
              
              attributedString.addAttributes(attributeOfBold, range: range)
              
              textView.attributedText = attributedString
              textView.selectedRange = currentSelectedRange
          }
      }
    
    private func getTitleAndDepictionOfNote(_ text: String){
        let firstLine = text.components(separatedBy: "\n")[0]
        titleLines = firstLine
        depictionLines = textView.text.substring(from: titleLines.endIndex).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if notification.name == UIResponder.keyboardWillHideNotification {
                textView.contentInset = UIEdgeInsets.zero
            }
            else {
                textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                textView.scrollIndicatorInsets = textView.contentInset
            }
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }
}

protocol UpdateNoteDelegate {
    func updateNote(note : Note, indexPath: IndexPath)
}
