//
//  Protocols.swift
//  projectUI
//
//  Created by Sarah Sherman on 1/26/16.
//  Copyright © 2016 Sarah Sherman. All rights reserved.
//

import UIKit
import Foundation


protocol CancelButtonDelegate: class {
    func cancelButtonPressedFrom(controller: UIViewController)
}