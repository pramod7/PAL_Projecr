//
//  Canvas.swift
//  Planner
//
//  Created by Andrea Clare Lam on 02/09/2020.
//  Copyright © 2020 Andrea Clare Lam. All rights reserved.
//
// Database for notes/drawings


import Foundation
import SQLite3
import UIKit

//MARK: - Canvas Model
struct Canvas {
    let id: Int
    //    var date: Date
    var drawindex: Int
    var canvasDrawing: Data
    var worksheetID: Int
    var teacherName:String
    var uniduqId: Int
    var canvasMetadata: String
    var isoffline: Int
    var subjectId: Int
    var teacherId: String
    var subCategoryId: Int
    var assigntype: Int
    var eraser: Int
    var spellChecker: Int
    var instrcution: String
    var Voiceinstrcution: String
    var worksheetName: String
}

//MARK: - Canvas Class
class WorksheetDBManager {
    
    //MARK: - Variable
    var database: OpaquePointer?
    static let shared = WorksheetDBManager()
    
    //MARK: - Create DB and Connect to it
    func connect() {
        
        // if database already exists
        if database != nil {
            return
        }
        
        // Create path and db in user's device
        do {
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("drawings.sqlite3")
            
            print("DATABASE PATH: \(databaseURL.path)")
            
            if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
                print("Could not open database")
            }
//id integer primary key autoincrement
            if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS drawings (id integer primary key autoincrement, drawindex INTEGER, canvasDrawing BLOB, worksheetID INTEGER, teacherName TEXT, canvasMetadata BLOB, isoffline INTEGER, subjectId INTEGER, teacherId TEXT, subCategoryId INTEGER, assigntype INTEGER, eraser INTEGER, spellChecker INTEGER, uniduqId INTEGER, instruction TEXT,voiceInstrcution TEXT,  worksheetName TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error creating table: \(errmsg)")
            }
        }
        catch _ {
            print("Could not create database")
        }
        
    }
    
    //MARK: - Function to create new drawing / return row id of newly inserted row
    func insert(drawindex: Int, canvasDrawing: Data, worksheetID :Int,teacherName :String,canvasMetadata: String,isoffline :Int, uniduqId :Int, subjectId :Int,teacherId : String, subCategoryId :Int,assigntype :Int,eraser :Int,spellChecker :Int, instruction :String,voiceInstrcution :String, worksheetName :String) -> Int {
        
        connect()
        var statement: OpaquePointer? = nil
        let query = "INSERT INTO drawings (drawindex, canvasDrawing, worksheetID, teacherName, canvasMetadata, isoffline, subjectId, teacherId, subCategoryId, assigntype, eraser, spellChecker, uniduqId, instruction,voiceInstrcution, worksheetName) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)"
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) != SQLITE_OK {
            print("Could not create (insert) query")
            return -1
        }
        
        sqlite3_bind_int(statement, 1, Int32(drawindex))
        
        if canvasDrawing.withUnsafeBytes({ canvasBuffer -> Int32 in
            sqlite3_bind_blob(statement, 2, canvasBuffer.baseAddress, Int32(canvasBuffer.count), nil)
        }) == SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Canvas Drawing Saved Successfully: \(errmsg)")
        }
        
        sqlite3_bind_int(statement, 3, Int32(worksheetID))
        
        let tempTeacherName = teacherName as NSString
        if sqlite3_bind_text(statement, 4, tempTeacherName.utf8String, -1, nil) == SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("teacherName saved: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 5, canvasMetadata, -1, nil) == SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("canvas metadata saved: \(errmsg)")
        }
        
        sqlite3_bind_int(statement, 6, Int32(isoffline))
        
        sqlite3_bind_int(statement, 7, Int32(subjectId))
        
        let tempTeacherId = teacherId as NSString
        if sqlite3_bind_text(statement, 8, tempTeacherId.utf8String, -1, nil) == SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("teacherId saved: \(errmsg)")
        }
        
        sqlite3_bind_int(statement, 9, Int32(subCategoryId))
        sqlite3_bind_int(statement, 10, Int32(assigntype))
        sqlite3_bind_int(statement, 11, Int32(eraser))
        sqlite3_bind_int(statement, 12, Int32(spellChecker))
        sqlite3_bind_int(statement, 13, Int32(uniduqId))
        
        let tempinstruction = instruction as NSString
        if sqlite3_bind_text(statement, 14, tempinstruction.utf8String, -1, nil) == SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Instruction Saved: \(errmsg)")
        }
        let tempWorksSheet = worksheetName as NSString
        if sqlite3_bind_text(statement, 15, tempWorksSheet.utf8String, -1, nil) == SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Worksheet name Saved: \(errmsg)")
        }
        
        let errorMessage = sqlite3_errmsg(database).map { String(cString: $0) } ?? "Unknown error"
        print("Query apply messages: \(errorMessage)")
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure inserting query: \(errmsg)")
            return -1
        }
        sqlite3_finalize(statement)
        statement = nil
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    //MARK: - Function to save drawing to database
    func UPDATE(canvas: Canvas) {
        
        connect()
        let drawingData = canvas.canvasDrawing
        
        var statement: OpaquePointer? = nil
        let query = "UPDATE drawings SET drawindex = ?, canvasDrawing = ?,worksheetID = ?,teacherName = ?,canvasMetadata = ?,isoffline = ?,subjectId = ?, teacherId = ?, subCategoryId = ?, assigntype = ?, eraser = ?, spellChecker = ?, uniduqId = ?, instruction = ?,voiceInstrcution = ?, worksheetName = ? WHERE uniduqId = \(canvas.uniduqId)"
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Could not create (update) query: \(errmsg)")
            
        }
        sqlite3_bind_int(statement, 1, Int32(canvas.drawindex))
        
        if drawingData.withUnsafeBytes({ canvasBuffer -> Int32 in
            sqlite3_bind_blob(statement, 2, canvasBuffer.baseAddress, Int32(canvasBuffer.count), nil)
        }) == SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Canvas Saved: \(errmsg)")
        }
        
        sqlite3_bind_int(statement, 3, Int32(canvas.worksheetID))
        
        let tempTeacherName = canvas.teacherName as NSString
        if sqlite3_bind_text(statement, 4, tempTeacherName.utf8String, -1, nil) == SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Updated teacherName: \(errmsg)")
        }
        
        let tempCanvas = canvas.canvasMetadata as NSString
        if sqlite3_bind_text(statement, 5, tempCanvas.utf8String, -1, nil) == SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Updated canvas MetaData: \(errmsg)")
        }
        sqlite3_bind_int(statement, 6, Int32(canvas.isoffline))
        
        sqlite3_bind_int(statement, 7, Int32(canvas.subjectId))
        
        let tempTeacherId = canvas.teacherId as NSString
        if sqlite3_bind_text(statement, 8, tempTeacherId.utf8String, -1, nil) == SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Updated teacherId: \(errmsg)")
        }
        
        sqlite3_bind_int(statement, 9, Int32(canvas.subCategoryId))
        sqlite3_bind_int(statement, 10, Int32(canvas.assigntype))
        sqlite3_bind_int(statement, 11, Int32(canvas.eraser))
        sqlite3_bind_int(statement, 12, Int32(canvas.spellChecker))
        sqlite3_bind_int(statement, 13, Int32(canvas.uniduqId))
        
        let tempInstruction = canvas.instrcution as NSString
        if sqlite3_bind_text(statement, 14, tempInstruction.utf8String, -1, nil) == SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Updated Instruction: \(errmsg)")
        }
        
        let tempVoiceinstrcution = canvas.Voiceinstrcution as NSString
        if sqlite3_bind_text(statement, 15, tempVoiceinstrcution.utf8String, -1, nil) == SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Updated Instruction: \(errmsg)")
        }
        
        let tempWorksSheet = canvas.worksheetName as NSString
        if sqlite3_bind_text(statement, 16, tempWorksSheet.utf8String, -1, nil) == SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Worksheet name saved: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure uodate query: \(errmsg)")
        }
        let errorMessage = sqlite3_errmsg(database).map { String(cString: $0) } ?? "Unknown error"
        print("failure preparing UPDATE statement: \(errorMessage)")
        sqlite3_finalize(statement)
        statement = nil
    }
    
    //MARK: - update data in DB
    func updateOffilieStatus(canvas: Canvas) {
        
        connect()
        
        var statement: OpaquePointer? = nil
        let query = "UPDATE drawings SET isoffline = ? WHERE uniduqId = ?"
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) != SQLITE_OK {
            print("Could not create (update) query")
        }
        
        sqlite3_bind_int(statement, 1, Int32(canvas.isoffline))
        sqlite3_bind_int(statement, 2, Int32(canvas.uniduqId))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure update query: \(errmsg)")
        }
        let errorMessage = sqlite3_errmsg(database).map { String(cString: $0) } ?? "Unknown error"
        print("failure preparing UPDATE statement: \(errorMessage)")
        sqlite3_finalize(statement)
        statement = nil
    }
    
    //MARK: - Function to delete drawing
    func delete(drawindex: Int) {
        connect()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM drawings WHERE worksheetID = ?", -1, &statement, nil) != SQLITE_OK {
            print("Could not create (delete) query")
        }
        sqlite3_bind_int(statement, 1, Int32(drawindex))
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure delete query: \(errmsg)")
        }
        sqlite3_finalize(statement)
        statement = nil
    }
    
    func truncateDB() {
        connect()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM drawings", -1, &statement, nil) != SQLITE_OK {
            print("Could not create (delete) query")
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure delete query: \(errmsg)")
        }
        sqlite3_finalize(statement)
        statement = nil
    }
    
    
    //MARK: - Function to check if canvas for a certain date is already in the database, if exists, return canvas
    func check(drawindex: Int) -> [Canvas] {
        self.connect()
        
        var result: [Canvas] = []
        // this is at start of row
        var statement: OpaquePointer!//rowid,
        
        let strQuery = "SELECT id, drawindex, canvasDrawing, worksheetID, teacherName ,canvasMetadata, isoffline, subjectId, teacherId, subCategoryId, assigntype, eraser, spellChecker, uniduqId, instruction,voiceInstrcution, worksheetName FROM drawings WHERE uniduqId = \(drawindex)"
        
        if sqlite3_prepare_v2(database, strQuery, -1, &statement, nil) == SQLITE_OK {
//            while sqlite3_step(statement) != SQLITE_ROW {
//                let errmsg = String(cString: sqlite3_errmsg(database)!)
//                print("failure delete query: \(errmsg)")
//            }
            while sqlite3_step(statement) == SQLITE_ROW {
                
                let id = sqlite3_column_int64(statement, 0)
                print("Id = \(id)", terminator: "")
                
                sqlite3_bind_int(statement, 1, Int32(drawindex))
                if sqlite3_column_blob(statement, 2) != nil {
                    
                    // Convert UnsafeRawPointer into data
                    var drawing = Data()
                    if let tempDraw = sqlite3_column_blob(statement, 2){
                        let drawingLength = Int(sqlite3_column_bytes(statement, 2))
                        drawing = Data(bytes: tempDraw, count: drawingLength)
                    }
                    //                let drawingPtr = sqlite3_column_blob(statement, 2)!
                    //                let drawingLength = Int(sqlite3_column_bytes(statement, 2))
                    //                let drawing = Data(bytes: drawingPtr, count: drawingLength)
                    let workid = Int(sqlite3_column_int(statement, 3))
                    let teacherName = String(cString: sqlite3_column_text(statement, 4))
                    let MetaDataImage = String(cString: sqlite3_column_text(statement, 5))
                    let isoffline = Int(sqlite3_column_int(statement, 6))
                    let subjectId = Int(sqlite3_column_int(statement, 7))
                    let teacherID = String(cString: sqlite3_column_text(statement, 8))
                    let subCategoryId = Int(sqlite3_column_int(statement, 9))
                    let assigntype = Int(sqlite3_column_int(statement, 10))
                    let eraser = Int(sqlite3_column_int(statement, 11))
                    let spellChecker = Int(sqlite3_column_int(statement, 12))
                    let uniduqId = Int(sqlite3_column_int(statement, 13))
                    let tempInstruction = String(cString: sqlite3_column_text(statement, 14))
                    let tempVoiceinstrcution = String(cString: sqlite3_column_text(statement, 15))
                    var tempWorksheet = String()//String(cString: sqlite3_column_text(statement, 15))
                    if let cString = sqlite3_column_text(statement, 16) {
                        tempWorksheet = String(cString: cString)
                        print("worksheet Name = \(tempWorksheet)")
                    }
                    
                    result.append(Canvas(id: Int(sqlite3_column_int(statement, 0)), drawindex: drawindex, canvasDrawing: drawing, worksheetID: workid, teacherName: teacherName, uniduqId: uniduqId, canvasMetadata: MetaDataImage, isoffline: isoffline,subjectId : subjectId,teacherId : teacherID,subCategoryId : subCategoryId,assigntype: assigntype,eraser:eraser,spellChecker:spellChecker, instrcution: tempInstruction, Voiceinstrcution: tempVoiceinstrcution, worksheetName: tempWorksheet))
                    
                }
            }
        }
        else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(statement)
        statement = nil
        return result
    }
    
    //MARK: - get DB data
    func GetData() -> [Canvas] {
        connect()
        let queryStatementString = "SELECT * FROM drawings"
        var statement: OpaquePointer!
        var result: [Canvas] = []
        
        if sqlite3_prepare_v2(database, queryStatementString, -1, &statement, nil) == SQLITE_OK {
            
            let drawindex =  sqlite3_bind_int(statement, 1, Int32(0))
            while sqlite3_step(statement) == SQLITE_ROW {
                
                let id = sqlite3_column_int64(statement, 0)
                print("Id = \(id)", terminator: "")
                
                sqlite3_bind_int(statement, 1, Int32(drawindex))
                if sqlite3_column_blob(statement, 2) != nil {
                    
                    // Convert UnsafeRawPointer into data
                    var drawing = Data()
                    if let tempDraw = sqlite3_column_blob(statement, 2){
                        let drawingLength = Int(sqlite3_column_bytes(statement, 2))
                        drawing = Data(bytes: tempDraw, count: drawingLength)
                    }
                    let workid = Int(sqlite3_column_int(statement, 3))
                    let teacherName = String(cString: sqlite3_column_text(statement, 4))
                    let MetaDataImage = String(cString: sqlite3_column_text(statement, 5))
                    let isoffline = Int(sqlite3_column_int(statement, 6))
                    let subjectId = Int(sqlite3_column_int(statement, 7))
                    let teacherID = String(cString: sqlite3_column_text(statement, 8))
                    let subCategoryId = Int(sqlite3_column_int(statement, 9))
                    let assigntype = Int(sqlite3_column_int(statement, 10))
                    let eraser = Int(sqlite3_column_int(statement, 11))
                    let spellChecker = Int(sqlite3_column_int(statement, 12))
                    let uniduqId = Int(sqlite3_column_int(statement, 13))
                    let tempInstruction = String(cString: sqlite3_column_text(statement, 14))
                    let tempVoiceinstrcution = String(cString: sqlite3_column_text(statement, 15))
                    var tempWorksheet = String()//String(cString: sqlite3_column_text(statement, 15))
                    if let cString = sqlite3_column_text(statement, 16) {
                        tempWorksheet = String(cString: cString)
                        print("Worksheet Name = \(tempWorksheet)")
                    } 
                    result.append(Canvas(id: Int(sqlite3_column_int(statement, 0)), drawindex: Int(drawindex), canvasDrawing: drawing, worksheetID: workid, teacherName: teacherName, uniduqId: uniduqId, canvasMetadata: MetaDataImage, isoffline: isoffline,subjectId : subjectId,teacherId : teacherID,subCategoryId : subCategoryId,assigntype: assigntype,eraser:eraser,spellChecker:spellChecker, instrcution: tempInstruction, Voiceinstrcution: tempVoiceinstrcution, worksheetName: tempWorksheet))
                    
                }
            }
        }
        else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(statement)
        statement = nil
        return result
    }
}
