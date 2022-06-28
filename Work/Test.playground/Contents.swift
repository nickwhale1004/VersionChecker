import Foundation

enum CompareError: Error {
    case invalidSymbols
    case emptyData
}

func compareVersions(_ s1: String, and s2: String) throws -> ComparisonResult {
    //Checking the version for the validity of the entered data
    try checkString(s1)
    try checkString(s2)
    
    //String splitting for component validation
    var splitedString1 = s1.components(separatedBy: ".")
    var splitedString2 = s2.components(separatedBy: ".")
    
    //Create additional sections if needed
    //to bring the version to the same format
    if splitedString1.count > splitedString2.count {
        let tempCollection = [String](repeating: "0", count: splitedString1.count - splitedString2.count)
        splitedString2 += tempCollection
    }
    else if splitedString2.count > splitedString1.count {
        let tempCollection = [String](repeating: "0", count: splitedString2.count - splitedString1.count)
        splitedString1 += tempCollection
    }
    
    //Bypass version section by section
    for i in 0..<splitedString1.count {
        //Interpreting an empty string as 0
        if splitedString1[i] == "" {
            splitedString1[i] = "0"
        }
        if splitedString2[i] == "" {
            splitedString2[i] = "0"
        }
        
        //Comparing each version section and handling the result
        let compareResult = try compareStringsAsValue(splitedString1[i], and: splitedString2[i])
    
        switch compareResult {
        case .orderedDescending:
            return .orderedDescending
        case .orderedAscending:
            return .orderedAscending
        default: break
        }
    }
    return .orderedSame
}

func checkString(_ s: String) throws {
    guard s != "" else { throw CompareError.emptyData }
    for char in s {
        if char == "." {
            continue
        }
        guard let _ = Int(String(char)) else {
            throw CompareError.invalidSymbols
        }
    }
}

func compareStringsAsValue(_ string1: String, and string2: String) throws -> ComparisonResult {
    var s1 = string1
    var s2 = string2
    
    //Adding trailing zeros to bring strings into the same format
    if s1.count > s2.count {
        let tempZeros = String(repeating: "0", count: s1.count - s2.count)
        s2 = tempZeros + s2
    }
    else if s2.count > s1.count {
        let tempZeros = String(repeating: "0", count: s2.count - s1.count)
        s1 = tempZeros + s1
    }
    
    //String comparison char by char
    for i in 0..<s1.count {
        //Checking for the validity of the entered data
        guard let char1 = Int(String(s1[s1.index(s1.startIndex, offsetBy: i)])),
              let char2 = Int(String(s2[s2.index(s2.startIndex, offsetBy: i)]))
        else {
            throw CompareError.invalidSymbols
        }
        
        if char1 > char2 {
            return .orderedDescending
        }
        if char2 > char1 {
            return .orderedAscending
        }
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

