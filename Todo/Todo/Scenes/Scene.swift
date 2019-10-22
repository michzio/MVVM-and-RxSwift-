//
//  Scene.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

enum Scene {
    case tasks(TasksViewModel)
    case editTask(EditTaskViewModel)
    case pushedEditTask(PushedEditTaskViewModel)
}
