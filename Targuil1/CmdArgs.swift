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
                if arg2 == 1{
                    return translateToASM_PUSH2(key: "THAT")
                }else if arg2 == 0{
                    return translateToASM_PUSH2(key: "THIS")
                }else {
                    return "error"
                }
            //case .aStatic:
                
            case .temp:
                return translateToASM_PUSH2(key: String(5+arg2))
            default:
                return "error"
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
                if arg2 == 1{
                    return translateToASM_POP2(key: "THAT")
                }else if arg2 == 0{
                    return translateToASM_POP2(key: "THIS")
                }else {
                    return "error"
                }
            //case .aStatic:
                
            case .temp:
                return translateToASM_POP2(key: String(5+arg2))
            default:
                return "error"
            }
        default:
            return "error"
        }
        
    }
    
    init(aName:Command , aArg1:ArgType , aArg2:Int) {
        arg1 = aArg1
        arg2 = aArg2
        super.init(aName:aName)
    }
    
    
    // METHODE FOR PUSH
    private func translateToASM_PUSH_CONSTANT()->String{
        var translate = "@\(arg2) \n"
        translate.append("D=A\n")
        translate.append(push_base())
        return translate
    }
    // for local+that+this
    private func translateToASM_PUSH(key:String)->String{
        var translate = "@\(arg2) \n"
        translate.append("D=A\n")
        translate.append("@\(key)\n")
        translate.append("A=M+D\n")
        translate.append("D=M\n")
        translate.append(push_base())
        return translate
    }
    
    private func translateToASM_PUSH_ARGUMENT()->String{
        var translate = "@ARG\n"
        translate.append("D=A\n")
        translate.append("@\(arg2)\n")
        translate.append("D=D+A\n")
        translate.append("A=D\n")
        translate.append("@SP\n")
        translate.append("M=D\n")
        translate.append("@SP\n")
        translate.append("M=M+1\n")
        return translate
    }

    
    // for pointer+temp
    private func translateToASM_PUSH2(key:String)->String{
        var translate = "@\(key)\n"
        translate.append("D=M\n")
        translate.append(push_base())
        return translate
    }
    
    
    // METHODE FOR POP
    
   // for local+argument+that+this
    private func translateToASM_POP(key:String)->String{
        var translate = pop_base_begin()
        translate.append("@\(key)\n")
        translate.append("A=M\n")
        for _ in 1...arg2 {
            translate.append("A=A+1\n")
        }
        translate.append(pop_base_end())
        return translate
    }
    
    // for pointer + temp
    private func translateToASM_POP2(key:String)->String{
        var translate = pop_base_begin()
        translate.append("@\(key)\n")
        translate.append(pop_base_end())
        return translate
    }
    
    
    
    
}
