//
//  ViewController.swift
//  ToDoApp
//
//  Created by Aman Verma on 09/02/23.
//

import UIKit
import RealmSwift

class Todo:Object{
    @Persisted  var title:String
    @Persisted  var body:String
    
    convenience init(title:String,body:String){
        self.init()
        self.title=title
        self.body=body
        
    }
}
/*
 class Todo{
     var title:String
     var body:String
     
     init(title:String,body:String){
         self.title=title
         self.body=body
         
     }
 }
 */
class ViewController: UIViewController {

 
    @IBOutlet weak var todoTableVIew: UITableView!
    var todoArray=[Todo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        // Do any additional setup after loading the view.
    }


    @IBAction func addTodoButtonTapped(_ sender: UIBarButtonItem) {

        todoConfiguration(isAdd: true, index: 0)
    }
}

extension ViewController{
    func configuration(){
        todoTableVIew.dataSource=self
        todoTableVIew.delegate=self
        todoTableVIew.register(UITableViewCell .self, forCellReuseIdentifier: "cell")
        todoArray=DataBaseHelper.shared.getAllTodo()
        
    }
    func todoConfiguration(isAdd:Bool,index:Int){
        var alertTitle="Add a Task"
        if(!isAdd){
            alertTitle="Update a Task"
        }
        let alertControl=UIAlertController(title: alertTitle, message: "Please Enter your Task", preferredStyle: .alert)
        let save=UIAlertAction(title: isAdd ? "Save" : "Update", style: .default){_ in
            if let title = alertControl.textFields?.first?.text,
               let body = alertControl.textFields?[1].text{
                let todo = Todo(title:title,body:body)
                if isAdd{
                    self.todoArray.append(todo)
                    DataBaseHelper.shared.saveTodo(todo:todo)
                }else{
//                    self.todoArray[index]=todo
                    DataBaseHelper.shared.updateTodo(oldTodo: self.todoArray[index], newTodo: todo)
                    
                }
                self.todoTableVIew.reloadData()
                
                print(title,body)
            }
        }
        let cancel=UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        alertControl.addAction(save)
        alertControl.addAction(cancel)
        alertControl.addTextField{titleField in
//            if isAdd{
//               titleField.placeholder="Enter Title"
//            }else{
//               titleField.placeholder=self.todoArray[index].title
//
//            }
            titleField.placeholder = isAdd ? "Enter Title" : self.todoArray[index].title
            
        }
        alertControl.addTextField{
            bodyField in
            bodyField.placeholder = isAdd ? "Enter Description" : self.todoArray[index].body
            
        }
        
        present(alertControl,animated: true )
        
    }
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell=tableView.dequeueReusableCell(withIdentifier: "cell") else{
            return UITableViewCell()
            
        }
        cell=UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text=todoArray[indexPath.row].title
        cell.detailTextLabel?.text=todoArray[indexPath.row].body
        return cell
    }



}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit=UIContextualAction(style: .normal, title: "Edit"){
            _,_,_ in
            self.todoConfiguration(isAdd: false, index: indexPath.row)
        }
        let delete=UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            DataBaseHelper.shared.deleteTodo(todo: self.todoArray[indexPath.row])
            self.todoArray.remove(at: indexPath.row)
            self.todoTableVIew.reloadData()
            
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit, delete])
        edit.backgroundColor = .systemMint
        return swipeConfiguration
    }
}


/*
 ADD
 //        let alertControl=UIAlertController(title: "Add a Task", message: "Please Enter your Task", preferredStyle: .alert)
 //        let save=UIAlertAction(title: "Save", style: .default){_ in
 //            if let title = alertControl.textFields?.first?.text,
 //               let body = alertControl.textFields?[1].text{
 //                let todo = Todo(title:title,body:body)
 //                self.todoArray.append(todo)
 //                self.todoTableVIew.reloadData()
 //
 //                print(title,body)
 //            }
 //        }
 //        let cancel=UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
 //        alertControl.addAction(save)
 //        alertControl.addAction(cancel)
 //        alertControl.addTextField{
 //            titleField in titleField.placeholder="Enter Title"
 //        }
 //        alertControl.addTextField{
 //            bodyField in bodyField.placeholder="Enter Description"
 //        }
 //
 //        present(alertControl,animated: true )
 */

/*
 Update
 
//            let alertControl=UIAlertController(title: "Update a Task", message: "Please Update your Task", preferredStyle: .alert)
//            let save=UIAlertAction(title: "Save", style: .default){_ in
//                if let title = alertControl.textFields?.first?.text,
//                   let body = alertControl.textFields?[1].text{
//                    let todo = Todo(title:title,body:body)
//                    self.todoArray[indexPath.row]=todo
//                    self.todoTableVIew.reloadData()
//
//                    print(title,body)
//                }
//            }
//            let cancel=UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
//            alertControl.addAction(save)
//            alertControl.addAction(cancel)
//            alertControl.addTextField{
//                titleField in titleField.placeholder=self.todoArray[indexPath.row].title
//
//            }
//            alertControl.addTextField{
//                bodyField in bodyField.placeholder=self.todoArray[indexPath.row].body
//            }
//
//            self.present(alertControl,animated: true )

 */
