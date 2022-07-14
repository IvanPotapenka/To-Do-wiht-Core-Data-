//
//  ViewController.swift
//  Core Data Lesson 13
//
//  Created by PIY on 11.07.22.
//

import UIKit
import CoreData

class MainViewController: UITableViewController {
        
        private let cellId = "cell"
        private var tasks: [Task] = []
        private let manageContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
            
            setupNavigationBar()
            statusBarColorChange()
        }
        
        override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        fetchData()
    }


    // MARK: Setup navigation bar
        
        private func setupNavigationBar() {
            view.backgroundColor = .white
            title = "Tasks list"
            
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.prefersLargeTitles = true
            
            navigationItem.leftBarButtonItem = editButtonItem
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Add",
                style: .plain,
                target: self,
                action: #selector(addNewTask))
            navigationController?.navigationBar.tintColor = .white
}
    
     // MARK: Add new task
    
        @objc private func addNewTask() {
            showAlert(title: "Add new task", messege: "What do you want to add?")
        }
       
     // MARK: Show alert
    
        private func showAlert(
                               title: String,
                               messege: String,
                               currentValue: Task? = nil,
                               completion: ((String) -> ())? = nil) {
            
            let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
                
                currentValue !== nil ? self.editRow(currentValue!, task) : self.save(task)
                
                self.tableView.reloadData()
                    }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alert.addTextField()
            alert.textFields?.first?.text = currentValue?.name
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
        present(alert, animated: true)
}
     // MARK: Edit Action For Row In Table View
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            
            let task = tasks[indexPath.row]
            
            let editAction = UITableViewRowAction(
                                                  style: .default,
                                                  title: "Edit",
                                                  handler: { (showAlert, edit)  in
                                                  self.showAlert(
                                                    title: "",
                                                    messege: "Edit list item",
                                                    currentValue: task )
                                                 }
                                                 )
            let deleteAction = UITableViewRowAction(
                                                  style: .destructive,
                                                  title: "Delete",
                                                  handler: { (action, indexPath) in
                                                  self.deleteTask(task, indexPath: indexPath)
                                                 }
                                                 )
           return [deleteAction, editAction]
                                                      
    }
    
    // MARK: Save content
    
    // Edit task
    
    private func editRow(_ task: Task,_ newValue: String) {
        task.name = newValue
        do {
            try manageContext.save()
            } catch let error { print("Failed to save text", error) }
    }
     
    // Save task
    
       private func save(_ taskName: String) {
        
        guard let entityDiscription = NSEntityDescription.entity(forEntityName: "Task", in: manageContext) else { return }
        
        let task = NSManagedObject(entity: entityDiscription, insertInto: manageContext) as! Task
        task.name = taskName
           
        do {
            try manageContext.save()
            tasks.append(task)
            tableView.reloadData()
            
        } catch let error { print("Failed to save text", error) }
    }
    
    // Delete task
    
        private func deleteTask(_ task: Task, indexPath: IndexPath) {
        manageContext.delete(task)
        do {
            try manageContext.save()
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        catch let error { print(error) }
        tableView.reloadData()
    
    }
    
    // MARK: Insert content
    
   private func fetchData() {
    
    let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
   
       do{
         tasks = try manageContext.fetch(fetchRequest)
    } catch let error { print(error.localizedDescription) }
    
  }
                                                  }
                                                  

                                                  
    // MARK: Table setup

extension MainViewController {
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tasks.count
        }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            let task = tasks[indexPath.row]
            cell.textLabel?.text = task.name
            return cell
       }
   }








   // MARK: Changes For iOS 13.0

extension MainViewController {

    func statusBarColorChange() {

  if #available(iOS 13.0, *) {

      let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
      statusBar.backgroundColor = .gray
          statusBar.tag = 100
      UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)

  } else {

          let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
          statusBar?.backgroundColor = .gray

      }
  }
  
}
