//
//  virtualization_debug.m
//
//  Created by codehex.
//

#import "virtualization_debug.h"
#import "virtualization_helper.h"

/*!
 @abstract Create a VZGDBDebugStubConfiguration with debug port for GDB server.
*/
void *newVZGDBDebugStubConfiguration(uint32_t port)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[_VZGDBDebugStubConfiguration alloc] initWithPort:(NSInteger)port];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract _VZDebugStubConfiguration. Empty by default.
*/
void setDebugStubVZVirtualMachineConfiguration(void *config, void *debugStub)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZVirtualMachineConfiguration *)config _setDebugStub:(_VZDebugStubConfiguration *)debugStub];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}