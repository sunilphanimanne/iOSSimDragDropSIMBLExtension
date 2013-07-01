//
//  DragDropManager.h
//  iOSSimulatorExtension
//
//  Created by Sunil Phani Manne on 26/06/13.
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DraggableItem;

@interface DragDropManager : NSObject

/** @return the singleton instance of DragDropManager */
+(DragDropManager*) sharedInstance;

/** @brief Registers a DraggableItem */
-(BOOL) registerDraggableItem: (id <DraggableItem>) draggedItem;

/** @brief Unregisters the given DraggableItem */
-(BOOL) unregisterDraggableItem: (id <DraggableItem>) draggedItem;

/** @return YES if ANY one or more items in the given array are registered with this DragDropManager else NO.*/
-(BOOL) isDragAllowedForItems: (NSArray*) draggedItems;

/** @brief re-groups the draggedItems and dispatches the actions to the corresponding DraggableItem synchronously. */
-(void) performDragActionsForItems: (NSArray*) draggedItems withDragOperation: (NSDragOperation) dragOpertaion;

@end

@interface DragInfo : NSObject
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, assign) NSDragOperation dragOperation;
@end
