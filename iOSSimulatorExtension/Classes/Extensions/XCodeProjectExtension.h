//
//  XCodeProjectExtension.h
//  iOSSimulatorExtension
//
//  Created by Sunil Phani Manne on 27/06/13.
//  Copyright (c) 2013 sunilphanimanne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DraggableItem.h"

@interface XCodeProjectExtension : NSObject <DraggableItem>
+(XCodeProjectExtension*) sharedInstance;
@end
