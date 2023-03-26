//
//  virtualization_12_arm64.m
//
//  Created by codehex.
//

#ifdef __arm64__
#import "virtualization_12_arm64.h"

@implementation ProgressObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        macOSInstallFractionCompletedHandler(context, progress.fractionCompleted);
        if (progress.finished) {
            [progress removeObserver:self forKeyPath:@"fractionCompleted"];
        }
    }
}
@end

/*!
 @abstract Write an initialized VZMacAuxiliaryStorage to a storagePath on a file system.
 @param storagePath The storagePath to write the auxiliary storage to on the local file system.
 @param hardwareModel The hardware model to use. The auxiliary storage can be laid out differently for different hardware models.
 @param options Initialization options.
 @param error If not nil, used to report errors if creation fails.
 @return A newly initialized VZMacAuxiliaryStorage on success. If an error was encountered returns @c nil, and @c error contains the error.
 */
void *newVZMacAuxiliaryStorageWithCreating(const char *storagePath, void *hardwareModel, void **error)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        NSString *storagePathNSString = [NSString stringWithUTF8String:storagePath];
        NSURL *storageURL = [NSURL fileURLWithPath:storagePathNSString];
        return [[VZMacAuxiliaryStorage alloc] initCreatingStorageAtURL:storageURL
                                                         hardwareModel:(VZMacHardwareModel *)hardwareModel
                                                               options:VZMacAuxiliaryStorageInitializationOptionAllowOverwrite
                                                                 error:(NSError *_Nullable *_Nullable)error];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize the auxiliary storage from the storagePath of an existing file.
 @param URL The URL of the auxiliary storage on the local file system.
 @discussion To create a new auxiliary storage, use -[VZMacAuxiliaryStorage initCreatingStorageAtURL:hardwareModel:options:error].
 */
void *newVZMacAuxiliaryStorage(const char *storagePath)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        NSString *storagePathNSString = [NSString stringWithUTF8String:storagePath];
        NSURL *storageURL = [NSURL fileURLWithPath:storagePathNSString];
        // Use initWithURL: in macOS 13.x
        // https://developer.apple.com/documentation/virtualization/vzmacauxiliarystorage?language=objc
        return [[VZMacAuxiliaryStorage alloc] initWithContentsOfURL:storageURL];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract The platform configuration for booting macOS on Apple Silicon.
 @discussion
    When creating a virtual machine from scratch, the “hardwareModel” and “auxiliaryStorage” depend on the restore image
    that will be used to install macOS.

    To choose the hardware model, start from VZMacOSRestoreImage.mostFeaturefulSupportedConfiguration to get a supported configuration, then
    use its VZMacOSConfigurationRequirements.hardwareModel property to get the hardware model.
    Use the hardware model to set up VZMacPlatformConfiguration and to initialize a new auxiliary storage with
    -[VZMacAuxiliaryStorage initCreatingStorageAtURL:hardwareModel:options:error:].

    When a virtual machine is saved to disk then loaded again, the “hardwareModel”, “machineIdentifier” and “auxiliaryStorage”
    must be restored to their original values.

    If multiple virtual machines are created from the same configuration, each should have a unique  “auxiliaryStorage” and “machineIdentifier”.
 @seealso VZMacOSRestoreImage
 @seealso VZMacOSConfigurationRequirements
*/
void *newVZMacPlatformConfiguration()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZMacPlatformConfiguration alloc] init];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Set the Mac hardware model.
 */
void setHardwareModelVZMacPlatformConfiguration(void *config, void *hardwareModel)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZMacPlatformConfiguration *)config setHardwareModel:(VZMacHardwareModel *)hardwareModel];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

// Store the hardware model to disk so that we can retrieve them for subsequent boots.
void storeHardwareModelDataVZMacPlatformConfiguration(void *config, const char *filePath)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacPlatformConfiguration *macPlatformConfiguration = (VZMacPlatformConfiguration *)config;
        NSString *filePathNSString = [NSString stringWithUTF8String:filePath];
        NSURL *fileURL = [NSURL fileURLWithPath:filePathNSString];
        [macPlatformConfiguration.hardwareModel.dataRepresentation writeToURL:fileURL atomically:YES];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Set the Mac machine identifier.
 @discussion
    Running two virtual machines concurrently with the same identifier results in undefined behavior in the guest operating system.
 */
void setMachineIdentifierVZMacPlatformConfiguration(void *config, void *machineIdentifier)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZMacPlatformConfiguration *)config setMachineIdentifier:(VZMacMachineIdentifier *)machineIdentifier];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

// Store the machine identifier to disk so that we can retrieve them for subsequent boots.
void storeMachineIdentifierDataVZMacPlatformConfiguration(void *config, const char *filePath)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacPlatformConfiguration *macPlatformConfiguration = (VZMacPlatformConfiguration *)config;
        NSString *filePathNSString = [NSString stringWithUTF8String:filePath];
        NSURL *fileURL = [NSURL fileURLWithPath:filePathNSString];
        [macPlatformConfiguration.machineIdentifier.dataRepresentation writeToURL:fileURL atomically:YES];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Set the Mac auxiliary storage.
 @discussion
    When creating a virtual machine from scratch, the hardware model of the “auxiliaryStorage” must match the hardware model of
    the “hardwareModel” property.
 */
