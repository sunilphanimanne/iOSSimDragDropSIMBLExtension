//
//  ShellScriptRunner.h
//  iPhone Simulator Capture
//
//  Created by Sunil Phani Manne on 20/06/13.
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMShellWrapper.h"

@interface ShellScriptRunner : NSObject {
    id <AMShellWrapperDelegate> _sender;
    AMShellWrapper *_shellWrapper;
}

-(id) initWithSender: (id) sender;
-(void) runCommand:(NSString*) commandToRun;
-(void) stopCommand;
@end
