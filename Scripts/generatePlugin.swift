//
//  generatePlugin.swift
//  
//
//  Created by yongbeomkwak on 2/17/24.
//

import Foundation

let fileManager = FileManager.default
let currentPath = "./"

/// 폴더 생성
func makeDirectory(_ path: String) {
    
    do {
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
    } catch {
        fatalError("❌ failed to create directory: \(path)")
    }
    
}

/// 파일 생성
func writeContentInFile(path: String, content: String) {
    let fileURL = URL(fileURLWithPath: path)
    let data = Data(content.utf8)

    do {
        try data.write(to: fileURL)
    } catch {
        fatalError("❌ failed to create File: \(path)")
    }
    
}

// 파일 업데이트 
func updateFileContent(
    filePath: String,
    finding findingString: String,
    inserting insertString: String
) {
    let fileURL = URL(fileURLWithPath: filePath)
    guard let readHandle = try? FileHandle(forReadingFrom: fileURL) else {
        fatalError("❌ Failed to find \(filePath)")
    }
    guard let readData = try? readHandle.readToEnd() else {
        fatalError("❌ Failed to find \(filePath)")
    }
    try? readHandle.close()

    guard var fileString = String(data: readData, encoding: .utf8) else { fatalError() }
    fileString.insert(contentsOf: insertString, at: fileString.range(of: findingString)?.upperBound ?? fileString.endIndex)

    guard let writeHandle = try? FileHandle(forWritingTo: fileURL) else {
        fatalError("❌ Failed to find \(filePath)")
    }
    writeHandle.seek(toFileOffset: 0)
    try? writeHandle.write(contentsOf: Data(fileString.utf8))
    try? writeHandle.close()
}


/// Plugins.swift 파일 생성 
func makePluginSwift(_ plugin: String) {
    
    let prefix = plugin.prefix(1).lowercased()

    let tmp = plugin.dropFirst()
    
    let variableString = String(prefix) + tmp

    print("VA: \(variableString)")
    let pluginSwift = """
import ProjectDescription

let \(variableString)Plugin = Plugin(name: "\(plugin)Plugin")

"""
    
    writeContentInFile(path: currentPath+"Plugin/\(plugin)Plugin/Plugin.swift", content: pluginSwift)
    print("TOO: \(variableString)")
}

/// 
func generatePlugin(_ plugin: String) {
    
    let helperPath : String = currentPath+"Plugin/\(plugin)Plugin/ProjectDescriptionHelpers"
    let emptyFileContent : String = """
"Empty"
"""
    
    makeDirectory(currentPath+"Plugin/\(plugin)Plugin")
    makePluginSwift(plugin)
    makeDirectory(helperPath)
    writeContentInFile(path: "\(helperPath)/empty.swift", content: emptyFileContent) // 더미 파일
    registerToConfig(plugin)
    
    
}





func registerToConfig(_ plugin: String) {

    let path = currentPath+"/Tuist/Config.swift"
    let content = """

        .local(path: .relativeToRoot("Plugin/\(plugin)Plugin")),
"""


    updateFileContent(filePath: path, finding: "[",inserting: content)
}


// ✅ Entry Point

print("Enter plugin Name\n⚠️  Do not include Plugin\nex) input: Dependency")
let plugin = readLine()!

generatePlugin(plugin)
print("------------------------------------------------------------------------------------------------------------------------")
print("Plugin Name: \(plugin)")
print("Processing...")
print("------------------------------------------------------------------------------------------------------------------------")
print("✅  \(plugin)Plugin is created successfully!")

