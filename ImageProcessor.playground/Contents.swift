//: Playground - noun: a place where people can play

import UIKit

protocol Filter {
    
    
    // Brightness
    func brightnessFilter(pixel pixel:Pixel) -> Pixel
    // ExpandRedArea
    func expandRedAreaFilter(pixel pixel:Pixel) -> Pixel
    // RemoveGreen
    func removeGreeFilter(pixel pixel:Pixel) -> Pixel
    // BlueFilter
    func blueFilter(pixel pixel:Pixel) -> Pixel
    // ContrastFilter
    func contrastFilter(pixel pixel:Pixel) -> Pixel
}


enum FilterList: String  {
    case Brightness = "Brightness"
    case ExpandRedArea = "ExpandRedArea"
    case RemoveGreen = "RemoveGreen"
    case BlueFilter = "BlueFilter"
    case ContrastFilter = "ContrastFilter"
}


class ImageProcessor: Filter {
    
    var filterArray:[FilterList] = []
    var image: UIImage?
    var rgbaImage:RGBAImage?
    var totalRedCount:Int = 0
    var totalGreenCount:Int = 0
    var totalBlueCount:Int = 0
    var avrgRed:Int = 0
    var avrgGreen: Int = 0
    var avrgBlue:Int = 0
    
    
    init() {
        self.image = UIImage(named: "sample")
        self.rgbaImage = RGBAImage(image: self.image!)
        setTotalRedGreenBlueColor()
        setAverageRedGreenBlue()
    }
    
    func setTotalRedGreenBlueColor() {
        // loop the whole image
        for y in 0..<rgbaImage!.height {
            for x in 0..<rgbaImage!.width {
                let index = y * rgbaImage!.width + x
                let pixel = rgbaImage!.pixels[index]
                totalRedCount += Int(pixel.red)
                totalGreenCount += Int(pixel.green)
                totalBlueCount += Int(pixel.blue)
            }
        }
    }
    
    func setAverageRedGreenBlue() {
        avrgRed = totalRedCount / (rgbaImage!.width * rgbaImage!.height)
        avrgGreen = totalGreenCount / (rgbaImage!.width * rgbaImage!.height)
        avrgBlue = totalBlueCount / (rgbaImage!.width * rgbaImage!.height)
    }

    
    func addFilter(filterString filterString:FilterList.RawValue) {
        switch (filterString) {
        case FilterList.Brightness.rawValue:
            filterArray.append(FilterList.Brightness)
           break
        case FilterList.ExpandRedArea.rawValue:
            filterArray.append(FilterList.ExpandRedArea)
            break
        case FilterList.RemoveGreen.rawValue:
            filterArray.append(FilterList.RemoveGreen)
            break
        case FilterList.BlueFilter.rawValue:
            filterArray.append(FilterList.BlueFilter)
        case FilterList.ContrastFilter.rawValue:
            filterArray.append(FilterList.ContrastFilter)
            break
        default:
            print("Nothing to do")
        }
    }
    
    func implementFiltersToImage() ->UIImage  {
        for y in 0..<rgbaImage!.height {
            for x in 0..<rgbaImage!.width {
                let index = y * rgbaImage!.width + x
                var pixel = rgbaImage!.pixels[index]
                
                // loop FilterList
                for filter in filterArray{
                    switch filter {
                        
                    // Brightness
                    case .Brightness:
                        pixel = brightnessFilter(pixel: pixel)
                        break
                        
                    // ExpandRedArea
                    case .ExpandRedArea:
                        pixel = expandRedAreaFilter(pixel: pixel)
                        break
                        
                    //RemoveGreen
                    case .RemoveGreen:
                        pixel = removeGreeFilter(pixel: pixel)
                        break
                        
                    // BlueFilter
                    case .BlueFilter:
                        pixel = blueFilter(pixel: pixel)
                        break
                        
                    // ContrastFilter  //-> got this from Google
                    case .ContrastFilter:
                        pixel = contrastFilter(pixel: pixel)
                        break
                    }
                }
                
                rgbaImage!.pixels[index] = pixel
            }
        }
        return rgbaImage!.toUIImage()!
    }
    
    
    //*----------------- Confirm Filter Protocol Methods ------------------------*//
    func brightnessFilter(var pixel pixel: Pixel) -> Pixel {
        pixel.alpha = 100
        return pixel
    }
    
    func expandRedAreaFilter(var pixel pixel:Pixel) -> Pixel {
        let redDiff = Int(pixel.red) - avrgRed
        if (redDiff > 0) {
            pixel.red = UInt8( max(0, min(255, avrgRed + redDiff*5)))
            print("red")
        }
        return pixel
    }
    
    func removeGreeFilter(var pixel pixel:Pixel) -> Pixel {
        pixel.green = 0
        return pixel
    }
    
    func blueFilter(var pixel pixel:Pixel) -> Pixel {
        pixel.blue = UInt8(avrgBlue)
        return pixel
    }
    
    func contrastFilter(var pixel pixel: Pixel) -> Pixel {
        let redDelta = Int(pixel.red) - avrgRed
        let greenDelta = Int(pixel.green) - avrgGreen
        let blueDelta = Int(pixel.blue) - avrgBlue
        pixel.red = UInt8(max(min(255, avrgRed + 20 * redDelta), 0))
        pixel.green = UInt8(max(min(255, avrgGreen + 20 * greenDelta), 0))
        pixel.blue = UInt8(max(min(255, avrgBlue + 20 * blueDelta), 0))
        
        return pixel
    }
    //*----------------------------------------------------------------------------*//
}

var imageProcessor = ImageProcessor()

// default image
imageProcessor.implementFiltersToImage()

//----------------------- Five Filter Sequently ----------------------------//
// expand red area filter
//imageProcessor.addFilter(filterString: FilterList.ExpandRedArea.rawValue)
//imageProcessor.implementFiltersToImage()

// blue filter
///imageProcessor.addFilter(filterString: FilterList.BlueFilter.rawValue)
//imageProcessor.implementFiltersToImage()

// remove green color filter
///imageProcessor.addFilter(filterString: FilterList.RemoveGreen.rawValue)
//imageProcessor.implementFiltersToImage()

// contrast filter
//imageProcessor.addFilter(filterString: FilterList.ContrastFilter.rawValue)
//imageProcessor.implementFiltersToImage()

// brightness filter
imageProcessor.addFilter(filterString: FilterList.Brightness.rawValue)

// dispaly image after 5 Filters
imageProcessor.implementFiltersToImage()
//-----------------------------------------------------------------------------//

// return to default case 
var imageProcessorNew = ImageProcessor()
imageProcessorNew.implementFiltersToImage()





