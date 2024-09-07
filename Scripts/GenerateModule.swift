#!/usr/bin/swift
import Foundation

func handleSIGINT(_ signal: Int32) {
    exit(0)
}

signal(SIGINT, handleSIGINT)

enum LayerType: String {
    case feature = "Feature"
    case domain = "Domain"
    @available(*, deprecated, message: "Service 레이어는 미래에 지워집니다. Service 레이어의 내용은 Domain 레이어로 이전될 예정입니다.")
    case service = "Service"
    case module = "Module"
    case userInterface = "UserInterface"
}

enum MicroTargetType: String {
    case interface = "Interface"
    case sources = ""
    case testing = "Testing"
    case unitTest = "Tests"
    case uiTest = "UITests"
    case demo = "Demo"
}

let fileManager = FileManager.default
let currentPath = "./"
let bash = Bash()

func registerModuleDependency() {
    registerModulePaths()
    makeProjectDirectory()

    let layerPrefix = layer.rawValue.lowercased()
    let moduleEnum = ".\(layerPrefix)(.\(moduleName))"
    var targetString = "[\n"
    if hasInterface {
        makeScaffold(target: .interface)
        targetString += "\(tab(2)).interface(module: \(moduleEnum)),\n"
    }
    targetString += "\(tab(2)).implements(module: \(moduleEnum)"
    if hasInterface {
        targetString += ", dependencies: [\n\(tab(3)).\(layerPrefix)(target: .\(moduleName), type: .interface)\n\(tab(2))])"
    } else {
        targetString += ")"
    }
    if hasTesting {
        makeScaffold(target: .testing)
        let interfaceDependency = ".\(layerPrefix)(target: .\(moduleName), type: .interface)"
        targetString += ",\n\(tab(2)).testing(module: \(moduleEnum), dependencies: [\n\(tab(3))\(interfaceDependency)\n\(tab(2))])"
    }
    if hasUnitTests {
        makeScaffold(target: .unitTest)
        targetString += ",\n\(tab(2)).tests(module: \(moduleEnum), dependencies: [\n\(tab(3)).\(layerPrefix)(target: .\(moduleName))\n\(tab(2))])"
    }
    if hasUITests {
        makeScaffold(target: .uiTest)
        // TODO: - ui test 타겟 설정 로직 추가
    }
    if hasDemo {
        makeScaffold(target: .demo)
        targetString += ",\n\(tab(2)).demo(module: \(moduleEnum), dependencies: [\n\(tab(3)).\(layerPrefix)(target: .\(moduleName))\n\(tab(2))])"
    }
    targetString += "\n\(tab(1))]"
    makeProjectSwift(targetString: targetString)
    makeSourceScaffold()
}

func tab(_ count: Int) -> String {
    var tabString = ""
    for _ in 0..<count {
        tabString += "    "
    }
    return tabString
}

func registerModulePaths() {
    updateFileContent(
        filePath: currentPath + "Plugin/DependencyPlugin/ProjectDescriptionHelpers/ModulePaths.swift",
        finding: "enum \(layer.rawValue): String, MicroTargetPathConvertable {\n",
        inserting: "        case \(moduleName)\n"
    )
    print("Register \(moduleName) to ModulePaths.swift")
}

func makeDirectory(path: String) {
    do {
        if fileManager.fileExists(atPath: path) {
            print("디렉토리를 생성하려는 곳에 이미 디렉토리가 존재해요, 덮어쓰기할까요?\n경로 : \(path)\n(y / n)")
            let isOverwrite = readLine()?.lowercased() == "y"
            if isOverwrite {
                try fileManager.removeItem(atPath: path)
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            }
        } else {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        }
    } catch {
        fatalError("❌ failed to create directory: \(path)")
    }
}

func makeDirectories(_ paths: [String]) {
    paths.forEach(makeDirectory(path:))
}

