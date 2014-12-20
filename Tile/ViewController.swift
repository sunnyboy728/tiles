//
//  ViewController.swift
//  Tile
//
//  Created by Brandon on 12/5/14.
//  Copyright (c) 2014 Bob. All rights reserved.
//

import UIKit

let rows:Int = 10
let columns:Int = 10

let screenRows:Int = 3
let screenColumns:Int = 5

let top:Int = ((screenRows - 1) / 2 - 1) * screenColumns + ((screenColumns - 1) / 2)
let left:Int = ((screenRows - 1) / 2) * screenColumns + ((screenColumns - 1) / 2) - 1
let right:Int = ((screenRows - 1) / 2) * screenColumns + ((screenColumns - 1) / 2) + 1
let bottom:Int = ((screenRows - 1) / 2 + 1) * screenColumns + ((screenColumns - 1) / 2)

class ViewController: UIViewController
{
    @IBOutlet var tileImg1: UIImageView!
    @IBOutlet var tileImg2: UIImageView!
    @IBOutlet var tileImg3: UIImageView!
    @IBOutlet var tileImg4: UIImageView!
    @IBOutlet var tileImg5: UIImageView!
    @IBOutlet var tileImg6: UIImageView!
    @IBOutlet var tileImg7: UIImageView!
    @IBOutlet var tileImg8: UIImageView!
    @IBOutlet var tileImg9: UIImageView!
    @IBOutlet var tileImg10: UIImageView!
    @IBOutlet var tileImg11: UIImageView!
    @IBOutlet var tileImg12: UIImageView!
    @IBOutlet var tileImg13: UIImageView!
    @IBOutlet var tileImg14: UIImageView!
    @IBOutlet var tileImg15: UIImageView!
    
    var tileImgs = [UIImageView]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tileImgs = [tileImg1, tileImg2, tileImg3, tileImg4, tileImg5, tileImg6, tileImg7, tileImg8, tileImg9, tileImg10, tileImg11, tileImg12, tileImg13, tileImg14, tileImg15]
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //var tileImgs:anyValueStorage<UIImage> = anyValueStorage()
    var myMap = Map(numRows:rows, numColumns:columns, numScreenRows:screenRows, numScreenColumns:screenColumns)
    
    var myCurrentRow = 1
    var myCurrentColumn = 2
    
    @IBAction func clickTile(sender:UIButton)
    {
        PositionControl.updatePosition(position:myCurrentRow + myCurrentColumn * screenColumns, row:&myCurrentColumn, column:&myCurrentRow)
        PositionControl.correctOvergo(map:myMap, row:&myCurrentRow, column:&myCurrentColumn)
        myMap.drawScreen(rowNum:myCurrentRow, columnNum:myCurrentColumn, images:&tileImgs)
    }
}

func getRandomNumber(#range:Range<UInt32>) -> Int
{
    return Int(range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1))
}

class anyValueStorage<T>
{
    var valueArray:[T] = []
    init(values:T...)
    {
        for value:T in values
        {
            valueArray.append(value)
        }
    }
    
    func setForIndex(#index:Int, value:T)
    {
        valueArray[index] = value
    }
    
    subscript(#index:Int) -> T
    {
        return valueArray[index]
    }
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
                newArray.append(getRandomNumber(range:0...1))
            }
            map.append(newArray)
        }
    }
    
    func setImage(#tileImageNum:Int, inputTileImageType:Int, inout images:[UIImageView])
    {
        var tileImageType:String = ""
        switch inputTileImageType
        {
            case 0 :
                tileImageType = "Regular"
                break
            case 1 :
                tileImageType = "Mountain"
                break
            case 2 :
                tileImageType = "Forest"
                break
            default :
                break
        }
        images[tileImageNum].image = UIImage(named:tileImageType)
    }
    
    func getRows() -> Int
    {
        return rows
    }
    
    func getColumns() -> Int
    {
        return columns
    }
        
    func drawScreen(#rowNum:Int, columnNum:Int, inout images:[UIImageView])
    {
        for imageNum in 0...self.screenRows * self.screenColumns - 1
        {
            self.setImage(tileImageNum:imageNum, inputTileImageType:self.map[columnNum - (screenColumns - 1) / 2 + (imageNum % screenRows)][rowNum - (screenRows - 1) / 2 + (imageNum % screenColumns)], images:&images)
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

