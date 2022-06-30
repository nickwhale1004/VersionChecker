import Foundation

enum CompareError: Error {
    case invalidSymbols
    case emptyData
}

func compareVersions(_ s1: String, and s2: String) throws -> ComparisonResult {
    if s1 == "" || s2 == "" { throw CompareError.emptyData }
    try s1.forEach { char in if char == "." { return }
        guard let _ = UInt(String(char)) else { throw  CompareError.invalidSymbols }
    }
    try s2.forEach { char in if char == "." { return }
        guard let _ = UInt(String(char)) else { throw  CompareError.invalidSymbols }
    }
    let splitedS1 = s1.components(separatedBy: ".").map{$0[($0.firstIndex{$0 != "0"} ?? $0.startIndex)...]}
    let splitedS2 = s2.components(separatedBy: ".").map{$0[($0.firstIndex{$0 != "0"} ?? $0.startIndex)...]}
    
    if let res = zip(splitedS1.flatMap{$0 != "" ? $0 : "0"}, splitedS2.flatMap{$0 != "" ? $0 : "0"}).first(where: {$0.0 < $0.1 || $0.0 > $0.1}) {
        if res.0 < res.1 { return .orderedAscending }; return .orderedDescending
    }
    return .orderedSame
}

func testCompareVesrions(_ s1: String, and s2: String) {
    print("Entered data:")
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
    catch CompareError.emptyData {
        print("Empty data!")
    }
    catch { }
    print()
}

//Data validity test
print("DATA VALIDITY TESTS:")

testCompareVesrions("asd", and: ".1")
testCompareVesrions("1", and: "asd")
testCompareVesrions("", and: ".1")
testCompareVesrions("-1", and: ".1")

//Usuall test
print("\nUSUALL TESTS:")

testCompareVesrions("1.0", and: "1")
testCompareVesrions("01.234.56", and: "2.0.0")
testCompareVesrions("0.010", and: "0.10")
testCompareVesrions("0.10", and: "0.100")
testCompareVesrions("0.00001", and: "0.1")

//Rules test
print("\nRULES TESTS:")

testCompareVesrions(".0", and: "0.0")
testCompareVesrions(".", and: "0.0")
testCompareVesrions("..0.1", and: "0.0.0.1")

//Big data test
print("\nBIG DATA TEST:")

testCompareVesrions("3479023749023749023790479023749023790479023749023790470.343243443424234.3423423423423894238946892364896238946892364892368946246", and: "125393.32478723561087.2347868971325.37694")
