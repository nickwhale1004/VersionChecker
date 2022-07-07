import Foundation

enum CompareError: Error {
    case invalidSymbols
}

func compareVersions(_ s1: String, _ s2: String) throws -> ComparisonResult {
    try s1.forEach { if $0 == "." { return }
        guard let _ = UInt(String($0)) else { throw  CompareError.invalidSymbols }
    }
    try s2.forEach { if $0 == "." { return }
        guard let _ = UInt(String($0)) else { throw  CompareError.invalidSymbols }
    }
    
    let splitedS1 = s1.split(separator: ".", omittingEmptySubsequences: false)
    let splitedS2 = s2.split(separator: ".", omittingEmptySubsequences: false)
    
    for i in 0 ..< max(splitedS1.count, splitedS2.count) {
        var substringS1: Substring = "0"
        if i < splitedS1.count {
            let startIndex = splitedS1[i].firstIndex{$0 != "0"} ?? splitedS1[i].startIndex
            if splitedS1[i][startIndex...] != "" {
                substringS1 = splitedS1[i][startIndex...]
            }
        }
        
        var substringS2: Substring = "0"
        if i < splitedS2.count {
            let startIndex = splitedS2[i].firstIndex{$0 != "0"} ?? splitedS2[i].startIndex
            if splitedS2[i][startIndex...] != "" {
                substringS2 = splitedS2[i][startIndex...]
            }
        }
        
        var iterator1 = substringS1.makeIterator()
        var iterator2 = substringS2.makeIterator()
        
        for _ in 0 ..< max(substringS1.count, substringS2.count) {
            var safeChar1: String = ""
            if let char1 = iterator1.next() {
                safeChar1 = String(char1)
            }
            
            var safeChar2: String = ""
            if let char2 = iterator2.next() {
                safeChar2 = String(char2)
            }
            
            if safeChar1 < safeChar2 { return .orderedAscending }
            if safeChar1 > safeChar2 { return .orderedDescending }
        }
    }
    return .orderedSame
}

func testCompareVesrions(_ s1: String, _ s2: String) {
    print("\(s1)  \(s2)")
    do {
        let result = try compareVersions(s1, s2)
        
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



