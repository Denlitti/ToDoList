//
//  TasksStorage.swift
//  To-Do Manager
//
//  Created by Данил Литти on 23.05.2022.
//

import Foundation

protocol TasksStorageProtocol{
    func loadTasks() -> [TaskProtocol]
    func saveTasks(_ tasks: [TaskProtocol])
}

class TasksStorage:TasksStorageProtocol {
    func loadTasks() -> [TaskProtocol] {
        //временная реализация возращающая тестовую коллекцию задач
        let testTasks: [TaskProtocol] = [
            Task(title: "Купить хлеб", type:.important, status:.planned),
            Task(title: "Погладить кота", type: .normal, status: .completed),
            Task(title: "Отдать долг Арнольду", type: .normal, status: .planned),
            Task(title: "купить пылесос", type: .normal, status: .planned),
            Task(title: "подарить цветы", type: .normal, status: .planned),
            Task(title: "позвонить родителям", type: .normal, status: .planned),
            Task(title: "Пригласить на вечеринку Дольфа, Джеки, Леонардо, Уилла и Брюса", type: .important, status: .planned)
        ]
        return testTasks
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
        //
    }
    
}
