import Foundation

public extension Sequence where Element: Hashable {
    @inlinable
    func uniqued() -> UniquedSequence<Self, Element> {
        UniquedSequence(base: self, projection: { $0 })
    }
}

public extension Sequence {
    @inlinable
    func uniqued<Subject: Hashable>(
        on projection: (Element) throws -> Subject
    ) rethrows -> [Element] {
        var seen: Set<Subject> = []
        var result: [Element] = []
        for element in self {
            if try seen.insert(projection(element)).inserted {
                result.append(element)
            }
        }
        return result
    }
}

public extension LazySequenceProtocol {
    @inlinable
    func uniqued<Subject: Hashable>(
        on projection: @escaping (Element) -> Subject
    ) -> UniquedSequence<Self, Subject> {
        UniquedSequence(base: self, projection: projection)
    }
}
