// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: GetFileInfoMsg.proto

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

 #import "GetFileInfoMsg.pbobjc.h"
 #import "FileData.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - GetFileInfoMsgRoot

@implementation GetFileInfoMsgRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - GetFileInfoMsgRoot_FileDescriptor

static GPBFileDescriptor *GetFileInfoMsgRoot_FileDescriptor(void) {
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

#pragma mark - GetFileInfoReq

@implementation GetFileInfoReq

@dynamic hasFileId, fileId;

typedef struct GetFileInfoReq__storage_ {
  uint32_t _has_storage_[1];
  NSString *fileId;
} GetFileInfoReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "fileId",
        .dataTypeSpecific.className = NULL,
        .number = GetFileInfoReq_FieldNumber_FileId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(GetFileInfoReq__storage_, fileId),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GetFileInfoReq class]
                                     rootClass:[GetFileInfoMsgRoot class]
                                          file:GetFileInfoMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GetFileInfoReq__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\006\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - GetFileInfoRsp

@implementation GetFileInfoRsp

@dynamic hasResultCode, resultCode;
@dynamic hasFileItem, fileItem;

typedef struct GetFileInfoRsp__storage_ {
  uint32_t _has_storage_[1];
  GetFileInfoRsp_ResultCode resultCode;
  FileItemForMedia *fileItem;
} GetFileInfoRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resultCode",
        .dataTypeSpecific.enumDescFunc = GetFileInfoRsp_ResultCode_EnumDescriptor,
        .number = GetFileInfoRsp_FieldNumber_ResultCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(GetFileInfoRsp__storage_, resultCode),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "fileItem",
        .dataTypeSpecific.className = GPBStringifySymbol(FileItem),
        .number = GetFileInfoRsp_FieldNumber_FileItem,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(GetFileInfoRsp__storage_, fileItem),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GetFileInfoRsp class]
                                     rootClass:[GetFileInfoMsgRoot class]
                                          file:GetFileInfoMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GetFileInfoRsp__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\001\n\000\002\010\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum GetFileInfoRsp_ResultCode

GPBEnumDescriptor *GetFileInfoRsp_ResultCode_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Success\000Fail\000FileNotExist\000";
    static const int32_t values[] = {
        GetFileInfoRsp_ResultCode_Success,
        GetFileInfoRsp_ResultCode_Fail,
        GetFileInfoRsp_ResultCode_FileNotExist,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(GetFileInfoRsp_ResultCode)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:GetFileInfoRsp_ResultCode_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL GetFileInfoRsp_ResultCode_IsValidValue(int32_t value__) {
  switch (value__) {
    case GetFileInfoRsp_ResultCode_Success:
    case GetFileInfoRsp_ResultCode_Fail:
    case GetFileInfoRsp_ResultCode_FileNotExist:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
