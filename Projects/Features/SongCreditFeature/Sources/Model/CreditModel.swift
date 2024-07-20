import Foundation

struct CreditModel: Equatable, Hashable {
    let position: String
    let names: [CreditWorker]

    init(position: String, names: [String]) {
        self.position = position
        self.names = names.map { CreditWorker(name: $0) }
    }

    struct CreditWorker: Equatable, Hashable {
        let id: String
        let name: String

        init(name: String) {
            self.id = UUID().uuidString
            self.name = name
        }
    }
}
