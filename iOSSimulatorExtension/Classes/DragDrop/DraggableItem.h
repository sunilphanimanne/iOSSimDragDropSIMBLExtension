//
//  DraggableItem.h
//  iOSSimulatorExtension
//
//  Created by Sunil Phani Manne on 26/06/13.
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief    defines the protocol to write drag-drop extensions of different types.
 */
@protocol DraggableItem <NSObject, NSCopying>

@required
/**
 @return    the extension of the file that was dragged. <code>nil</code> in case if the dragged
                 item is a folder or file with out extension.
 */
-(NSString*) extensionName;

/**
 @brief     DragDropManager calls this back when the item is dragged and dropped on the destination.
 @param  file names of the items that were drag-dropped on the destination.
 */
-(void) performActionOnDrop: (NSArray*) itemNames withDragOption: (NSDragOperation) dragOption;

/**
 @brief     DragDropManager calls this back to stop the action on the given items that was started with
                <code>performActionOnDrop: withDragOption:</code>
 @param  file names of the items whose action has to be stopped.
 */
-(void) stopActionOnTheItems: (NSArray*) itemNames;

@optional
/** 
 @return    the Icon's filename which is displayed when the file is being dragged.
 */
-(NSString*) iconToDisplay;

@end
