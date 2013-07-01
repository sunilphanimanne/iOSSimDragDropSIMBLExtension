//
//  DragDropManager.m
//  iOSSimulatorExtension
//
//  Created by Sunil Phani Manne on 26/06/13.
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import "DragDropManager.h"
#import "SynthesizeSingleton.h"
#import "DraggableItem.h"

#pragma mark -
#pragma mark Extension:

@interface DragDropManager()
/** 
    @brief returns the queue which holds the actions of a draggableItem; if not exists, creates a new one and returns.
 */
-(NSMutableArray*) getActionQueueForDraggableItem: (id<DraggableItem>) draggableItem;

/**
  @brief dispatches actions to all the registered draggableItems.
 */
-(void) dispatchActions;

/**
 @brief removes the entries of the given item from the dispatchActionTable and dragOperationTable.
 */
-(void) removeTheEntriesForDraggableItem: (id <DraggableItem>) item;

@property (nonatomic, retain) NSMutableDictionary *draggableItems;
@property (nonatomic, retain) NSMutableDictionary *dispatchActionTable;
@property (nonatomic, retain) NSMutableDictionary *dragOperationTable;
@end

#pragma mark -

@implementation DragDropManager

@synthesize draggableItems, dispatchActionTable, dragOperationTable;

//Make the DragDropManager as a singleton!
SYNTHESIZE_SINGLETON_FOR_CLASS(DragDropManager);

- (id)init
{
	self = [super init];
	if (self != nil) {
        self.draggableItems = [NSMutableDictionary dictionaryWithCapacity:1];
        self.dispatchActionTable = [NSMutableDictionary dictionaryWithCapacity:1];
        self.dragOperationTable = [NSMutableDictionary dictionaryWithCapacity:1];
	}
	return self;
}

-(void) dealloc {
    self.draggableItems = nil;
    self.dispatchActionTable = nil;
    self.dragOperationTable = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Registration/Unregistration Methods:

-(BOOL) registerDraggableItem:(id<DraggableItem>)draggableItem {
    BOOL isRegistrationSuccessful = YES;
    
    @synchronized(self.draggableItems) {
        [self.draggableItems setObject:draggableItem forKey:[draggableItem extensionName]];
    }
    
    return isRegistrationSuccessful;
}

-(BOOL) unregisterDraggableItem:(id<DraggableItem>)draggableItem {
    BOOL isUnregistrationSuccesful = YES;
    
    @synchronized(self.draggableItems) {
        [self.draggableItems removeObjectForKey:[draggableItem extensionName]];
    }
    
    return isUnregistrationSuccesful;
}

#pragma mark -

#pragma mark Methods called by DragDropView:

-(BOOL) isDragAllowedForItems: (NSArray*) draggedItems {
    BOOL isDragAllowed = NO;
    
    for(NSString *anItem in draggedItems) {
        NSString *itemExtension = [anItem pathExtension];
        @synchronized(self.draggableItems) {
            if([self.draggableItems objectForKey:itemExtension]) {
                isDragAllowed = YES;
                break;
            }else {
                continue;
            }
        }
    }
    NSLog(@"isDragAllowed: %@", isDragAllowed?@"YES":@"NO");
    return isDragAllowed;
}

//Synchronously (AS OF NOW) dispatches the actions on to the respective DraggedItem..!
-(void) performDragActionsForItems: (NSArray*) draggedItems withDragOperation:(NSDragOperation)dragOpertaion{
    //First, group the actions of draggedItems...
    for(NSString *anItem in draggedItems) {
        NSString *itemExtension  = [anItem pathExtension];
        @synchronized(self.draggableItems) {
            id <DraggableItem> draggableItem = [self.draggableItems objectForKey:itemExtension];
            @synchronized(self.dispatchActionTable) {
                [[self getActionQueueForDraggableItem:draggableItem] addObject:anItem];
            }
            //TODO: Handle this in a better way!
            @synchronized(self.dragOperationTable) {
                NSNumber *dragOperationObject = [NSNumber numberWithUnsignedInteger:dragOpertaion];
                //Add ONLY once... per draggableItem...
                if(![self.dragOperationTable objectForKey:draggableItem]) {
                    [self.dragOperationTable setObject: dragOperationObject forKey:draggableItem];
                }
            }
        }
    }
    //... then dispatch them.
    [self dispatchActions];
}

#pragma mark -

#pragma mark Private Methods:

-(NSMutableArray*) getActionQueueForDraggableItem: (id<DraggableItem>) draggableItem {
    NSMutableArray *actionQueue = [self.dispatchActionTable objectForKey:draggableItem];
    if(actionQueue == nil) {
        actionQueue = [NSMutableArray array];
        @synchronized(self.dispatchActionTable) {
            [self.dispatchActionTable setObject:actionQueue forKey:draggableItem];
        }
    }
    return actionQueue;
}

-(void) dispatchActions {
    @synchronized(self.dispatchActionTable) {
        //Dispatch each Queue to the corresponding 
        for (id <DraggableItem> aDraggableItem  in self.dispatchActionTable) {
            NSArray *itemNames = [self.dispatchActionTable objectForKey:aDraggableItem];
            NSDragOperation dragOperation = [[self.dragOperationTable objectForKey:aDraggableItem] unsignedIntegerValue];
            
            //Dispatch the action..
            [aDraggableItem performActionOnDrop:itemNames withDragOption:dragOperation];
            
            //.. and remove from the dispatchActionTable and dragOperationTable!
            [self removeTheEntriesForDraggableItem:aDraggableItem];
        }
    }
}

-(void) removeTheEntriesForDraggableItem: (id <DraggableItem>) item {
    [self.dispatchActionTable removeObjectForKey:item];
    [self .dragOperationTable removeObjectForKey:item];
}

#pragma mark -

@end

