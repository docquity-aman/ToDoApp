//
//  DatabaseHelper.swift
//  ToDoApp
//
//  Created by Aman Verma on 09/02/23.
//

import UIKit
import RealmSwift

class DataBaseHelper{
    static let shared = DataBaseHelper()
    
    private var realm = try! Realm()
    
    func getDatabaseURL()->URL?{
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    func saveTodo(todo:Todo){
        try! realm.write{
            realm.add(todo)
        }
        
    }
    
    func getAllTodo()->[Todo]{
        return Array(realm.objects(Todo.self))
        
    }
    
    func deleteTodo(todo:Todo){
        try! realm.write{
            realm.delete(todo)
        }
    }
    
    func updateTodo(oldTodo:Todo,newTodo:Todo){
        try! realm.write{
            oldTodo.title=newTodo.title
            oldTodo.body=newTodo.body
        }
    }
}
