//
//  Enums.swift
//  Targuil1
//
//  Created by meir Benchimol on 01/04/2019.
//  Copyright © 2019 meir Benchimol & Nethanel Cohen-Solal. All rights reserved.
//

import Foundation

enum Command {case add,sub,neg,eq,lt,gt,and,or,not,push,pop}
enum ArgType {case constant,local,argument,that,this,pointer,aStatic,temp}
