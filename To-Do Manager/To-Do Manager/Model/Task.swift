//
//  Task.swift
//  To-Do Manager
//
//  Created by Данил Литти on 23.05.2022.
//

import Foundation

protocol TaskProtocol {
    
    var title: String {get set}
    var type: TaskPriority{get set}
    var status: TaskStatus{get set}
}

// тип задачи
enum TaskPriority {
// текущая
    case normal
// важная
case important
}
// состояние задачи
enum TaskStatus: Int {
// запланированная
    case planned
// завершенная
    case completed
}

// сущность "Задача"
struct Task: TaskProtocol {
    var title: String
    var type: TaskPriority
    var status: TaskStatus
}
