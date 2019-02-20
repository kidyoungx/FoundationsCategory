//
//  NSImage+CCCategory.m
//  CinCer
//
//  Created by Kid Young on 10/2/15.
//  Copyright © 2015 Yang XiHong. All rights reserved.
//

#import "NSImage+CCCategory.h"

@implementation NSImage (CCCategory)
#pragma mark - Grayscale
+ (NSImage *)grayscaleImage:(NSImage *)image
{
    CGImageRef inImage = [NSImage CGImageRefCopyFromNSImage:image];
    CGImageRef imgSourceData = [NSImage SourceDataImageRefCopyFromCGImageRef:inImage];
    CGImageRef imgAlphaData = [NSImage AlphaDataImageRefCopyFromCGImageRef:inImage];
    CGImageRef imgResultData = CGImageCreateWithMask(imgSourceData, imgAlphaData);
    NSImage *imgResult = [NSImage imageFromCGImageRef:imgResultData];
    CGImageRelease(inImage);
    CGImageRelease(imgSourceData);
    CGImageRelease(imgAlphaData);
    CGImageRelease(imgResultData);
    return imgResult;
}

+ (CGImageRef)CGImageRefCopyFromNSImage:(NSImage *)image
{
    NSSize size = [image size];
    if (size.width == 0 || size.height ==0) {
        NSBitmapImageRep * rep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
        NSSize imgSize = NSMakeSize([rep pixelsWide],[rep pixelsHigh]);
        image.size = imgSize;
    }
    NSData *imageData = [image TIFFRepresentation];
    CGImageRef imageRef = NULL;
    if (imageData) {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(imageData), NULL);
        imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        CFRelease(imageSource);
    }
    return imageRef;
}

+ (CGImageRef)SourceDataImageRefCopyFromCGImageRef:(CGImageRef)img
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
    size_t pixelsWide = CGImageGetWidth(img);
    size_t pixelsHigh = CGImageGetHeight(img);
    //int	bitmapBytesPerRow = pixelsWide * (enableAlaph ? 4 : 1);
    size_t bitmapBytesPerRow = pixelsWide;
    CGContextRef context = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorspace, kCGImageAlphaNone);
    CGRect rect = {{0, 0}, {pixelsWide, pixelsHigh}};
    CGContextDrawImage(context, rect, img);
    CGImageRef test = CGBitmapContextCreateImage(context) ;  //need release out
    CGColorSpaceRelease(colorspace);
    CGContextRelease(context);
    return test;
}

+ (CGImageRef)AlphaDataImageRefCopyFromCGImageRef:(CGImageRef)img
{
    size_t pixelsWide = CGImageGetWidth(img);
    size_t pixelsHigh = CGImageGetHeight(img);
    //int	bitmapBytesPerRow = pixelsWide * (enableAlaph ? 4 : 1);
    size_t bitmapBytesPerRow = pixelsWide;
    CGContextRef context = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, NULL, kCGImageAlphaOnly);  //need release
    CGRect rect = {{0, 0}, {pixelsWide, pixelsHigh}};
    CGContextDrawImage(context, rect, img);
    CGImageRef test = CGBitmapContextCreateImage(context) ;  //need release out
    CGContextRelease(context);
    return test;
}

+ (NSImage *)imageFromCGImageRef:(CGImageRef)image
{
    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
    imageRect.size.height = CGImageGetHeight(image);
    imageRect.size.width = CGImageGetWidth(image);
    // Create a new image to receive the Quartz image data.
    if (imageRect.size.height == 0 ||imageRect.size.width == 0) {
        NSLog(@"NSImageFromCGImageRef should not be here!!!,CGImageRef is %@",image);
    }
    NSImage *newImage = [[NSImage alloc] initWithSize:imageRect.size];
    [newImage lockFocus];
    // Get the Quartz context and draw.
    CGContextRef imageContext = (CGContextRef)[NSGraphicsContext.currentContext graphicsPort];
    CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image);
    [newImage unlockFocus];
    return newImage;
}

#pragma mark - Scale factor
+ (NSImage *)imageToGreyImage:(NSImage *)image
{
    // Create image rectangle with current image width/height
    CGFloat actualWidth = image.size.width;
    CGFloat actualHeight = image.size.height;
    CGRect imageRect = CGRectMake(0, 0, actualWidth, actualHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, [NSImage nsImageToCGImageRef:image]);
    CGImageRef grayImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, nil, (CGBitmapInfo)kCGImageAlphaOnly);
    CGContextDrawImage(context, imageRect, [NSImage nsImageToCGImageRef:image]);
    CGImageRef mask = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    NSImage *grayScaleImage =  [NSImage imageFromCGImageRef:CGImageCreateWithMask(grayImage, mask)];
    CGImageRelease(grayImage);
    CGImageRelease(mask);
    // Return the new grayscale image
    return grayScaleImage;
}

+ (CGImageRef)nsImageToCGImageRef:(NSImage*)image;
{
    NSData * imageData = [image TIFFRepresentation];
    CGImageRef imageRef;
    if (!imageData) {
        return nil;
    }
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    return imageRef;
}

#pragma mark - Tint
+ (NSImage *)imageTintedWithColor:(NSColor *)tint image:(NSImage *)imageO
{
    NSImage *image = [imageO copy];
    if (tint) {
        [image lockFocus];
        [tint set];
        NSRect imageRect = {NSZeroPoint, [image size]};
        NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
        [image unlockFocus];
    }
    return image;
}

@end
