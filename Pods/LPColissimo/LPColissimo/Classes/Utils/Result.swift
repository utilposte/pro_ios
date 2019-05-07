//
//  Result.swift
//  FBSnapshotTestCase
//
//  Created by LaPoste on 05/10/2018.
//
import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

public typealias ResultCallback<Value> = (Result<Value>) -> Void
