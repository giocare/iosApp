//
//  SavedJobs.swift
//  TalentedApp
//
//  Created by jess on 5/9/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import Foundation
import UIKit
import CoreData


//Mark: - Properties

import UIKit
import CoreData

class SavedJobsViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tblStudent: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    //Mark: - Properties
    lazy var context: NSManagedObjectContext = {
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDel.managedObjectContext
    }()
    
    //Mark: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch all student list from persistent data store
        fetchAllStudentList()
    }
    
    struct TableView {
        struct CellIdentifier {
            static let savedJobsCell = "SavedJobsCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    
    //Fetch Student List
    func fetchAllStudentList() {
        let fetchRequest = NSFetchRequest<JobInfo>(entityName: "Student")
        let fetchSort = NSSortDescriptor(key: "company", ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<NSFetchRequestResult>
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }
    }
    
    //Show list of student
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    //MARK: UITableViewDataSource
    //Number of section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //1
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
    }
    
    //Number of section in row
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedJobsCell", for: indexPath as IndexPath) as! SavedJobsCell
        let student = fetchedResultsController.object(at: indexPath as IndexPath)
        cell.configure(for: student as! JobInfo)
        return cell
    }
    
//    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
//        //1
//        let student = fetchedResultsController.objectAtIndexPath(forRowAtIndexPath) as! Student
//        cell.textLabel?.text = student.valueForKey("first_name") as? String
//    }
//
    
    
    //Delete from core data
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .delete:
                    let student = fetchedResultsController.object(at: indexPath as IndexPath)

                    context.delete(student as! NSManagedObject)
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving context after delete: \(error.localizedDescription)")
            }
        default:break
        }
    }
    
    
    // MARK: -  FetchedResultsController Delegate
    private func controllerWillChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblStudent.beginUpdates()
    }
    
    private func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblStudent.endUpdates()
    }
    
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        // 1
        switch type {
        case .insert:
            tblStudent.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tblStudent.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default: break
        }
    }
    
    private func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        // 2
        switch type {
        case .insert:
            tblStudent.insertRows(at: [(newIndexPath! as IndexPath)], with: .automatic)
        case .delete:
            tblStudent.deleteRows(at: [(indexPath! as IndexPath)], with: .automatic)
        default: break
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
