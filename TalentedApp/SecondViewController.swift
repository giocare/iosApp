//
//  SecondViewController.swift
//  TalentedApp
//
//  Created by jess on 4/19/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var savedJobs = [JobInfo]()
    let player = AudioManager.sharedInstance
   
    override func viewDidLoad() {
        super.viewDidLoad()
        var cellNib = UINib(nibName: TableView.CellIdentifier.savedJobsCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifier.savedJobsCell)

        cellNib = UINib(nibName: TableView.CellIdentifier.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifier.nothingFoundCell)
        
        showdata()
        
        let rightBarButton = UIBarButtonItem(title: "Refresh", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SecondViewController.refreshButton(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    struct TableView {
        struct CellIdentifier {
            static let savedJobsCell = "SavedJobsCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savedJobs.count == 0 {
            return 1
        } else {
            return savedJobs.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if savedJobs.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "NothingFoundCell", for: indexPath)
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedJobsCell", for: indexPath) as! SavedJobsCell
            let jobs = savedJobs[indexPath.row]
            cell.configure(for: jobs)
            return cell
            }
        }
    
    //MARK:- DELETE ROW
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.player.playAudio(fileName: "Swoosh", fileType: "mp3")
         let noteEntity = "JobInfo" //Entity Name
         let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
         let rowToDelete = savedJobs[indexPath.row]
         if editingStyle == .delete {
            managedContext.delete(rowToDelete)

            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
         }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: noteEntity)
        do {
            savedJobs = try managedContext.fetch(fetchRequest) as! [JobInfo]
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
        }
        showdata()
    }

    func showdata() {
        print("*** REFRESHING ***")
        guard let appDelage = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelage.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "JobInfo")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            savedJobs = try managedContext.fetch(fetchRequest) as! [JobInfo]
            if savedJobs.count == 0 {
                print("No Jobs Found")
            } else {
                print("\(savedJobs.count) Jobs Found")
            }
        } catch let err as NSError {
            print("Error", err)
        }
        tableView.reloadData()
    }
    
    @objc func refreshButton(_ sender:UIBarButtonItem!)
    {
        print("myRightSideBarButtonItemTapped")
        print("Refresh Saved Jobs")
        UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { () -> Void in self.tableView.reloadData()}, completion: nil)
        showdata()
    }
    
}
