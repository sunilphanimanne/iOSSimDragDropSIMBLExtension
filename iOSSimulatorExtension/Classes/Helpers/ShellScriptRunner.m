//
//  ShellScriptRunner.m
//  iPhone Simulator Capture
//
//  Created by Sunil Phani Manne on 20/06/13.
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import "SynthesizeSingleton.h"
#import "ShellScriptRunner.h"
#import "ExtensionController.h"

@implementation ShellScriptRunner

-(id) initWithSender: (id) sender {
    self = [super init];
    if (self) {
        _sender = sender;
    }
    return self;
}

-(void) runCommand:(NSString*) commandToRun
{
    NSString *trimmedCommand = [commandToRun stringByStandardizingPath];
    NSArray *arguments = [trimmedCommand componentsSeparatedByString:@","];
    
    _shellWrapper = [[AMShellWrapper alloc] initWithInputPipe:nil outputPipe:nil errorPipe:nil workingDirectory:@"." environment:nil arguments:arguments context:NULL];
    [_shellWrapper setDelegate:_sender];
	
	if (_shellWrapper) {
        [_shellWrapper setOutputStringEncoding:NSUTF8StringEncoding];
		[_shellWrapper startProcess];
	} else {
        NSLog(@"Unable to start the process...");
	}
}

-(void) stopCommand
{
    [_shellWrapper stopProcess];
}

-(void) dealloc {
    [_shellWrapper release];
    [super dealloc];
}

@end
