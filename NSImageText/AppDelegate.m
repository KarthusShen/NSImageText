//
//  AppDelegate.m
//  NSImageText
//
//  Created by Karthus on 2017/12/14.
//  Copyright © 2017年 karthus. All rights reserved.
//

#import "AppDelegate.h"

#define IMAGE_MAX_WIDTH 720
#define IMAGE_MIN_WIDTH 720

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *or_testField;
@property (weak) IBOutlet NSTextField *scaled_textField;

@property (strong, nonatomic) NSImage * originalImage;
@property (strong, nonatomic) NSImage * scaledImage;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)clickBtnLoadImage:(id)sender
{
    NSString *filePath = _or_testField.stringValue;
    _originalImage = [[NSImage alloc] initWithContentsOfFile:filePath];
    NSLog(@"%@", _originalImage);
}

- (IBAction)clickBtnScaleImage:(id)sender
{
    NSSize scaledSize = [self caculateImageSize:_originalImage.size.width Height:_originalImage.size.height];
    NSImage * scaledImage = [[NSImage alloc]initWithSize:scaledSize];
    [scaledImage lockFocus];
    [_originalImage setSize:scaledSize];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [_originalImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height) operation:NSCompositeCopy fraction:1.0];
    [scaledImage unlockFocus];
    NSLog(@"%@", scaledImage);
    _scaledImage = scaledImage;
}

- (IBAction)clickBtnSaveNewImage:(id)sender
{
    NSString *destPath = _scaled_textField.stringValue;
    
    NSData * imageData = [_scaledImage TIFFRepresentation];
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc]initWithData:imageData];
    imageRep.size = _scaledImage.size;
    
    
    ///////////png
    //imageData = [imageRep representationUsingType:NSPNGFileType properties:nil];
    
    
    //jpg
    NSDictionary *imageProps = nil;
    NSNumber *quality = [NSNumber numberWithFloat:.85];
    imageProps = [NSDictionary dictionaryWithObject:quality forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
    
    [imageData writeToFile:destPath atomically:YES];

}

//caculate the scaled image size;
- (NSSize)caculateImageSize:(CGFloat)imageWidth Height:(CGFloat)imageHeight
{
    CGFloat scale = imageWidth / imageHeight;
    
    if (imageWidth <= IMAGE_MIN_WIDTH && imageHeight <= IMAGE_MIN_WIDTH)
    {
        if (imageWidth > imageHeight)
        {
            imageHeight = IMAGE_MIN_WIDTH;
            imageWidth = imageHeight * scale;
        }
        else
        {
            imageWidth = IMAGE_MIN_WIDTH;
            imageHeight = imageWidth / scale;
        }
    }
    else if (imageWidth > imageHeight)
    {
        scale = imageWidth / imageHeight;
        
        imageWidth = MAX(imageWidth, IMAGE_MIN_WIDTH);
        imageWidth = MIN(imageWidth, IMAGE_MAX_WIDTH);
        
        imageHeight = imageWidth / scale;
    }
    else
    {
        scale = imageHeight / imageWidth;
        
        imageHeight = MAX(imageHeight, IMAGE_MIN_WIDTH);
        imageHeight = MIN(imageHeight, IMAGE_MAX_WIDTH);
        
        imageWidth = imageHeight / scale;
    }
    NSSize size = NSMakeSize(imageWidth, imageHeight);
    return size;
}
@end
