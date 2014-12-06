//
//  ViewController.swift
//  Tile
//
//  Created by Brandon on 12/5/14.
//  Copyright (c) 2014 Bob. All rights reserved.
//

import UIKit

var tileImg:[UIImage] = []

let rows:Int = 10
let columns:Int = 10

let screenRows:Int = 5
let screenColumns:Int = 5

let top:Int = ((screenRows - 1) / 2 - 1) * screenColumns + ((screenColumns - 1) / 2)
let left:Int = ((screenRows - 1) / 2) * screenColumns + ((screenColumns - 1) / 2) - 1
let right:Int = ((screenRows - 1) / 2) * screenColumns + ((screenColumns - 1) / 2) + 1
let bottom:Int = ((screenRows - 1) / 2 + 1) * screenColumns + ((screenColumns - 1) / 2)

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var myMap = Map(numRows:rows, numColumns:columns, numScreenRows:screenRows, numScreenColumns:screenColumns)
    var myCurrentX = 2
    var myCurrentY = 2
    
    @IBAction func clickTile(sender:UIButton)
    {
        var currentPosition:Int = myCurrentX + myCurrentY * screenColumns
        PositionControl.correctOvergo(map:myMap, row:&myCurrentX, column:&myCurrentY)
        PositionControl.updatePosition(position:currentPosition, row:&myCurrentY, column:&myCurrentX)
        myMap.drawScreen(rowNum:myCurrentX, columnNum:myCurrentY)
    }
}

func getRandomNumber(#range:Range<UInt32>) -> Int
{
    return Int(range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1))
}

class Map
{
    var map = Array<Array<Int>>()
    var rows:Int
    var columns:Int
    var screenRows:Int
    var screenColumns:Int
    init(numRows:Int, numColumns:Int, numScreenRows:Int, numScreenColumns:Int)
    {
        rows = numRows
        columns = numColumns
        screenRows = numScreenRows
        screenColumns = numScreenColumns
        for column in 0...numColumns - 1
        {
            var newArray = Array<Int>()
            for row in 0...numRows - 1
            {
                newArray.append(getRandomNumber(range:0...2))
            }
            map.append(newArray)
        }
    }
    func setImage(#tileImageNum:Int, inputTileImageType:Int)
    {
        var tileImageType:String = ""
        switch inputTileImageType
        {
            case 0 :
                tileImageType = "Regular"
                break;
            case 1 :
                tileImageType = "Mountain"
                break;
            case 2 :
                tileImageType = "Forest"
                break;
            default :
                break;
        }
        
        tileImg[tileImageNum] = UIImage(named:tileImageType)!
    }
    
    func getRows() -> Int
    {
        return rows
    }
    
    func getColumns() -> Int
    {
        return columns
    }
        
    func drawScreen(#rowNum:Int, columnNum:Int)
    {
        var rowAndColumnController:Int = 0
        for imageNum in 0...screenRows * screenColumns
        {
            setImage(tileImageNum:imageNum, inputTileImageType:self.map[(rowAndColumnController / 3) - (self.screenColumns - 1) / 2][(rowAndColumnController % 3) - (self.screenRows - 1) / 2])
            rowAndColumnController++
        }
    }
    
    subscript(#row:Int, #column:Int) -> Int
    {
        return map[row][column]
    }
}
        
class PositionControl
{
    class func correctOvergo(#map:Map, inout row:Int, inout column:Int)
    {
        if(row == 0)
        {
            row += 1
        }
        
        if(row == map.getRows() - 1)
        {
            row -= 1
        }
        
        if(column == 0)
        {
            column += 1
        }
        
        if(column == map.getColumns() - 1)
        {
            column -= 1
        }
    }
        
    class func updatePosition(#position:Int, inout row:Int, inout column:Int)
    {
        switch position
        {
            case top :
                row -= 1
                break
            case left :
                column -= 1;
                break
            case right :
                column += 1;
                break
            case bottom :
                row += 1;
                break;
            default :
                break
        }
    }
}

