//
//  LoanApplicationsViewController.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import UIKit
import CoreData

class LoanApplicationsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBAction func unwindToApplicationsList( _ segue: UIStoryboardSegue) {}
   
    var container: NSPersistentContainer!
    var fetchedResultsController: NSFetchedResultsController<LoanApplication>!
    var loanApplicationPredicate: NSPredicate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Applications"
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "note.text.badge.plus"), style: .plain, target: self, action: #selector(addTapped))
        
        container = NSPersistentContainer(name: "BankLoanApplication")
        container.loadPersistentStores { (_, error) in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error {
                fatalError("Loading persistent stores failed: \(error)")
            }
        }
       
        self.loadContent()
    }
    
    func loadContent() {
       
        if fetchedResultsController == nil {
            let request = LoanApplication.fetchRequest()
            
           // let draftSort = NSSortDescriptor(keyPath: \LoanApplication.draftDate, ascending: false)
            
            let sortDescriptor = NSSortDescriptor(keyPath: \LoanApplication.submittedDate, ascending: false)
            request.sortDescriptors = [sortDescriptor]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            //let sortDescriptor = NSSortDescriptor(keyPath: "", ascending: false)
           // fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "submittedDate != nil")
            fetchedResultsController.delegate = self
        }
        fetchedResultsController.fetchRequest.predicate = loanApplicationPredicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    // MARK: -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "loanApplicationCell", for: indexPath) as? LoanApplicationTableViewCell else {
            print("incorrect cell type")
            return UITableViewCell()
        }
        
        let application = fetchedResultsController.object(at: indexPath)
        cell.populateWithApplication(application)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: SegueIdentifiers.showLoanApplicationDetailsSegueIdentifier.rawValue, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            
            let deleteLoanApplication = self.fetchedResultsController.object(at: indexPath)
            let viewContext = self.container.viewContext
            viewContext.delete(deleteLoanApplication)
            do {
                try viewContext.save()
            } catch {
                print("error saving")
            }
        }
        
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration

    }
    
    @objc func addTapped() {
        self.performSegue(withIdentifier: "showAddLoanFlowSegueID", sender: nil)
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
    func saveOrUpdateLoanApplication(_ loanApplication: DraftLoanApplication) {
        if loanApplication.uuid != nil {
            updateLoanApplicationDetails(loanApplication)
        } else {
            saveLoanApplication(loanApplication)
        }
    }
    
    func saveLoanApplication(_ loanApplication: DraftLoanApplication) {
        do {
            try container.viewContext.performAndWait {
                let contextVersion = loanApplication.populateCoreDataVersion(forContext: container.viewContext)
                
                contextVersion.uuid = UUID()
                contextVersion.submittedDate = Date()
                
                try container.viewContext.save()
                self.loadContent()
            }
        } catch {
            
        }
    }
    
    func updateLoanApplicationDetails(_ proxyLoanApplication: DraftLoanApplication) {
        
        guard let loanApplicationUUID = proxyLoanApplication.uuid else { return }
        
        let viewContext = container.viewContext
        
        do {
            let fetchRequest = LoanApplication.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uuid == %@", loanApplicationUUID.uuidString)
            
            var matches = try container.viewContext.fetch(fetchRequest)
            
            var loanApplication: LoanApplication?
            
            if matches.count == 0 {
               // no match so you we are inserting.
                loanApplication = LoanApplication(context: viewContext)
            } else {
               // we have a match so we are updating.
                loanApplication = matches.first
            }

            loanApplication?.populateWithDraft(proxyLoanApplication)
            try viewContext.save()
            
        } catch {
            print("issue saving context in func updateLoanApplicationDetails")
        }
        
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let summaryDestination = segue.destination as? LoanApplicationSummaryViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let existingLoanApplication = fetchedResultsController.object(at: indexPath)
                let nonCoredataVersion = DraftLoanApplication(loanApplication: existingLoanApplication)
                summaryDestination.loanApplication = nonCoredataVersion
            }
        }
        if let newApplicationDestination = segue.destination as? LoanApplicantDetailsViewController {
            newApplicationDestination.loanApplication = DraftLoanApplication()
        }
    }

}
