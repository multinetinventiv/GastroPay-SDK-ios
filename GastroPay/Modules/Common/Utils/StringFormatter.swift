//
//  StringFormatter.swift
//  Pods
//
//  Created by  on 8.12.2019.
//

import Foundation

class TemplateElement {

    struct Constants {
        static let seperatorPredecessor: Character = "~"
        static let maskedPredecessor: Character = "*"
    }

    enum ElementType {
        case Separator
        case Constant
        case Definition
    }

    var char: Character?

    var elementType: ElementType?

    var isMasked: Bool

    init(char: Character?, elementType: ElementType?, isMasked: Bool = false) {
        self.char = char
        self.elementType = elementType
        self.isMasked = isMasked
    }
}

class StringFormatter
{
    struct Constants
    {
        static let maskDefinition = Character("*")
        static let definitions: [Character: NSCharacterSet] = {
            let characterSet = NSMutableCharacterSet()
            characterSet.formUnion(with: NSMutableCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz") as CharacterSet)
            characterSet.formUnion(with: NSMutableCharacterSet(charactersIn: "0123456789") as CharacterSet)

            return [
                "x": NSMutableCharacterSet.alphanumeric(),
                "a": NSMutableCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"),
                "?": characterSet
            ]
        }()

        static let numberFormatter: NumberFormatter = {
            var formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.decimalSeparator = ","
            formatter.groupingSeparator = "."
            return formatter
        }()

        static let dateFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter
        }()

        static let dateTimeFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            return formatter
        }()

