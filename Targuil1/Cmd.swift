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
    
    private static var counterJumpLbl:Int = 0
    
    init(aName:Command) {
        name = aName
    }
    
    
    public  func translateToASM()->String{
        switch name {
        case .add:
            return translateToASM_ADD();
        case .sub:
            return translateToASM_SUB();
        case .eq:
            return translateToASM_EQ();
        case .lt:
            return translateToASM_LT()
        case .gt:
            return translateToASM_GT()
        case .neg:
            return translateToASM_NEG();
        case .and:
            return translateToASM_AND();
        case .or:
            return translateToASM_OR();
        case .not:
            return translateToASM_NOT();
        default:
            return "// Error trying to parse \(name) \n"
                }
    }
    
    
    
    private func translateToASM_ADD()->String{
        var translate = "// \(name) \n"
        translate.append("@SP \n")
        translate.append("A=M-1"+"\n")
        translate.append("D=M"+"\n")
        translate.append("A=A-1"+"\n")
        translate.append("M=D+M"+"\n")//4
        translate.append("@SP"+"\n")
        translate.append("M=M-1"+"\n")
        return translate
        
    }
    
    private func translateToASM_SUB()->String{
        //Just replace the ADD by on sequence in the subb
        var transaltedArray = translateToASM_ADD().split(separator: "\n")
        transaltedArray[4] = "M=D-M"
        return transaltedArray.joined(separator: "\n")
    }
    
    private func translateToASM_EQ()->String{
        //0 true - (-1) false
        //First we do sub to check if they are equal
        var translate = translateToASM_SUB().split(separator:"\n")
        translate[4]="D=D-M"
        translate.remove(at: 5)
        translate.remove(at: 6)
        
        translate.append("@IF_TRUE\(Cmd.counterJumpLbl)")
        translate.append("D;JEQ")
        translate.append("D=0") // They are equal so we need to put 0.
        //Label
        translate.append("@SP")
        translate.append("A=M-1")
        translate.append("A=A-1")
        translate.append("M=D")
    
        translate.append("@IF_FALSE\(Cmd.counterJumpLbl)")
        translate.append("0;JMP")
        translate.append("(IF_TRUE\(Cmd.counterJumpLbl))")
        translate.append("D=-1")//Not not equal
        //(same than label)
        translate.append("@SP")
        translate.append("A=M-1")
        translate.append("A=A-1")
        translate.append("M=D")
        
        translate.append("(IF_FALSE\(Cmd.counterJumpLbl)")
        translate.append("@SP")
        translate.append("M=M-1")

        //Increment the counter for labels
        Cmd.counterJumpLbl+=1
        
        return translate.joined(separator: "\n")
        
    }
    
    private func translateToASM_GT()->String{
        var translate = translateToASM_EQ().split(separator: "\n")
        translate[4]="D=M-D"//????
        translate[6]="D;JGT"
        return translate.joined(separator: "\n")
    }
    
    private func translateToASM_LT()->String{
        var translate = translateToASM_GT().split(separator: "\n")
        translate[6]="D;JLT"
        return translate.joined(separator: "\n")
    }
    
    
    private func translateToASM_AND()->String{
        var translate = translateToASM_ADD().split(separator: "\n");
        translate[4]="M=M&D"
        return translate.joined(separator: "\n")
        
    }
    
    private func translateToASM_OR()->String{
        var translate = translateToASM_ADD().split(separator: "\n");
        translate[4]="M=M|D"
        return translate.joined(separator: "\n")
        
    }
    
    private func translateToASM_NOT()->String{
        var translate = [String]()
        translate.append("// \(name)")
        translate.append("@SP")
        translate.append("A=M-1")
        translate.append("M=!M")
        return translate.joined(separator: "\n")
    }
    
    private func translateToASM_NEG()->String{
        var translate = [String]()
        translate.append("// \(name)")
        translate.append("@SP")
        translate.append("A=M-1")
        translate.append("D=M")
        translate.append("M=-D")
        return translate.joined(separator: "\n")
    }
    
}
