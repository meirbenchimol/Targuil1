//
//  Cmd.swift
//  Targuil1
//
//  Created by meir Benchimol on 01/04/2019.
//  Copyright © 2019 meir Benchimol & Nethanel Cohen-Solal. All rights reserved.
//

import Foundation
class Cmd  {
    
    internal var name : Command
    
    public  func translateToASM()->String{
        switch name {
        case .add:
            return translateToASM_ADD();
        case .sub:
            return translateToASM_ADD();
        case .eq:
            return translateToASM_ADD();
        case .lt:
            return translateToASM_ADD();
        case .gt:
            return translateToASM_ADD();
        case .neg:
            return translateToASM_ADD();
        case .and:
            return translateToASM_ADD();
        case .or:
            return translateToASM_ADD();
        case .not:
            return translateToASM_ADD();
        default:
            return "error"
                }
    }
    
    init(aName:Command) {
        name = aName
    }
    
    private func translateToASM_ADD()->String{
        var translate = "@SP \n"
        translate.append("A=M-1"+"\n")
        translate.append("D=M"+"\n")
        translate.append("A=A-1"+"\n")
        translate.append("M=D+M"+"\n")
        translate.append("@SP"+"\n")
        translate.append("M=M-1"+"\n")
        return translate
        
    }
}
