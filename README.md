# FakeStoreCore

**FakeStoreCore** is a Swift package that extracts and centralizes the business logic and data persistence layer from the [FakeStore](https://github.com/andrewchaves/FakeStore) project.  
It was designed to improve separation of concerns, encourage code reuse, and simplify maintenance across multiple UI implementations.

## Purpose

- Isolate business logic from the main FakeStore project.
- Distribute the module via **Swift Package Manager (SPM)**.
- Support both the existing **UIKit** version and a new **SwiftUI** version (currently under development).

## Current Status

- ✅ Core business logic extracted and functional.
- ✅ Core Data persistence implemented.
- ⚠️ SwiftUI integration in progress.
- ⚠️ Subject to further adjustments as the main FakeStore app evolves.

## Integration

### Swift Package Manager

In Xcode:

1. **File > Swift Packages > Add Package Dependency...**
2. Repository URL:  
`https://github.com/andrewchaves/FakeStoreCore`

3. Select the desired version.

Once added, simply:

```swift
import FakeStoreCore
```

## Integration

- ✅ Extract business logic to a separate package.
- ✅ Implement Core Data persistence layer.
- 🔄 Improve SwiftUI compatibility.
- 🔄 Improve testing coverage.
- 🔄 Apply further architectural refinements as FakeStore evolves.