void setAuxiliaryStorageVZMacPlatformConfiguration(void *config, void *auxiliaryStorage)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZMacPlatformConfiguration *)config setAuxiliaryStorage:(VZMacAuxiliaryStorage *)auxiliaryStorage];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Boot loader configuration for booting macOS on Apple Silicon.
 @discussion
    You must use a VZMacPlatformConfiguration in conjunction with the macOS boot loader.
    It is invalid to use it with any other platform configuration.
 @see VZMacPlatformConfiguration
 @see VZVirtualMachineConfiguration.platform.
*/
void *newVZMacOSBootLoader()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZMacOSBootLoader alloc] init];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize a new configuration for a Mac graphics device.
 @discussion This device can be used to attach a display to be shown in a VZVirtualMachineView.
*/
void *newVZMacGraphicsDeviceConfiguration()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZMacGraphicsDeviceConfiguration alloc] init];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Set the displays to be attached to this graphics device.
*/
void setDisplaysVZMacGraphicsDeviceConfiguration(void *graphicsConfiguration, void *displays)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZMacGraphicsDeviceConfiguration *)graphicsConfiguration setDisplays:[(NSMutableArray *)displays copy]];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Create a display configuration with the specified pixel dimensions and pixel density.
 @param widthInPixels The width of the display, in pixels.
 @param heightInPixels The height of the display, in pixels.
 @param pixelsPerInch The pixel density as a number of pixels per inch.
*/
void *newVZMacGraphicsDisplayConfiguration(NSInteger widthInPixels, NSInteger heightInPixels, NSInteger pixelsPerInch)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZMacGraphicsDisplayConfiguration alloc]
            initWithWidthInPixels:widthInPixels
                   heightInPixels:heightInPixels
                    pixelsPerInch:pixelsPerInch];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Get the hardware model described by the specified data representation.
 @param dataRepresentation The opaque data representation of the hardware model to be obtained.
 */
void *newVZMacHardwareModelWithPath(const char *hardwareModelPath)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacHardwareModel *hardwareModel;
        NSString *hardwareModelPathNSString = [NSString stringWithUTF8String:hardwareModelPath];
        NSURL *hardwareModelPathURL = [NSURL fileURLWithPath:hardwareModelPathNSString];
        @autoreleasepool {
            NSData *hardwareModelData = [[NSData alloc] initWithContentsOfURL:hardwareModelPathURL];
            hardwareModel = [[VZMacHardwareModel alloc] initWithDataRepresentation:hardwareModelData];
        }
        return hardwareModel;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

void *newVZMacHardwareModelWithBytes(void *hardwareModelBytes, int len)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacHardwareModel *hardwareModel;
        @autoreleasepool {
            NSData *hardwareModelData = [[NSData alloc] initWithBytes:hardwareModelBytes length:(NSUInteger)len];
            hardwareModel = [[VZMacHardwareModel alloc] initWithDataRepresentation:hardwareModelData];
        }
        return hardwareModel;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Create a new unique machine identifier.
 */
void *newVZMacMachineIdentifier()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZMacMachineIdentifier alloc] init];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Get the machine identifier described by the specified data representation.
 @param dataRepresentation The opaque data representation of the machine identifier to be obtained.
 @return A unique identifier identical to the one that generated the dataRepresentation, or nil if the data is invalid.
 @see VZMacMachineIdentifier.dataRepresentation
 */
void *newVZMacMachineIdentifierWithPath(const char *machineIdentifierPath)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacMachineIdentifier *machineIdentifier;
        NSString *machineIdentifierPathNSString = [NSString stringWithUTF8String:machineIdentifierPath];
        NSURL *machineIdentifierPathURL = [NSURL fileURLWithPath:machineIdentifierPathNSString];
        @autoreleasepool {
            NSData *machineIdentifierData = [[NSData alloc] initWithContentsOfURL:machineIdentifierPathURL];
            machineIdentifier = [[VZMacMachineIdentifier alloc] initWithDataRepresentation:machineIdentifierData];
        }
        return machineIdentifier;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

void *newVZMacMachineIdentifierWithBytes(void *machineIdentifierBytes, int len)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacMachineIdentifier *machineIdentifier;
        @autoreleasepool {
            NSData *machineIdentifierData = [[NSData alloc] initWithBytes:machineIdentifierBytes length:(NSUInteger)len];
            machineIdentifier = [[VZMacMachineIdentifier alloc] initWithDataRepresentation:machineIdentifierData];
        }
        return machineIdentifier;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

nbyteslice getVZMacMachineIdentifierDataRepresentation(void *machineIdentifierPtr)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacMachineIdentifier *machineIdentifier = (VZMacMachineIdentifier *)machineIdentifierPtr;
        NSData *data = [machineIdentifier dataRepresentation];
        nbyteslice ret = {
            .ptr = (void *)[data bytes],
            .len = (int)[data length],
        };
        return ret;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