        static let timeFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            return formatter
        }()

        static let doubleFormatter: NumberFormatter = {
            var formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.decimalSeparator = ","
            formatter.groupingSeparator = "."
            formatter.maximumFractionDigits = 2
            formatter.roundingMode = NumberFormatter.RoundingMode.down
            return formatter
        }()

        static let amountFormatter: NumberFormatter = {
            var formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.maximumFractionDigits = 2
            formatter.currencySymbol = ""
            formatter.currencyDecimalSeparator = ","
            formatter.currencyGroupingSeparator = "."
            formatter.roundingMode = NumberFormatter.RoundingMode.down
            return formatter
        }()

        struct LicensePlate {
            static let minLength = 7
            static let maxLength = 8
            static let part0ExactLength = 2
            static let part1MaxLength = 3
            static let part2MaxLength = 5
        }
    }

    private class func getTemplateElements(template: String) -> [TemplateElement] {
        var templateElements: [TemplateElement] = []
        for char in template {
            if char == TemplateElement.Constants.seperatorPredecessor {
                templateElements.append(TemplateElement(char: nil, elementType: .Separator))
            } else if char == TemplateElement.Constants.maskedPredecessor {
                templateElements.append(TemplateElement(char: nil, elementType: nil, isMasked: true))
            } else {
                if (templateElements.last != nil && templateElements.last!.char == nil) {
                    templateElements.last!.char = char
                } else {
                    templateElements.append(TemplateElement(char: char, elementType: nil))
                }

                if (templateElements.last != nil && templateElements.last!.elementType == nil) {
                    if Constants.definitions[char] == nil {
                        templateElements.last!.elementType = .Constant
                    } else {
                        templateElements.last!.elementType = .Definition
                    }
                }
            }
        }
        return templateElements
    }

    private class func isCharMatched(char: Character, definition: CharacterSet) -> Bool {
        return String(char).components(separatedBy: definition).joined(separator: "").isEmpty
    }

    class func format(text: String?, template: String, isMasked: Bool = false) -> String? {
        if text == nil || text!.isEmpty {
            return text
        }

        let templateElements = getTemplateElements(template: template)
        var templateElementIndex = templateElements.startIndex
        var textIndex = text!.startIndex
        var formattedText = ""

        /*
         gelen text içinde imleç barındırıyorsa imlecin pozisyonu korunur
         her text karakteri için şablonda arama yapılır
         şablonda sıradaki karakter bir sabit ya da ayraç ise formatlanmış texte eklenir
         şablonda sıradaki karater bir definition ise text içinde uygun karakter bulunana kadar aranır
         */

        while textIndex < text!.endIndex {
            // sıradaki karakter cursor ise ekle ve atla
            if text![textIndex] == "|" {
                formattedText.append(text![textIndex])
                textIndex = text!.index(after: textIndex)
                continue
            }

            while templateElementIndex < templateElements.endIndex {
                if let definition:CharacterSet = Constants.definitions[templateElements[templateElementIndex].char!] as CharacterSet? {
                    // sıradaki karakter bir definition ise
                    if isCharMatched(char: text![textIndex], definition: definition) || text![textIndex] == Constants.maskDefinition {
                        formattedText.append(isMasked && templateElements[templateElementIndex].isMasked ? Constants.maskDefinition : text![textIndex])
                        templateElementIndex += 1
                    }
                    break // bir sonraki textChar
                } else {
                    // sıradaki karakter bir definition değil ise (seperator ya da constant)
                    formattedText.append(templateElements[templateElementIndex].char!)
                    if text![textIndex] == templateElements[templateElementIndex].char! {
                        templateElementIndex += 1
                        break // bir sonraki textChar
                    }
                }
                templateElementIndex += 1
            }
            textIndex = text!.index(after: textIndex)
        }

        return formattedText
    }

    class func clear(text: String?, template: String) -> String? {
        if text == nil || text!.isEmpty {
            return text
        }

        let templateElements = getTemplateElements(template: template)
        var clearedText = ""
        var textIndex = text!.startIndex

        for templateElement in templateElements {
            if textIndex == text!.endIndex {
                break
            }

            if templateElement.elementType != TemplateElement.ElementType.Separator {
                clearedText.append(text![textIndex])
            }
            textIndex = (text?.index(after: textIndex))!

        }

        return clearedText
    }

    class func clear(text: String?, chars: [Character]) -> String? {
        if (text == nil) {
            return text
        }

        var text = text
        for char in chars {
            text = text?.replacingOccurrences(of: String(char), with: "")
        }

        return text
    }

    class func formatNumber(number: Double?, precision: Int = 0) -> String? {
        if number == nil {
            return nil
        }

        let formatter = Constants.numberFormatter
        formatter.minimumFractionDigits = precision
        formatter.maximumFractionDigits = precision
        return formatter.string(from: NSNumber(value: number!))
        //return formatter.stringFromNumber(number!)
    }

    class func clearNumber(text: String?) -> Double? {
        if text == nil {
            return nil
        }

        let formatter = Constants.numberFormatter
        if let number = formatter.number(from:(text!)) {
            return Double(truncating: number)
        } else {
            return nil
        }
    }

    //    class func formatNumber(text: String?, cursorPosition: inout Int) -> String? {
    //        if text == nil || text!.isEmpty {
    //            return text
    //        }
    //
    //        var number = ""
    //        for char in text!.characters {
    //            if char == "." {
    //                cursorPosition -= 1
    //            } else {
    //                number.append(char)
    //            }
    //        }
    //
    //        if number.characters.count <= 3 {
    //            return number
    //        }
    //
    //        var dotCount = number.characters.count / 3
    //        if number.characters.count % 3 == 0 {
    //            dotCount -= 1
    //        }
    //
    //        var remainingCharCount = number.characters.count % 3
    //        if remainingCharCount == 0 {
    //            remainingCharCount = 3
    //        }
    //
    //        var formattedText = ""
    //        for i in 0 ..< dotCount {
    //
    //            //number.endIndex.advancedBy((i+1) * -3) ..< number.endIndex.advancedBy(i * -3)))
    //
    //            let temp = number.substring(with: Range<String.Index>(number.index(after: ((i+1) * -3))) ..< (number.index(after: (i * -3))))
    //
    //            formattedText = "." + temp + formattedText
    //
    //            cursorPosition += 1
    //        }
    //        formattedText = number.substringToIndex(number.startIndex.advancedBy(remainingCharCount)) + formattedText
    //
    //        return formattedText
    //    }

    class func stringFromDate(date: NSDate?, withTime: Bool = false, onlyTime: Bool = false) -> String? {
        if date == nil {
            return nil
        }

        let formatter = withTime ? (onlyTime ? Constants.timeFormatter : Constants.dateTimeFormatter) : Constants.dateFormatter
        return formatter.string(from: date! as Date)
    }

    class func dateFromString(string: String?) -> NSDate? {
        if string == nil {
            return nil
        }

        let formatter = Constants.dateFormatter
        return formatter.date(from: string!) as NSDate?
    }

    class func stringFromAmount(amount: Double?, currencyCode: String?) -> String? {
        if amount == nil || currencyCode == nil {
            return nil
        }

        let formatter = Constants.amountFormatter
        let string = "\(String(describing: formatter.string(from: NSNumber(value: amount!)))) \(currencyCode!))"
        return string
    }

    class func amountFromString(text: String?, precision: Int? = nil) -> Double? {
        if text == nil {
            return nil
        }

        let formatter = Constants.amountFormatter
        if precision != nil{
            formatter.maximumFractionDigits = precision!
        }
        if let number = formatter.number(from: text!) {
            return Double(truncating: number)
        } else {
            return nil
        }
    }

    class func stringFromDouble(double: Double?, precision: Int? = nil) -> String? {
        if double == nil {
            return nil
        }

        let formatter = Constants.doubleFormatter
        if let precision = precision {
            formatter.minimumFractionDigits = precision
            formatter.maximumFractionDigits = precision
        }
        return formatter.string(from: NSNumber(value: double!))
    }


    class func stringFromDoubleWithRoundingMode(double: Double?, roundingMode: NumberFormatter.RoundingMode!, precision: Int? = nil) -> String? {
        if double == nil {
            return nil
        }

        let formatter = Constants.doubleFormatter

        formatter.roundingMode = roundingMode

        if let precision = precision {
            formatter.minimumFractionDigits = precision
            formatter.maximumFractionDigits = precision
        }
        return formatter.string(from: NSNumber(value: double!))
    }

    class func doubleFromString(string: String?) -> Double? {
        if string == nil {
            return nil
        }

        let formatter = Constants.doubleFormatter

        // remove grouping seperator character from string before conversion to handle strings like "1.2345"
        if let double = formatter.number(from: string!.replacingOccurrences(of: formatter.groupingSeparator!, with: "")) {
            return Double(truncating: double)
        } else {
            return nil
        }
    }

    class func removeTurkishChars(string: String?) -> String? {

        if string == nil {
            return nil
        }
        var modifiedString = string

        let turkishChars = ["ı", "İ", "ş", "Ş", "ğ", "Ğ", "ü", "Ü", "ö", "Ö", "ç", "Ç"]
        let replaceChars = ["i", "I", "s", "S", "g", "G", "u", "U", "o", "O", "c", "C"]

        for (index,char) in turkishChars.enumerated() {
            modifiedString = modifiedString?.replacingOccurrences(of: char, with: replaceChars[index])
        }

        return modifiedString
    }

}
