//
//  Task Task TaskListController.swift
//  To-Do Manager
//
//  Created by Данил Литти on 23.05.2022.
//

import UIKit

class TaskListController: UITableViewController {

   //хранилище задач
    var tasksStorage: TasksStorageProtocol = TasksStorage()
    
    // коллекция задач
    var tasks: [TaskPriority:[TaskProtocol]] = [:] {
        didSet {
        for (tasksGroupPriority, tasksGroup) in tasks { tasks[tasksGroupPriority] = tasksGroup.sorted{ task1, task2 in
            let task1position = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
            let task2position = tasksStatusPosition.firstIndex(of: task2.status) ?? 0
            return task1position < task2position }
            }
            
        }
    }
    
    
    // порядок отображения секций по типам
    // индекс в массиве соответствует индексу секции в таблице
    var sectionsTypesPosition: [TaskPriority] = [.important, .normal]
    
    // порядок отображения задач по их статусу
    var tasksStatusPosition: [TaskStatus] = [.planned, .completed]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //загрузка задач
        loadTasks()
        
        // кнопка активации режима редактирования
        navigationItem.leftBarButtonItem = editButtonItem
    }
    private func loadTasks() {
        ///подготовка колекции с задачами
        ///будем использовать только те задчачи для которых определена секция в таблице
        
        sectionsTypesPosition.forEach { taskType in tasks[taskType] = []
        }
        // загрузка и разбор задач из хранилища
        tasksStorage.loadTasks().forEach { task in tasks[task.type]?.append(task) }
        
        // сортировка списка задач
//        for (tasksGroupPriority, tasksGroup) in tasks {
//        tasks[tasksGroupPriority] = tasksGroup.sorted { task1, task2 in
//        let task1position = tasksStatusPosition.firstIndex(of: task1.status)
//        ?? 0
//        let task2position = tasksStatusPosition.firstIndex(of: task2.status)
//        ?? 0
//        return task1position < task2position
//        }
//      }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // определяем приоритет задач, соответствующий текущей секции
        let taskType = sectionsTypesPosition[section]
        guard let currentTasksType = tasks[taskType] else {
            return 0
        }
        return currentTasksType.count
    }
    // ячейка для строки таблицы
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return getConfiguredTaskCell_constraints(for: indexPath)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var title: String?
    let tasksType = sectionsTypesPosition[section]
    if tasksType == .important {
    title = "Важные"
    } else if tasksType == .normal {
    title = "Текущие" }
    return title }
    
    
    // ячейка на основе ограничений
    private func getConfiguredTaskCell_constraints(for indexPath: IndexPath) -> UITableViewCell {
    
        
    // загружаем прототип ячейки по идентификатору
    let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        
    // получаем данные о задаче, которую необходимо вывести в ячейке
    let taskType = sectionsTypesPosition[indexPath.section]
    guard let currentTask = tasks[taskType]?[indexPath.row] else {
    return cell }
        
    // текстовая метка символа
    let symbolLabel = cell.viewWithTag(1) as? UILabel
        
    // текстовая метка названия задачи
    let textLabel = cell.viewWithTag(2) as? UILabel
        
    // изменяем символ в ячейке
    symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        
    // изменяем текст в ячейке
    textLabel?.text = currentTask.title
        // изменяем цвет текста и символа
    if currentTask.status == .planned {
    textLabel?.textColor = .black
    symbolLabel?.textColor = .black } else {
    textLabel?.textColor = .lightGray
    symbolLabel?.textColor = .lightGray }
    return cell
        
    }
    // возвращаем символ для соответствующего типа задачи
    private func getSymbolForTask(with status: TaskStatus) -> String {
        
    var resultSymbol: String
    if status == .planned {
        
    resultSymbol = "\u{25CB}"
    } else if status == .completed {
        
    resultSymbol = "\u{25C9}" } else {
        
    resultSymbol = "" }
    return resultSymbol }

    
    // ячейка на основе стека
    private func getConfiguredTaskCell_stack(for indexPath: IndexPath) -> UITableViewCell {
    
        // загружаем прототип ячейки по идентификатору
    let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskCell
    
        // получаем данные о задаче, которые необходимо вывести в ячейке
    let taskType = sectionsTypesPosition[indexPath.section]
    guard let currentTask = tasks[taskType]?[indexPath.row] else {
    return cell }
    
        // изменяем текст в ячейке
    cell.title.text = currentTask.title
    
        // изменяем символ в ячейке
    cell.symbol.text = getSymbolForTask(with: currentTask.status)
    
        // изменяем цвет текста
    if currentTask.status == .planned {
    cell.title.textColor = .black
    cell.symbol.textColor = .black } else {
    cell.title.textColor = .lightGray
    cell.symbol.textColor = .lightGray
    }
    return cell }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 1. Проверяем существование задачи
    let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
    return
        }
    // 2. Убеждаемся, что задача не является выполненной
        
    guard tasks[taskType]![indexPath.row].status == .planned else {
    // снимаем выделение со строки
        tableView.deselectRow(at: indexPath, animated: true)
        return
    }
    // 3. Отмечаем задачу как выполненную
        tasks[taskType]![indexPath.row].status = .completed
    // 4. Перезагружаем секцию таблицы
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section),
    with: .automatic)
        
    }
    override func tableView (_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    // получаем данные о задаче, которую необходимо перевести в статус "за- планирована"
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
        return nil
    }
    // проверяем, что задача имеет статус "выполнено"
    guard tasks[taskType]![indexPath.row].status == .completed else {
        return nil
    }
    // создаем действие для изменения статуса
    let actionSwipeInstance = UIContextualAction(style: .normal, title: "Не выполнена") { _,_,_ in
    self.tasks[taskType]![indexPath.row].status = .planned
    self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    // возвращаем настроенный объект
        return UISwipeActionsConfiguration(actions: [actionSwipeInstance])
    }

}


