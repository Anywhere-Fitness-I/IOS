//
// InstructorClassTableViewController.swift
// AnywhereFitness
//
// Created by Enzo Jimenez-Soto on 5/26/20.
// Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit
import CoreData

class InstructorClassTableViewController: UITableViewController {
    
    var backendController = BackendController.shared
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if backendController.isSignedIn {
            backendController.forceLoadInstructorClass { loaded, _ in
                
                if let loaded = loaded {
                    if loaded {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        
        
        
        
    }
    @IBAction func refreshControl(_ sender: UIRefreshControl) {
        //    if backendController.isSignedIn {
        //      backendController.forceLoadInstructorClass { loaded, _ in
        //        if loaded {
        //          self.tableView.reloadData()
        //        }
        //      }
        //    }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return backendController.userCourse.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "instructorClassCell",
                                                       for: indexPath) as? InstructorCourseTableViewCell else { return UITableViewCell() }
        cell.course = backendController.userCourse[indexPath.row]
        return cell
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let course = backendController.userCourse[indexPath.row]
            if backendController.isSignedIn {
                backendController.deleteEntryFromServe(course: course) { result  in
                    guard let _ = try? result.get() else {
                        return
                    }
                    DispatchQueue.main.async {
                        if let indexOf = self.backendController.userCourse.firstIndex(of: course) {
                            self.backendController.userCourse.remove(at: indexOf)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     }
     */
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "instructorClassDetailSegue" {
            if let detailVC = segue.destination as? InstructorClassDetailController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.course = backendController.userCourse[indexPath.row]
            }
        }
    }
    
}
extension InstructorClassTableViewController: NSFetchedResultsControllerDelegate {
    //  this is the warning the tableview that the fetch controller is goijng to makechanges in the tableview.
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        //  this is the beggnining of the fetchhing
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        //   the endo of the fetchhing.
    }
    // deletes the entire section or insert entire section
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
