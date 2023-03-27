//
//  ViewController.swift
//  Notes
//
//  Created by Natalia Pashkova on 21.03.2023.
//

import UIKit
import RxSwift
import RxDataSources

class NotesViewController: UIViewController {
    private var viewModel = NotesViewModel()
    private var bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")

        bindAction()
        bindTableView()
        bindText()
    }
    
    func bindAction() {
        addNoteButton.rx.tap.bind {
            DispatchQueue.main.async {
                self.show(NoteDetailsViewController(), sender: self)
            }
        }
    }
    func bindText() {
        viewModel.countNotes.bind(to: countLabel.rx.text).disposed(by: bag)
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Note>>{ _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
            cell.titleLabel?.text = item.title
            cell.depictionLabel?.text = item.depiction

            let date : Date = item.time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
           
            cell.timeLabel?.text = dateFormatter.string(from: date)
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        self.viewModel.notesSection.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteNote(indexPath: indexPath)
        })
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            DispatchQueue.main.async {
                var vc = NoteDetailsViewController()
                let index: Int = self.viewModel.getIndex(indexPath: indexPath)!
                vc.note.time = self.viewModel.notesArray[index].time
                vc.note.title = self.viewModel.notesArray[index].title
                vc.note.depiction = self.viewModel.notesArray[index].depiction
                vc.indexPath = indexPath
                vc.delegate = self
                self.show(vc, sender: self)
            }
        }).disposed(by: bag)
    }
}
   
extension NotesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        header.textLabel?.text =  header.textLabel?.text?.capitalized
        header.textLabel?.textColor = UIColor.label
    }
}

extension NotesViewController : UpdateNoteDelegate {
    func updateNote(note: Note, indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.viewModel.editNote(note: note, indexPath: indexPath)
        }
    }
}
