import Foundation

public struct UniquedSequence<Base: Sequence, Subject: Hashable> {
    @usableFromInline
    internal let base: Base

    @usableFromInline
    internal let projection: (Base.Element) -> Subject

    @usableFromInline
    internal init(base: Base, projection: @escaping (Base.Element) -> Subject) {
        self.base = base
        self.projection = projection
    }
}

extension UniquedSequence: Sequence {
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        internal var base: Base.Iterator

        @usableFromInline
        internal let projection: (Base.Element) -> Subject

        @usableFromInline
        internal var seen: Set<Subject> = []

        @usableFromInline
        internal init(
            base: Base.Iterator,
            projection: @escaping (Base.Element) -> Subject
        ) {
            self.base = base
            self.projection = projection
        }

        @inlinable
        public mutating func next() -> Base.Element? {
            while let element = base.next() {
                if seen.insert(projection(element)).inserted {
                    return element
                }
            }
            return nil
        }
    }

    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), projection: projection)
    }
}

extension UniquedSequence: LazySequenceProtocol where Base: LazySequenceProtocol {}
