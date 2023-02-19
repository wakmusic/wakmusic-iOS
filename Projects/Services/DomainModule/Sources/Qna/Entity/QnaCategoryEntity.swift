import Foundation
import DomainModule

public struct QnaCategoryEntity: Equatable {
    public init(
        category:String
    ) {
        self.category = category
 
    }
    
    public let category:String
    
}
