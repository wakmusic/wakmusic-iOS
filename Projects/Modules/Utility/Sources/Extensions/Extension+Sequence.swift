import Foundation

extension Sequence where Element: Hashable {
    @inlinable
    public func uniqued() -> UniquedSequence<Self, Element> {
        UniquedSequence(base: self, projection: { $0 })
    }
}

extension Sequence {
    @inlinable
    public func uniqued<Subject: Hashable>(
        on projection: (Element) throws -> Subject
    ) rethrows -> [Element] {
        var seen: Set<Subject> = []
        var result: [Element] = []
        for element in self {
            if seen.insert(try projection(element)).inserted {
                result.append(element)
            }
        }
        return result
    }
}

extension LazySequenceProtocol {
    @inlinable
    public func uniqued<Subject: Hashable>(
        on projection: @escaping (Element) -> Subject
    ) -> UniquedSequence<Self, Subject> {
        UniquedSequence(base: self, projection: projection)
    }
}
