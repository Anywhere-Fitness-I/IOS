//
//  ClientClassTableViewController.swift
//  AnywhereFitness
//
//  Created by Enzo Jimenez-Soto on 5/26/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit
import CoreData

class ClientClassTableViewController: UITableViewController {
    
    var backendController = BackendController.shared
    var fetchResultController: NSFetchedResultsController<Course>!
    var classRepresentation: ClassRepresentation?
    
    @IBOutlet weak var searchClassBar: UISearchBar!
    
     private func setUpFetchResultController(with predicate: NSPredicate = NSPredicate(value: true)) {
        self.fetchResultController = nil
      
        
      
       
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()

        fetchRequest.predicate = predicate
        let context = CoreDataStack.shared.mainContext
        context.reset()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
    
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error in fetching the posts.")
        }
        self.fetchResultController = frc
        
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchClassBar.delegate = self
        
        searchBar(searchClassBar, textDidChange: "")
        
        setUpFetchResultController()

        if backendController.isSignedIn {
            backendController.syncCourse { error in
                DispatchQueue.main.async {
                    if let error = error {
                        NSLog("Error trying to fetch course: \(error)")
                        
                    } else {
                        self.tableView.reloadData()
                    }
                }
            }
        }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllClassesCell", for: indexPath) as? ClientCourseTableViewCell else { return UITableViewCell() }
        
        cell.course = fetchResultController.object(at: indexPath)
      
     // Configure the cell...
     
     return cell
     }
     
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
        if segue.identifier == "classDetailSegue" {
            if let detailVC = segue.destination as? ClientClassDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.course = fetchResultController.object(at: indexPath)
            }
        }
     }
     
    
}

extension ClientClassTableViewController: NSFetchedResultsControllerDelegate {
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

extension ClientClassTableViewController: UISearchBarDelegate, UISearchDisplayDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if !searchText.isEmpty {
      var predicate: NSPredicate = NSPredicate()
      predicate = NSPredicate(format: "location contains[c] '\(searchText)'")
      setUpFetchResultController(with: predicate)
    } else {
      setUpFetchResultController()
    }
    tableView.reloadData()
  }
}
