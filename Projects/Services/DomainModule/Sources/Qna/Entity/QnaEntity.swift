import Foundation
import DomainModule

public struct QnaEntity: Equatable {
    public init(
        id: Int,
        create_at: Int,
        category:String,
        question:String,
        description:String
     
    ) {
        self.id = id
        self.create_at = create_at
        self.category = category
        self.question = question
        self.description = description
        
    }
    
    public let id,create_at: Int
    public let category,question,description:String
    
}

