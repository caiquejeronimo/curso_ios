//
//  Student.swift
//  CadastroAlunos
//
//  Created by Aléo, Caique Jeronimo de Araújo on 23/10/26.
//

import SwiftUI

struct Student: Identifiable {
    let id = UUID()
    let name: String
    let grade1: Double
    let grade2: Double
    
    var average: Double {
        (grade1 + grade2) / 2
    }
    
    var status: String {
        average >= 7 ? "Aprovado" : "Reprovado"
    }
}
