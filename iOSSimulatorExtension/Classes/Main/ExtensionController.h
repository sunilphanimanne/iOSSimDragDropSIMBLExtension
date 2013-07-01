//
//  ExtensionController.h
//  iPhone Simulator Extension
//
//  Created by Sunil Phani Manne on 18/06/13.
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "CustomWindow.h"
#import "iPhone Simulator.h"


//TODO: Make this class INDEPENDENT of the UI... Let the extensions handle their own UI...

@interface ExtensionController : NSObject {
    CustomWindow *myWindow;
    IBOutlet NSView *myView;
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet NSTextField *statusField;
    IBOutlet NSTextField *projectField;
    IBOutlet NSButton *stopButton;
}

@property (nonatomic, retain) NSWindow *myWindow;
@property (nonatomic, assign) IBOutlet NSView *myView;
@property (nonatomic, assign) IBOutlet NSProgressIndicator *progressIndicator;
@property (nonatomic, assign) IBOutlet NSTextField *statusField;
@property (nonatomic, assign) IBOutlet NSTextField *projectField;
@property (nonatomic, assign) IBOutlet NSButton *stopButton;


+(ExtensionController *) sharedInstance;
+ (void)load;

-(void) blockTheUI;
-(void) unblockTheUI;
+(void) addDragDropView;
-(void) addWindow: (NSView*) view;

-(IBAction)stopButtonAction:(id)sender;

@end
