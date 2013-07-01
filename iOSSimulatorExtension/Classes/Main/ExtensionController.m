//
//  ExtensionController.m
//  iPhone Simulator Extension
//
//  Created by Sunil Phani Manne on 18/06/13.
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import <objc/runtime.h>
#import "ExtensionController.h"
#import "SynthesizeSingleton.h"
#import "iPhone Simulator.h"
#import "DragDropView.h"
#import "DragDropManager.h"
#import "XCodeProjectExtension.h"

#define BOTTOM_SPACE 98

static MonitorWindow *monitorWindow_;
static SimulatorView *simulatorView_;
static SimulatorGlassView *simulatorGlassView_;
static SimulatorFrameView *simulatorBox_;
static SimulatorHomeView *simulatorHomeView_;

@interface ExtensionController()
+(void) loadIPhoneSimulatorEquipment;
+(NSRect) calculateShadedFrame;
+(NSRect) calculateDragDropFrame;
@end

@implementation ExtensionController

@synthesize myWindow;
@synthesize myView;
@synthesize progressIndicator;
@synthesize statusField;
@synthesize projectField;
@synthesize stopButton;

SYNTHESIZE_SINGLETON_FOR_CLASS(ExtensionController)

- (id)init
{
	self = [super init];
	if (self != nil) {
        //Load the StatusWindow and associate the Outlets
        [NSBundle loadNibNamed:@"StatusWindow" owner:self];
        [self.statusField setStringValue:@""];
	}
	return self;
}

-(void) dealloc {
    //Now, let us do some serious releasing!
    self.myWindow = nil;
    self.myView = nil;
    self.progressIndicator = nil;
    self.statusField = nil;
    self.projectField = nil;
    self.stopButton = nil;
    [super dealloc];
}

//Let the fun begin... SIMBL does the magic for me :P
+ (void)load
{
	//Force creation of shared object
    [ExtensionController sharedInstance];
    
    //Load all the iPhone Simulator equipment...
    [self loadIPhoneSimulatorEquipment];
    
    //Register the Drag Drop Extensions...
    [self registerDragDropExtensions];
    
    //... and inject the code...
    [self addDragDropView];
    NSLog(@"Successfully Injected...");
}

+(void) loadIPhoneSimulatorEquipment {
    id delegate = [NSApp delegate];
    monitorWindow_ = [delegate monitorWindow];
    simulatorView_ = [delegate simulatorView];
    simulatorGlassView_ = [delegate glassView];
    simulatorBox_ = [delegate simulatorBox];
    simulatorHomeView_ = [delegate simulatorHomeView];
}

+(void) registerDragDropExtensions {
    NSLog(@"Registering XCode PbxProj  Extension...");
    [[DragDropManager sharedInstance] registerDraggableItem:[XCodeProjectExtension sharedInstance]];
}

-(void) blockTheUI {
    [self addWindow:myView];
}

-(void) unblockTheUI {
    [self removeWindow];
}

//TODO: Handle different sizes for different scale sizes (50%, 75% and 100%) of simulator...
+(NSRect) calculateShadedFrame {
    //TODO: Tweaky way of doing it... Have to find a better way...
    //Calculate the appropriate rect
    NSPoint myViewOrigin = NSPointFromCGPoint(
                                                        CGPointMake(
                                                          monitorWindow_.frame.origin.x + simulatorGlassView_.frame.origin.x,
                                                          monitorWindow_.frame.origin.y + simulatorGlassView_.frame.origin.y - BOTTOM_SPACE
                                                          )
                                              );
    NSSize myViewSize = simulatorGlassView_.frame.size;
    
    NSRect newRect = NSRectFromCGRect(
                                            CGRectMake(
                                                       myViewOrigin.x,
                                                       myViewOrigin.y,
                                                       myViewSize.width,
                                                       myViewSize.height + BOTTOM_SPACE
                                                       )
                                      );
    return newRect;
}

+(NSRect) calculateDragDropFrame {
    return [[monitorWindow_ contentView] frame];
}

//TODO: Handle the Orientation changes cases...
-(void) addWindow: (NSView*) view {
    NSRect shadedRect = [ExtensionController calculateShadedFrame];
    
    //Create the custom window
    self.myWindow = [[CustomWindow alloc]
                     initWithContentRect:NSMakeRect(shadedRect.origin.x,
                                                    shadedRect.origin.y,
                                                    shadedRect.size.width,
                                                    shadedRect.size.height)
                     styleMask:NSBorderlessWindowMask
                     backing:NSBackingStoreBuffered
                     defer:YES];
    
    self.myWindow.opaque = NO;
    self.myWindow.alphaValue = 0.7;
    self.myWindow.backgroundColor = [NSColor blackColor];
    [self.myWindow setMovable:NO];
    
    //Add to the simulator's mainWindow
    [monitorWindow_ addChildWindow:myWindow ordered:NSWindowAbove];

    //Load the view from the bundle...
    [NSBundle loadNibNamed:@"MyWindow" owner:self];
    [self.myWindow setContentView:myView];
    [self.myWindow setHidesOnDeactivate:YES];
    [self.myWindow makeKeyAndOrderFront:self];
    
    //Show the Progress Indicator...
    [self showProgressIndicator];
}

-(void) removeWindow {
    if([self.myWindow isKeyWindow]) {
        [self.myWindow resignKeyWindow];
        [monitorWindow_ removeChildWindow:self.myWindow];
        [monitorWindow_ makeKeyAndOrderFront:self];
        [self.myWindow release];
        self.myWindow = nil;
        [self hideProgressIndicator];
    }
}

-(void) showProgressIndicator {
    [self.progressIndicator setBezeled:YES];
    //TODO: Handle different sizes for different Scale factor simulators...
//    [self.progressIndicator setControlSize:NSSmallControlSize];
    [self.progressIndicator setUsesThreadedAnimation:NO];
    [self.progressIndicator startAnimation:self];
}

-(void) hideProgressIndicator {
    [self.progressIndicator stopAnimation:self];
}

//TODO: There is a slight border where the drag-n-drop still triggers the Simulator's default drag-drop...
+ (void) addDragDropView {
    NSRect rect = [self calculateDragDropFrame];
    DragDropView *imageView = [[DragDropView alloc] initWithFrame:rect];
    [simulatorView_ addSubview:imageView];
}

-(IBAction)stopButtonAction:(id)sender {
    NSLog(@"Nothing as of now...");
}

@end
