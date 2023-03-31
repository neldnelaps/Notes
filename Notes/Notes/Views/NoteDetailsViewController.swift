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
    private var attributedText = NSAttributedString()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textViewLayoutConstraint: NSLayoutConstraint!
    
    var titleLines : String = ""
    var depictionLines : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        textView.delegate = self
        textView.layer.cornerRadius = 12
        
        if note.title.isEmpty && note.depiction.isEmpty {
            return
        }
        textView.text = "\(note.title)\n\(note.depiction)"
        textView.clipsToBounds = false
        boldFirstLineOfNote()
        textViewSizeThatFits()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            updateNote()
        }
        NotificationCenter.default.removeObserver(self)
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
        textViewSizeThatFits()
    }
    
    func textViewSizeThatFits() {
        self.textViewLayoutConstraint.constant = self.textView.sizeThatFits(CGSize(width: self.textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    private func boldFirstLineOfNote() {
          let newAttributedText = textView.attributedText ?? NSAttributedString()

          if attributedText != newAttributedText {
              attributedText = newAttributedText

              let currentSelectedRange = textView.selectedRange
              let attributedText = attributedText.string
              let regularStyle = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                  NSAttributedString.Key.foregroundColor : UIColor.label]
              let attributedString = NSMutableAttributedString(string: attributedText, attributes: regularStyle)
              textView.attributedText = attributedString
              
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
        boldFirstLineOfNote()
        depictionLines = textView.text.substring(from: titleLines.endIndex).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

protocol UpdateNoteDelegate {
    func updateNote(note : Note, indexPath: IndexPath)
}
