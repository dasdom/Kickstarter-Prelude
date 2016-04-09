public extension Array where Element: OptionalType {

  /**
   - returns: A new array with `nil` values removed.
   */
  public func compact() -> [Element.Wrapped] {
    return self.filter { $0.optional != nil }.map { $0.optional! }
  }
}

public extension Array where Element: Semigroup {
  /**
   Combines all elements of the array with the semigroup operation.

   - parameter initial: A semigroup value.

   - returns: The concatenation of all the values.
   */
  public func sconcat(initial: Element) -> Element {
    return self.reduce(initial, combine: <>)
  }
}

public extension Array {

  /**
   Returns a random element from the array, or `nil` if the array is empty.
   */
  public var randomElement: Element? {
    guard !self.isEmpty else { return nil }

    let idx = Int(arc4random_uniform(UInt32(self.count)))
    return self[idx]
  }

  /**
   Remove repeated elements from an array. This is an O(n^2) implementation based
   on Array.contains.

   - parameter eq: A function to determine equality of two elements.

   - returns: An array of distinct values in the array without changing the order.
   */
  public func distincts(@noescape eq: (Element, Element) -> Bool) -> Array {
    var result = Array()
    forEach { x in
      if !result.contains({ eq(x, $0) }) {
        result.append(x)
      }
    }
    return result
  }
}

public extension Array where Element: Equatable {

  /**
   Remove repeated elements from an array. This is an O(n^2) implementation based
   on Array.contains.

   - returns: An array of distinct values in the array without changing the order.
   */
  public func distincts() -> Array {
    return self.distincts(==)
  }
}

extension Array: Semigroup {
  public func op(other: Array) -> Array {
    return self + other
  }
}

extension Array {
  /**
   Safely accesses an element of `self` by checking the bounds.

   - parameter index: Index of an element to try to get.

   - returns: An element if `index` is within bounds and `nil` otherwise.
   */
  public subscript(safe index: Int) -> Element? {
    return index >= 0 && index < self.count ? self[index] : nil
  }
}
