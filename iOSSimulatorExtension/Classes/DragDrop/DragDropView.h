//
//  DragDropView.h
//  iPhone Simulator Extension
//
//  Created by Sunil Phani Manne on 18/06/13.
//  Based on CocoaDragAndDrag from Apple
//
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

//TODO: Why should this be NSImageView? Find out why NSView was not working...

@interface DragDropView : NSImageView <NSDraggingDestination>
{
    BOOL highlight;
}

- (id)initWithCoder:(NSCoder *)coder;

@end
