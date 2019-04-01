//
//  CmdArgs.swift
//  Targuil1
//
//  Created by meir Benchimol on 01/04/2019.
//  Copyright © 2019 meir Benchimol & Nethanel Cohen-Solal. All rights reserved.
//

import Foundation
class CmdArgs: Cmd {
    var arg1:ArgType
    var arg2:Int
    
    // methode
    
    func push_base ()->String{
        var res = ""
        res.append("@SP\n")
        res.append("A=M\n")
        res.append("M=D\n")
        res.append("@SP\n")
        res.append("M=M+1\n")
        
        return res
    }
    
    func pop_base_begin()->String{
        var res = "@SP\n"
        res.append("A=M-1\n")
        res.append("D=M\n")
        return res
    }
    
    func pop_base_end()->String{
        var res = "M=D\n"
        res.append("@SP\n")
        res.append("M=M-1\n")
        return res
    }
    
    //
    
    public override func translateToASM() -> String {
        
        switch name {
        case .push:
            switch arg1 {
            case .constant:
                return translateToASM_PUSH_CONSTANT()
            case .local:
                return translateToASM_PUSH(key: "LCL")
            case .argument:
                return translateToASM_PUSH_ARGUMENT()
            case .that:
                return translateToASM_PUSH(key: "THAT")
            case .this:
                return translateToASM_PUSH(key: "THIS")
            case .pointer:
                <#code#>
            case .aStatic:
                <#code#>
            case .temp:
                <#code#>
            default:
                print("eror")
            }
        case .pop:
            switch arg1 {
            case .local:
                return translateToASM_POP(key: "LCL")
            case .argument:
                return translateToASM_POP(key: "ARG")
            case .that:
                return translateToASM_POP(key: "THAT")
            case .this:
                return translateToASM_POP(key: "THIS")
            case .pointer:
                <#code#>
            case .aStatic:
                <#code#>
            case .temp:
                <#code#>
            default:
                print("eror")
            }
        default:
            print("eror")
        }
        
    }
    
    init(aName:Command , aArg1:ArgType , aArg2:Int) {
        name = aName
        arg1 = aArg1
        arg2 = aArg2
    }
    // METHODE FOR PUSH
    private func translateToASM_PUSH_CONSTANT()->String{
        var translate = "@\(arg2) \n"
        translate.append("D=A\n")
        translate.append(push_base())
        return translate
    }
    
    private func translateToASM_PUSH(key:String)->String{
        var translate = "@\(arg2) \n"
        translate.append("D=A\n")
        translate.append("@\(key)\n")
        translate.append("A=M+D")
        translate.append("D=M")
        translate.append(push_base())
        return translate
    }
    
    private func translateToASM_PUSH_ARGUMENT()->String{
        var translate = "@ARG\n"
        translate.append("D=A\n")
        translate.append("@\(arg2)\n")
        translate.append("D=D+A")
        translate.append("A=D")
        translate.append("@SP")
        translate.append("M=D")
        translate.append("@SP")
        translate.append("M=M+1")
        return translate
    }
    
    private func translateToASM_PUSH_THAT()->String{
        var translate = "@\(arg2) \n"
        translate.append("D=A\n")
        translate.append("@THAT\n")
        translate.append("A=M+D")
        translate.append("D=M")
        translate.append(push_base())
        return translate
    }

    
    
    
    // METHODE FOR POP
    
   
    private func translateToASM_POP(key:String)->String{
        var translate = pop_base_begin()
        translate.append("@\(key)\n")
        translate.append("A=M\n")
        for _ in 1...arg2 {
            translate.append("A=A+1")
        }
        translate.append(pop_base_end())
        return translate
    }
    
    
    
    
    
}
