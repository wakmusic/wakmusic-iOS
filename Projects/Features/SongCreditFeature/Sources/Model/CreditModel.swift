import Foundation
import SongsDomainInterface

struct CreditModel: Equatable, Hashable {
    let position: String
    let names: [CreditWorker]

    init(position: String, names: [String]) {
        self.position = position
        self.names = names.map { CreditWorker(name: $0, creditType: .default) }
    }

    init(creditEntity: SongCreditsEntity) {
        self.position = creditEntity.type
        self.names = creditEntity.names.map { credit in
            let creditType: CreditWorker.CreditType = if credit.isArtist, let artistID = credit.artistID {
                .artist(artistID: artistID)
            } else {
                .default
            }
            return CreditWorker(name: credit.name, creditType: creditType)
        }
    }

    struct CreditWorker: Equatable, Hashable {
        let id: String
        let name: String
        let creditType: CreditType

        enum CreditType: Equatable, Hashable {
            case artist(artistID: String)
            case `default`
        }

        init(name: String, creditType: CreditType) {
            self.id = UUID().uuidString
            self.name = name
            self.creditType = creditType
        }
    }
}