func makeProjectSwift(targetString: String) {
    let projectSwift = """
import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.\(layer.rawValue).\(moduleName).rawValue,
    targets: \(targetString)
)

"""
    writeContentInFile(
        path: currentPath + "Projects/\(layer.rawValue)s/\(moduleName)/Project.swift",
        content: projectSwift
    )
    #warning("TODO: Layer 이름(디렉토리 이름)과 ModulePaths 이름이 다르기에 경로에 Layer를 사용하는 부분들은 Projects/{이름}s 로 뒤에 s를 붙임")
}

func makeProjectDirectory() {
    makeDirectory(path: currentPath + "Projects/\(layer.rawValue)s/\(moduleName)")
}

func makeSourceScaffold() {
    _ = try? bash.run(
        commandName: "tuist",
        arguments: ["scaffold", "Sources", "--name", "\(moduleName)", "--layer", "\(layer.rawValue)s"]
    )
}

func makeScaffold(target: MicroTargetType) {
    _ = try? bash.run(
        commandName: "tuist",
        arguments: ["scaffold", "\(target.rawValue)", "--name", "\(moduleName)", "--layer", "\(layer.rawValue)s"]
    )
}

func writeContentInFile(path: String, content: String) {
    let fileURL = URL(fileURLWithPath: path)
    let data = Data(content.utf8)
    try? data.write(to: fileURL)
}

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

// MARK: - Starting point

print("레이어 이름을 입력해주세요!\n(Feature | Domain | Service | Module | UserInterface)", terminator: " : ")
let layerInput = readLine()
guard
    let layerInput,
    !layerInput.isEmpty,
    let layerUnwrapping = LayerType(rawValue: layerInput)
else {
    print("입력이 비었거나 잘못되었어요!")
    exit(1)
}
let layer = layerUnwrapping
print("Layer: \(layer.rawValue)\n")

print("모듈 이름을 입력해주세요!", terminator: " : ")
let moduleInput = readLine()
guard let moduleNameUnwrapping = moduleInput, !moduleNameUnwrapping.isEmpty else {
    print("모듈 이름이 비었어요!")
    exit(1)
}
var moduleName = moduleNameUnwrapping
print("모듈 이름: \(moduleName)\n")

print("'Interface' Target을 포함하나요? (y\\n, default = n)", terminator: " : ")
let hasInterface = readLine()?.lowercased() == "y"

print("'Testing' Target을 포함하나요? (y\\n, default = n)", terminator: " : ")
let hasTesting = readLine()?.lowercased() == "y"

print("'UnitTests' Target을 포함하나요? (y\\n, default = n)", terminator: " : ")
let hasUnitTests = readLine()?.lowercased() == "y"

print("'UITests' Target을 포함하나요? (y\\n, default = n)", terminator: " : ")
let hasUITests = readLine()?.lowercased() == "y"

print("'Demo' Target을 포함하나요? (y\\n, default = n)", terminator: " : ")
let hasDemo = readLine()?.lowercased() == "y"

print("")

registerModuleDependency()

print("")
print("------------------------------------------------------------------------------------------------------------------------")
print("레이어: \(layer.rawValue)")
print("모듈 이름: \(moduleName)")
print("interface: \(hasInterface), testing: \(hasTesting), unitTests: \(hasUnitTests), uiTests: \(hasUITests), demo: \(hasDemo)")
print("------------------------------------------------------------------------------------------------------------------------")
print("✅ 모듈을 성공적으로 생성했어요!")

// MARK: - Bash
protocol CommandExecuting {
    func run(commandName: String, arguments: [String]) throws -> String
}

enum BashError: Error {
    case commandNotFound(name: String)
}

struct Bash: CommandExecuting {
    func run(commandName: String, arguments: [String] = []) throws -> String {
        return try run(resolve(commandName), with: arguments)
    }

    private func resolve(_ command: String) throws -> String {
        guard var bashCommand = try? run("/bin/bash", with: ["-l", "-c", "which \(command)"]) else {
            throw BashError.commandNotFound(name: command)
        }
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return bashCommand
    }

    private func run(_ command: String, with arguments: [String] = []) throws -> String {
        let process = Process()
        process.launchPath = command
        process.arguments = arguments
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.launch()
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        return output
    }
}