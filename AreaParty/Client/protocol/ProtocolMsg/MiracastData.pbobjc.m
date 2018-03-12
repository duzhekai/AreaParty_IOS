// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MiracastData.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "MiracastData.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MiracastDataRoot

@implementation MiracastDataRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MiracastDataRoot_FileDescriptor

static GPBFileDescriptor *MiracastDataRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"protocol"
                                                     syntax:GPBFileSyntaxProto2];
  }
  return descriptor;
}

#pragma mark - MiracastItem

@implementation MiracastItem

@dynamic hasManufactory, manufactory;
@dynamic hasAppname, appname;
@dynamic hasPackagename, packagename;
@dynamic hasModel, model;

typedef struct MiracastItem__storage_ {
  uint32_t _has_storage_[1];
  NSString *manufactory;
  NSString *appname;
  NSString *packagename;
  NSString *model;
} MiracastItem__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "manufactory",
        .dataTypeSpecific.className = NULL,
        .number = MiracastItem_FieldNumber_Manufactory,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MiracastItem__storage_, manufactory),
        .flags = GPBFieldRequired,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "appname",
        .dataTypeSpecific.className = NULL,
        .number = MiracastItem_FieldNumber_Appname,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MiracastItem__storage_, appname),
        .flags = GPBFieldRequired,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "packagename",
        .dataTypeSpecific.className = NULL,
        .number = MiracastItem_FieldNumber_Packagename,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(MiracastItem__storage_, packagename),
        .flags = GPBFieldRequired,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "model",
        .dataTypeSpecific.className = NULL,
        .number = MiracastItem_FieldNumber_Model,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(MiracastItem__storage_, model),
        .flags = GPBFieldRequired,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MiracastItem class]
                                     rootClass:[MiracastDataRoot class]
                                          file:MiracastDataRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MiracastItem__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
