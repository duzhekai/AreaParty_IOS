// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: GetMiracastInfoMsg.proto

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

 #import "GetMiracastInfoMsg.pbobjc.h"
 #import "MiracastData.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - GetMiracastInfoMsgRoot

@implementation GetMiracastInfoMsgRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - GetMiracastInfoMsgRoot_FileDescriptor

static GPBFileDescriptor *GetMiracastInfoMsgRoot_FileDescriptor(void) {
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

#pragma mark - GetMiracastReq

@implementation GetMiracastReq

@dynamic hasModel, model;

typedef struct GetMiracastReq__storage_ {
  uint32_t _has_storage_[1];
  NSString *model;
} GetMiracastReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "model",
        .dataTypeSpecific.className = NULL,
        .number = GetMiracastReq_FieldNumber_Model,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(GetMiracastReq__storage_, model),
        .flags = GPBFieldRequired,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GetMiracastReq class]
                                     rootClass:[GetMiracastInfoMsgRoot class]
                                          file:GetMiracastInfoMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GetMiracastReq__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - GetMiracastRsp

@implementation GetMiracastRsp

@dynamic hasResultCode, resultCode;
@dynamic hasMiracastItem, miracastItem;

typedef struct GetMiracastRsp__storage_ {
  uint32_t _has_storage_[1];
  GetMiracastRsp_ResultCode resultCode;
  MiracastItem *miracastItem;
} GetMiracastRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resultCode",
        .dataTypeSpecific.enumDescFunc = GetMiracastRsp_ResultCode_EnumDescriptor,
        .number = GetMiracastRsp_FieldNumber_ResultCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(GetMiracastRsp__storage_, resultCode),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "miracastItem",
        .dataTypeSpecific.className = GPBStringifySymbol(MiracastItem),
        .number = GetMiracastRsp_FieldNumber_MiracastItem,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(GetMiracastRsp__storage_, miracastItem),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GetMiracastRsp class]
                                     rootClass:[GetMiracastInfoMsgRoot class]
                                          file:GetMiracastInfoMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GetMiracastRsp__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\001\n\000\002\014\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum GetMiracastRsp_ResultCode

GPBEnumDescriptor *GetMiracastRsp_ResultCode_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Success\000Fail\000MiracastNotExist\000";
    static const int32_t values[] = {
        GetMiracastRsp_ResultCode_Success,
        GetMiracastRsp_ResultCode_Fail,
        GetMiracastRsp_ResultCode_MiracastNotExist,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(GetMiracastRsp_ResultCode)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:GetMiracastRsp_ResultCode_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL GetMiracastRsp_ResultCode_IsValidValue(int32_t value__) {
  switch (value__) {
    case GetMiracastRsp_ResultCode_Success:
    case GetMiracastRsp_ResultCode_Fail:
    case GetMiracastRsp_ResultCode_MiracastNotExist:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
