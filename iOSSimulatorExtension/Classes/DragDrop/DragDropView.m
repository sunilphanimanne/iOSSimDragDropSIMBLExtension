//
//  DragDropView.m
//  iPhone Simulator Capture
//
//  Created by Sunil Phani Manne on 20/06/13.
//  Based on CocoaDragAndDrag from Apple
//
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import "DragDropView.h"
#import "DragDropManager.h"

@implementation DragDropView

- (id)initWithCoder:(NSCoder *)coder
{
    self=[super initWithCoder:coder];
    if ( self ) {
        //Register the types
        NSArray *pasteboardTypes = [NSArray arrayWithObjects:NSFilenamesPboardType, nil];
        [self registerForDraggedTypes:pasteboardTypes];
    }
    return self;
}

#pragma mark - Destination Operations

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSLog(@"Dragging Entered");
    // Check if the source/user wants it copied
    if ([sender draggingSourceOperationMask] &
        NSDragOperationEvery ) {
        
        //highlight our drop zone
        highlight=YES;
        [self setNeedsDisplay: YES];
        
        //accept data as a copy operation
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    highlight=NO;
    [self setNeedsDisplay: YES];
}

-(void)drawRect:(NSRect)rect
{
    //do the usual draw operation to display the image
    [super drawRect:rect];
    
    if ( highlight ) {
        //highlight by overlaying a gray border
        [[NSColor grayColor] set];
        [NSBezierPath setDefaultLineWidth: 5];
        [NSBezierPath strokeRect: rect];
    }
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    //finished with the drag so remove any highlighting
    highlight=NO;
    [self setNeedsDisplay: YES];
    NSLog(@"prepareForDragOperation: DraggingSourceOperationMask: %ld", sender.draggingSourceOperationMask);
    
    //check to see if we can accept the data
    NSArray *draggedFilenames = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    NSLog(@"Dragged FileNames: %@", draggedFilenames);
    return [[DragDropManager sharedInstance] isDragAllowedForItems:draggedFilenames];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    if ( [sender draggingSource] != self ) {
        NSLog(@"performDragOperation: DraggingSourceOperationMask: %ld", sender.draggingSourceOperationMask);
        NSArray *draggedFilenames = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
        [[DragDropManager sharedInstance] performDragActionsForItems:draggedFilenames
                                                                                withDragOperation:sender.draggingSourceOperationMask];
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark Handling Keyboard Events

//- (BOOL)acceptsFirstResponder {
//    NSLog(@"acceptsFirstResponder: YES");
//    return YES;
//}
//
//- (void)keyDown:(NSEvent *)theEvent {
//    NSLog(@"Key Down Event trapped");
//    if ([theEvent modifierFlags] & NSNumericPadKeyMask & NSCommandKeyMask) {
//        NSLog(@"Command Arrow Pressed");
//    }
//}


@end
