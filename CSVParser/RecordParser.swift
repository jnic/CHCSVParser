//
//  RecordParser.swift
//  CHCSVParser
//
//  Created by Dave DeLong on 9/19/15.
//
//

import Foundation

internal struct RecordParser {
    let fieldParser = FieldParser()
    
    func parse(stream: PeekingGenerator<Character>, configuration: CSVParserConfiguration, line: UInt) throws -> Bool {
        guard stream.peek() != nil else { return false }
        
        // there are more characters, which means there are more things to parse
        configuration.onBeginLine?(line: line)
        
        if stream.peek() == Character.Octothorpe && configuration.recognizeComments {
            let comment = parseComment(stream, configuration: configuration)
            configuration.onReadComment?(comment: comment)
        } else {
            try parseRecord(stream, configuration: configuration, line: line)
        }
        
        configuration.onEndLine?(line: line)
        return true
    }
    
    func parseRecord(stream: PeekingGenerator<Character>, configuration: CSVParserConfiguration, line: UInt) throws {
        var currentField: UInt = 0
        while try fieldParser.parse(stream, configuration: configuration, line: line, index: currentField) {
            currentField++
            guard let next = stream.peek() else { continue }
            
            // if the next character is a delimiter, consume it
            // if the next character is a newline, break
            // otherwise produce an error and break
            if next == configuration.delimiter {
                stream.next()
            } else if next.isNewline {
                break
            } else {
                throw CSVError(kind: .UnexpectedDelimiter, line: line, field: currentField, characterIndex: stream.currentIndex)
            }
            
        }
    }
    
    func parseComment(stream: PeekingGenerator<Character>, configuration: CSVParserConfiguration) -> String {
        guard stream.next() == Character.Octothorpe else {
            fatalError("Implementation flaw")
        }
        var comment = "#"
        var sanitized = ""
        
        var isBackslashEscaped = false
        while let next = stream.peek() {
            if isBackslashEscaped == false {
                if next == Character.Backslash && configuration.recognizeBackslashAsEscape {
                    isBackslashEscaped = true
                    comment.append(next)
                    stream.next()
                } else if next.isNewline {
                    break
                } else {
                    comment.append(next)
                    sanitized.append(next)
                    stream.next()
                }
            } else {
                isBackslashEscaped = false
                sanitized.append(next)
                comment.append(next)
                stream.next()
            }
        }
        
        switch (configuration.sanitizeFields, configuration.trimWhitespace) {
            case (true, true): return sanitized.trim()
            case (true, false): return sanitized
            case (false, true): return comment.trim()
            case (false, false): return comment
        }
    }
}