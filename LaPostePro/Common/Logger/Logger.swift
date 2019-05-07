//
//  Logger.swift
//  LaPostePro
//
//  Created by PENA SANCHEZ Edwin Jose on 28/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import SwiftyBeaver
import Foundation
/**
 class is a simple wrapper class for the SwiftyBeaver public third party logger library.
 
 - Parameters:
 context: the context related String for the different logs.
 
 💭 VERBOSE AppDelegate.application():Line - not so important.
 
 ✅ DEBUG AppDelegate.application():Line - something to debug.
 
 ℹ️ INFO AppDelegate.application():Line - a nice information.
 
 ⚠️ WARNING AppDelegate.application():Line - oh not, that won't be good.
 
 🚫 ERROR AppDelegate.application():Line - ouch, an error did occur!
 
 */
public class Logger {
    
    public let context: String
    
    // MARK: Singleton
    static let shared = Logger()
    
    public init( _ context: String = "APP") {
        self.context = context
        
        var consoleDestinationAlreadyExists = false
        for destination in SwiftyBeaver.destinations {
            if let consoleDest = destination as? ConsoleDestination {
                consoleDestinationAlreadyExists = true
                configureDestination(consoleDest)
            }
        }
        
        if !consoleDestinationAlreadyExists {
            let consoleDest = ConsoleDestination()
            configureDestination(consoleDest)
            SwiftyBeaver.addDestination(consoleDest)
        }
    }
    
    //MARK: Public logging methods
    
    public func verbose(_ message: String?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        SwiftyBeaver.verbose(formatMessage(message),file,function,line: line)
    }
    
    public func debug(_ message: String?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        SwiftyBeaver.debug(formatMessage(message),file,function,line: line)
    }
    
    public func info(_ message: String?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        SwiftyBeaver.info(formatMessage(message),file,function,line: line)
    }
    
    public func warning(_ message: String?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        SwiftyBeaver.warning(formatMessage(message),file,function,line: line)
    }
    
    public func error(_ message: String?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        SwiftyBeaver.error(formatMessage(message),file,function,line: line)
    }
    
    
    //MARK: Private
    
    private func formatMessage( _ message: String?) -> String {
        let c = self.context
        if let m = message {
            return "[\(c)] \(m)"
        } else {
            return ""
        }
    }
    
    private func configureDestination( _ consoleDest: ConsoleDestination) {
        consoleDest.format = "$C$DHH:mm:ss.SSS$d $L$c $N.$F:$l - $M"
        consoleDest.levelColor.verbose = "💭"
        consoleDest.levelColor.debug = "✅"
        consoleDest.levelColor.info = "ℹ️"
        consoleDest.levelColor.warning = "⚠️"
        consoleDest.levelColor.error = "🚫"
        
        #if DEBUG
        consoleDest.minLevel = .verbose
        consoleDest.asynchronously = false
        #else
        consoleDest.minLevel = .info
        consoleDest.asynchronously = true
        #endif
    }
}

