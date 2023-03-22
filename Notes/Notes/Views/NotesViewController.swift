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

//       let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onTapAdd))
//       self.navigationItem.rightBarButtonItem = add

        bindTableView()
        bindText()
    }
    
    @objc func onTapAdd(){
        let note = Note(id: 45, title: "Новая заметка", description: "Нет дополнительного текста", time: "14:20")
        self.viewModel.addNote(note: note)
    }
    
    func bindText() {
        viewModel.countNotes.bind(to: countLabel.rx.text).disposed(by: bag)
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Note>>{ _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
            cell.titleLabel?.text = item.title
            cell.descriptionLabel?.text = item.description
            cell.timeLabel?.text = item.time
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        self.viewModel.notes.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteNote(indexPath: indexPath)
        })
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Note", message: "Edit Note", preferredStyle: .alert)
            alert.addTextField { textField in
                
            }
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                self.viewModel.editNote(title: textField.text ?? "", indexPath: indexPath)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }
}
   
extension NotesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        header.textLabel?.textColor = .black
    }
}
