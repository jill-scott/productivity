//
//  ViewController.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/7/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxRealm
import RealmSwift

class IntroScreenViewController: UITableViewController {

    var buttonRow: Int?
    var disposeBag = DisposeBag()
    static let allColors = ["White": UIColor.white, "Night": UIColor.nighttime, "Regal": UIColor.regal, "Seafoam": UIColor.seafoam, "Stormy": UIColor.stormy, "Baleen": UIColor.whale]
    var usedColors: [UIColor: String] = [:]
    var selectedTeammate: Teammate?
    let dataSource: RxTableViewSectionedReloadDataSource<SectionData> = IntroScreenViewController.tableViewDataSource()
    var teammateList: List<Teammate>?
    var selectedRow: Row?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(BasicTableCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
        // Remove any datasource or delegate set in the storyboard.
        tableView.dataSource = nil
        tableView.delegate = nil

        // TESTING - HARDCODED DATA
        let newTeam = Team(name: "NOICE")
        let newTeammate = Teammate(name: "Jill", colorName: "White")
        StateManager.sharedInstance.processEvent(event: .addTeam(newTeam))
        StateManager.sharedInstance.processEvent(event: .addTeammate(newTeam, newTeammate))
        // END HARDCODED DATA
        
        teammateList = StateManager.sharedInstance.teammates
        
        if let teammateList = teammateList {
            let teammateListObservable = Observable.array(from: teammateList)
            
            teammateListObservable
                .asDriver(onErrorJustReturn: ([]))
                .map { (team) -> [SectionData] in
                    let data = IntroScreenViewController.tableViewData(teammates: team)
                    return data
                }
                .drive(tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
        
        // Make sure our delegate methods will be called rxishly
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
}


// MARK: - Tableview delegate and datasource methods

extension IntroScreenViewController {
    
    struct Row: Equatable, IdentifiableType {

        static func == (lhs: Row, rhs: Row) -> Bool {
            return lhs.name == rhs.name
        }
        
        typealias Identity = String
        
        let teammate: Teammate?
        let colorName: String?
        let name: String?
        
        init(_ teammate: Teammate) {
            self.teammate = teammate
            self.colorName = teammate.colorName
            self.name = teammate.name
        }
        
        var identity: Identity {
            return name ?? ""
        }
    }
    
    struct SectionData: SectionModelType {
        typealias Item = Row
        typealias Identity = String
        
        var title: String = ""
        var items: [Item]
        
        var identity: String {
            return title
        }
        
        init(title: String, rows: [Item]) {
            self.title = title
            self.items = rows
        }
        
        init(original: SectionData, items: [Item]) {
            self = original
            self.items = items
        }
    }
    
    static func tableViewData(teammates: [Teammate]) -> [SectionData] {
        let rows: [Row]
        rows = teammates.map({ Row($0) })
        return [SectionData(title: "", rows: rows)]
    }
    
    static func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<SectionData> {
        return RxTableViewSectionedReloadDataSource<SectionData>(configureCell: IntroScreenViewController.tableViewCell,
                                                                 canEditRowAtIndexPath: { _, _ in true })
    }
    
    static func tableViewCell(ds: TableViewSectionedDataSource<SectionData>, tableView: UITableView, indexPath: IndexPath, row: Row) -> UITableViewCell {
        let cell = tableView.dequeueReusableAppCell(BasicTableCell.self, indexPath: indexPath)
        
        
        cell.titleLabel.text = row.name
        //cell.updateColor(color: row.teammate.color ?? UIColor.white)
        
        // Check to see if we have the system status already.
        if let colorName = row.colorName, let color = allColors[colorName] {
            cell.updateColor(color: color)
        } else {
            cell.updateColor(color: UIColor.white)
        }
        
        return cell
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowInfo = dataSource.sectionModels[indexPath.section].items[indexPath.row]
        selectedTeammate = rowInfo.teammate
        selectedRow = rowInfo
        performSegue(withIdentifier: SegueIdentifiers.showEditMember, sender: self)
    }
}

// MARK: - NAVIGATION

extension IntroScreenViewController {
    struct SegueIdentifiers {
        static let showEditMember = "ShowEditMember"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.showEditMember {
            guard let destination = segue.destination as? EditTeammateViewController, let row = selectedRow else { return }
            
            destination.name = selectedTeammate?.name
            let colornameStrings = IntroScreenViewController.allColors.keys.map( { $0 })
            destination.colorNames = colornameStrings
            destination.selectedColor = selectedTeammate?.colorName
            destination.colorSelected = { (idx, optionStr) in
                let selectedValue = colornameStrings[idx]
                if selectedValue != row.colorName, let teammate = self.selectedTeammate {
                    StateManager.sharedInstance.changeTeammateColor(viewController: self, teammate: teammate, newColorName: selectedValue)
                }
            }
        }
    }
}