VZMacOSRestoreImageStruct convertVZMacOSRestoreImage2Struct(void *restoreImagePtr)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacOSRestoreImage *restoreImage = (VZMacOSRestoreImage *)restoreImagePtr;
        VZMacOSRestoreImageStruct ret;
        ret.url = [[[restoreImage URL] absoluteString] UTF8String];
        ret.buildVersion = [[restoreImage buildVersion] UTF8String];
        ret.operatingSystemVersion = [restoreImage operatingSystemVersion];
        // maybe unnecessary CFBridgingRetain. if use CFBridgingRetain, should use CFRelease.
        ret.mostFeaturefulSupportedConfiguration = (void *)CFBridgingRetain([restoreImage mostFeaturefulSupportedConfiguration]);
        return ret;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

void fetchLatestSupportedMacOSRestoreImageWithCompletionHandler(void *cgoHandler)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [VZMacOSRestoreImage fetchLatestSupportedWithCompletionHandler:^(VZMacOSRestoreImage *restoreImage, NSError *error) {
            VZMacOSRestoreImageStruct restoreImageStruct = convertVZMacOSRestoreImage2Struct(restoreImage);
            macOSRestoreImageCompletionHandler(cgoHandler, &restoreImageStruct, error);
        }];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

void loadMacOSRestoreImageFile(const char *ipswPath, void *cgoHandler)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        NSString *ipswPathNSString = [NSString stringWithUTF8String:ipswPath];
        NSURL *ipswURL = [NSURL fileURLWithPath:ipswPathNSString];
        [VZMacOSRestoreImage loadFileURL:ipswURL
                       completionHandler:^(VZMacOSRestoreImage *restoreImage, NSError *error) {
                           VZMacOSRestoreImageStruct restoreImageStruct = convertVZMacOSRestoreImage2Struct(restoreImage);
                           macOSRestoreImageCompletionHandler(cgoHandler, &restoreImageStruct, error);
                       }];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

VZMacOSConfigurationRequirementsStruct convertVZMacOSConfigurationRequirements2Struct(void *requirementsPtr)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacOSConfigurationRequirements *requirements = (VZMacOSConfigurationRequirements *)requirementsPtr;
        VZMacOSConfigurationRequirementsStruct ret;
        ret.minimumSupportedCPUCount = (uint64_t)[requirements minimumSupportedCPUCount];
        ret.minimumSupportedMemorySize = (uint64_t)[requirements minimumSupportedMemorySize];
        // maybe unnecessary CFBridgingRetain. if use CFBridgingRetain, should use CFRelease.
        ret.hardwareModel = (void *)CFBridgingRetain([requirements hardwareModel]);
        return ret;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

VZMacHardwareModelStruct convertVZMacHardwareModel2Struct(void *hardwareModelPtr)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacHardwareModel *hardwareModel = (VZMacHardwareModel *)hardwareModelPtr;
        VZMacHardwareModelStruct ret;
        ret.supported = (bool)[hardwareModel isSupported];
        NSData *data = [hardwareModel dataRepresentation];
        nbyteslice retByteSlice = {
            .ptr = (void *)[data bytes],
            .len = (int)[data length],
        };
        ret.dataRepresentation = retByteSlice;
        return ret;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize a VZMacOSInstaller object.
 @param virtualMachine The virtual machine that the operating system will be installed onto.
 @param restoreImageFileURL A file URL indicating the macOS restore image to install.
 @discussion
    The virtual machine platform must be macOS and the restore image URL must be a file URL referring to a file on disk or an exception will be raised.
    This method must be called on the virtual machine's queue.
 */
void *newVZMacOSInstaller(void *virtualMachine, void *vmQueue, const char *restoreImageFilePath)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        __block VZMacOSInstaller *ret;
        NSString *restoreImageFilePathNSString = [NSString stringWithUTF8String:restoreImageFilePath];
        NSURL *restoreImageFileURL = [NSURL fileURLWithPath:restoreImageFilePathNSString];
        dispatch_sync((dispatch_queue_t)vmQueue, ^{
            ret = [[VZMacOSInstaller alloc] initWithVirtualMachine:(VZVirtualMachine *)virtualMachine restoreImageURL:restoreImageFileURL];
        });
        return ret;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

void *newProgressObserverVZMacOSInstaller()
{
    return [[ProgressObserver alloc] init];
}

void installByVZMacOSInstaller(void *installerPtr, void *vmQueue, void *progressObserverPtr, void *completionHandler, void *fractionCompletedHandler)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacOSInstaller *installer = (VZMacOSInstaller *)installerPtr;
        dispatch_sync((dispatch_queue_t)vmQueue, ^{
            [installer installWithCompletionHandler:^(NSError *error) {
                macOSInstallCompletionHandler(completionHandler, error);
            }];
            [installer.progress
                addObserver:(ProgressObserver *)progressObserverPtr
                 forKeyPath:@"fractionCompleted"
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                    context:fractionCompletedHandler];
        });
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

void cancelInstallVZMacOSInstaller(void *installerPtr)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZMacOSInstaller *installer = (VZMacOSInstaller *)installerPtr;
        if (installer.progress.cancellable) {
            [installer.progress cancel];
        }
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

#endif
