// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: LogoutMsg.proto

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

 #import "LogoutMsg.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - LogoutMsgRoot

@implementation LogoutMsgRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - LogoutMsgRoot_FileDescriptor

static GPBFileDescriptor *LogoutMsgRoot_FileDescriptor(void) {
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

#pragma mark - LogoutReq

@implementation LogoutReq

@dynamic hasLogoutType, logoutType;
@dynamic hasUserId, userId;

typedef struct LogoutReq__storage_ {
  uint32_t _has_storage_[1];
  LogoutReq_LogoutType logoutType;
  NSString *userId;
} LogoutReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "logoutType",
        .dataTypeSpecific.enumDescFunc = LogoutReq_LogoutType_EnumDescriptor,
        .number = LogoutReq_FieldNumber_LogoutType,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LogoutReq__storage_, logoutType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = LogoutReq_FieldNumber_UserId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(LogoutReq__storage_, userId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[LogoutReq class]
                                     rootClass:[LogoutMsgRoot class]
                                          file:LogoutMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(LogoutReq__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\001\n\000\002\006\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum LogoutReq_LogoutType

GPBEnumDescriptor *LogoutReq_LogoutType_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Mobile\000Pc\000PcForce\000";
    static const int32_t values[] = {
        LogoutReq_LogoutType_Mobile,
        LogoutReq_LogoutType_Pc,
        LogoutReq_LogoutType_PcForce,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(LogoutReq_LogoutType)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:LogoutReq_LogoutType_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL LogoutReq_LogoutType_IsValidValue(int32_t value__) {
  switch (value__) {
    case LogoutReq_LogoutType_Mobile:
    case LogoutReq_LogoutType_Pc:
    case LogoutReq_LogoutType_PcForce:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - LogoutRsp

@implementation LogoutRsp

@dynamic hasResultCode, resultCode;

typedef struct LogoutRsp__storage_ {
  uint32_t _has_storage_[1];
  LogoutRsp_ResultCode resultCode;
} LogoutRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resultCode",
        .dataTypeSpecific.enumDescFunc = LogoutRsp_ResultCode_EnumDescriptor,
        .number = LogoutRsp_FieldNumber_ResultCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LogoutRsp__storage_, resultCode),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[LogoutRsp class]
                                     rootClass:[LogoutMsgRoot class]
                                          file:LogoutMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(LogoutRsp__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\n\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum LogoutRsp_ResultCode

GPBEnumDescriptor *LogoutRsp_ResultCode_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Success\000Fail\000PcSuccess\000PcFail\000PcForceSuc"
        "cess\000PcForceFail\000PcForceLogout\000";
    static const int32_t values[] = {
        LogoutRsp_ResultCode_Success,
        LogoutRsp_ResultCode_Fail,
        LogoutRsp_ResultCode_PcSuccess,
        LogoutRsp_ResultCode_PcFail,
        LogoutRsp_ResultCode_PcForceSuccess,
        LogoutRsp_ResultCode_PcForceFail,
        LogoutRsp_ResultCode_PcForceLogout,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(LogoutRsp_ResultCode)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:LogoutRsp_ResultCode_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL LogoutRsp_ResultCode_IsValidValue(int32_t value__) {
  switch (value__) {
    case LogoutRsp_ResultCode_Success:
    case LogoutRsp_ResultCode_Fail:
    case LogoutRsp_ResultCode_PcSuccess:
    case LogoutRsp_ResultCode_PcFail:
    case LogoutRsp_ResultCode_PcForceSuccess:
    case LogoutRsp_ResultCode_PcForceFail:
    case LogoutRsp_ResultCode_PcForceLogout:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
