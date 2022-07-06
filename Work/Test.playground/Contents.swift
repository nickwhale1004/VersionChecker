import Foundation

enum CompareError: Error {
    case invalidSymbols
}

func compareVersions(_ s1: String, and s2: String) throws -> ComparisonResult {
    try s1.forEach { if $0 == "." { return }
        guard let _ = UInt(String($0)) else { throw  CompareError.invalidSymbols }
    }
    try s2.forEach { if $0 == "." { return }
        guard let _ = UInt(String($0)) else { throw  CompareError.invalidSymbols }
    }
    
    let splitedS1 = s1.split(separator: ".", omittingEmptySubsequences: false)
    let splitedS2 = s2.split(separator: ".", omittingEmptySubsequences: false)
    
    for i in 0..<max(splitedS1.count, splitedS2.count) {
        var substringS1 = i < splitedS1.count ? (splitedS1[i][(splitedS1[i].firstIndex(where: {$0 != "0"}) ?? splitedS1[i].startIndex)...]) : "0"
        var substringS2 = i < splitedS2.count ? splitedS2[i][(splitedS2[i].firstIndex(where: {$0 != "0"}) ?? splitedS2[i].startIndex)...] : "0"
        substringS1 = substringS1 == "" ? "0" : substringS1
        substringS2 = substringS2 == "" ? "0" : substringS2
        
        var iterator1 = substringS1.makeIterator(), iterator2 = substringS2.makeIterator()
        for _ in 0..<max(substringS1.count, substringS2.count) {
            let char1 = iterator1.next() ?? "-", char2 = iterator2.next() ?? "-"
            if char1 < char2 { return .orderedAscending }
            if char1 > char2 { return .orderedDescending }
        }
    }
    return .orderedSame
}

func testCompareVesrions(_ s1: String, and s2: String) {
    print("\(s1)  \(s2)")
    do {
        let result = try compareVersions(s1, and: s2)
        
        switch result {
        case .orderedDescending:
            print("First is bigger")
        case .orderedAscending:
            print("Second is bigger")
        default:
            print("The same")
        }
    }
    catch CompareError.invalidSymbols {
        print("Invalid data!")
    }
    catch { }
    print()
}



