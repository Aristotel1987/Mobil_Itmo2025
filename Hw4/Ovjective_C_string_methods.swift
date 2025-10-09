import Foundation
#if os(Linux)
import Glibc
#else
import Darwin
#endif

func generateRussianText() -> String {
    let words = ["это","пример","текста","для","замены","и","нормализации","Пример"]
    var s = (0..<12).map { _ in words.randomElement()! }.joined(separator: " ")
    s += ".  вот ещё предложение  с  лишними   пробелами!"
    return s
}

func cRegexReplace(_ input: String, pattern: String, replacement: String, flags: Int32 = Int32(REG_EXTENDED | REG_ICASE)) -> String {
    setlocale(LC_CTYPE, "")
    var cchars = input.utf8CString
    let origBytes = cchars.dropLast().map { UInt8(bitPattern: $0) }
    var result = Data()
    var re = regex_t()
    pattern.withCString { patPtr in
        if regcomp(&re, patPtr, flags) != 0 { return }
    }
    cchars.withUnsafeBufferPointer { buf in
        guard let base = buf.baseAddress else { return }
        let totalLen = Int(strlen(base))
        var searchOffset = 0
        var prev = 0
        var pmatch = regmatch_t()
        while true {
            let rc = regexec(&re, base.advanced(by: searchOffset), 1, &pmatch, 0)
            if rc != 0 { break }
            let so = searchOffset + Int(pmatch.rm_so)
            let eo = searchOffset + Int(pmatch.rm_eo)
            if so > prev { result.append(contentsOf: origBytes[prev..<so]) }
            result.append(contentsOf: replacement.utf8)
            prev = eo
            searchOffset = eo
            if searchOffset >= totalLen { break }
        }
        if prev < origBytes.count { result.append(contentsOf: origBytes[prev..<origBytes.count]) }
    }
    regfree(&re)
    return String(data: result, encoding: .utf8) ?? input
}

var text = generateRussianText()
print("Исходный: ", text)
text = cRegexReplace(text, pattern: "пример", replacement: "образец")
text = cRegexReplace(text, pattern: "\\s+", replacement: " ")
text = text.trimmingCharacters(in: .whitespacesAndNewlines)
if !text.isEmpty { text = text.prefix(1).uppercased() + text.dropFirst() }
let normalized = (text as NSString).precomposedStringWithCanonicalMapping
let latin = normalized.applyingTransform(.toLatin, reverse: false) ?? normalized
print("Результат: ", normalized)
print("Латиница: ", latin)
