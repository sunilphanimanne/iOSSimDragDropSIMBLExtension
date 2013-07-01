//
//  XCodeProjectExtension.m
//  iOSSimulatorExtension
//
//  Created by Sunil Phani Manne on 27/06/13.
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import "XCodeProjectExtension.h"
#import "SynthesizeSingleton.h"
#import "ShellScriptRunner.h"

#define XCODE_PROJECT_FILE_EXTENSION @"pbxproj"

@interface XCodeProjectExtension() {
    ShellScriptRunner *_shellScriptRunner;
}

-(void) performActionOnDropIgnoringKeysPressed: (NSArray*) itemNames;

@end

@implementation XCodeProjectExtension

//Singleton for XCodeProjectExtension!
SYNTHESIZE_SINGLETON_FOR_CLASS(XCodeProjectExtension);

#pragma mark -
#pragma mark Protocol Methods:

-(NSString*) extensionName {
    return XCODE_PROJECT_FILE_EXTENSION;
}

-(void) performActionOnDrop: (NSArray*) itemNames  withDragOption:(NSDragOperation)dragOption{
    _shellScriptRunner = [[ShellScriptRunner alloc] initWithSender:self];
    
    switch (dragOption) {
        case NSDragOperationLink:
            NSLog(@"Control Pressed");
            break;
        case NSDragOperationCopy:
            NSLog(@"Option Pressed");
            break;
        case NSDragOperationGeneric:
            NSLog(@"Command Pressed");
            break;
        case NSDragOperationLink | NSDragOperationCopy:
            NSLog(@"Control + Option Pressed");
            break;
        case NSDragOperationLink | NSDragOperationGeneric:
            NSLog(@"Control + Command Pressed");
            break;
        case NSDragOperationCopy | NSDragOperationGeneric:
            NSLog(@"Option + Command Pressed");
            break;
        case NSDragOperationLink | NSDragOperationCopy | NSDragOperationGeneric:
            NSLog(@"Control + Option + Command Pressed");
            break;
        default:
            NSLog(@"NONE Pressed");
            break;
    }
    
    //Ignore the keys pressed and run the script...
    [self performActionOnDropIgnoringKeysPressed:itemNames];
}

-(void) stopActionOnTheItems:(NSArray *)itemNames {
    //TODO: Implement this...
    NSLog(@"Stop the action!");
}

-(void) performActionOnDropIgnoringKeysPressed: (NSArray*) itemNames {
    NSLog(@"Performing Action On Drop.... with itemNames: %@", itemNames);
}

@end
