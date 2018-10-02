#!/usr/bin/env ruby

require "fileutils"
require "run_loop"

hash = RunLoop::Shell.run_shell_command(["hash", "class-dump"], {log_cmd: true})
if hash[:exit_status] != 0
  raise %Q[

This script requires 'class-dump' to be in your PATH.

http://stevenygard.com/projects/class-dump/
https://github.com/nygard/class-dump

]
end

FRAMEWORKS=["XCTest", "XCTAutomationSupport"]
FileUtils.rm_rf(File.join("tmp", "class-dump"))

FRAMEWORKS_MAP = {}

FRAMEWORKS.each do |framework|
  output_path = File.join("tmp", "class-dump", "PrivateHeaders", framework)
  FileUtils.mkdir_p(output_path)
  FRAMEWORKS_MAP[framework] = output_path
end

FRAMEWORKS_MAP.each do |framework, output_path|
  developer_dir = RunLoop::Xcode.new.developer_dir
  library = File.join(developer_dir, "Platforms", "iPhoneOS.platform",
                      "Developer", "Library")
  if framework == "XCTAutomationSupport"
    binary_path = File.join(library, "PrivateFrameworks",
                            "XCTAutomationSupport.framework", framework)
  else
    binary_path = File.join(library, "Frameworks",
                            "XCTest.framework", framework)
  end

  hash = RunLoop::Shell.run_shell_command(["class-dump", "-s", "-S", "-H",
                                           "-o", output_path, binary_path],
                                          {log_cmd: true})
  if hash[:exit_status] != 0
    raise %Q[
class-dump exited non-zero: #{hash[:exit_status]}

Without output:

    #{hash[:out]}
]
  end
end

# Keep a copy of the originals
FileUtils.cp_r(File.join("tmp", "class-dump", "PrivateHeaders"),
               File.join("tmp", "class-dump", "original-files"))

# This lines add no value.
LINES_TO_REMOVE = [
  "- (id)init;",
  "+ (id)new;",
  "+ (void)initialize;",
  "- (void).cxx_destruct;",
  "- (void)encodeWithCoder:(id)arg1;",
  "- (id)initWithCoder:(id)arg1;",
  "- (void)dealloc;",
  "- (id)copyWithZone:(struct _NSZone *)arg1;",
  "- (_Bool)isEqual:(id)arg1;",
  "- (unsigned long long)hash;",
  "@property(readonly) unsigned long long hash;",
  "@property(readonly) Class superclass;",
  "+ (_Bool)supportsSecureCoding;",
  "- (NSString *)description;",
  "- (id)description;",
  "// Remaining properties",
  "@property(readonly, copy) NSString *debugDescription;",
  "@property(readonly, copy) NSString *description;",
  "@class NSString;",

  # See the related gsub in the rewrite block below.
  # These cases are difficult to capture in a regex.
  "@class NSObject<OS_xpc_object>;",
  "@class NSObject<OS_dispatch_queue>;"
]

# Replace #import <name>.h with <name>-Protocol.h
IMPORT_PROTOCOLS = [
  "XCElementAttributesPrivate.h",
  "XCTNSPredicateExpectationObject.h",
  "XCUIElementAttributes.h",
  "XCUIElementTypeQueryProvider.h",
  "XCUIScreenshotProviding.h",
  "XCDebugLogDelegate.h",
  "XCTASDebugLogDelegate.h",
  "XCTActivity.h",
  "XCTMemoryCheckerDelegate.h",
  "XCTWaiterDelegate.h",
  "XCTestManager_TestsInterface.h",
  "XCUIRemoteAXInterface.h",
  "XCUIAccessibilityInterface.h",
  "XCTElementSnapshotAttributeDataSource.h",
  "XCTElementSnapshotProvider.h",
  "XCUIAXNotificationHandling.h",
  "XCTWaiterManagement.h",
  "XCTestExpectationDelegate.h",
  "XCTestObservation.h",
  "_XCTestObservationPrivate.h",
  "XCTUIApplicationMonitor.h",
  "XCUIApplicationProcessTracker.h",
  "XCTTestRunSessionDelegate.h",
  "XCTestDriverInterface.h",
  "XCUIXcodeApplicationManaging.h"
]

# If there are lines with id <Protocol> variableName, add @protocol to header
MISSING_PROTOCOLS = [
  "XCTElementSnapshotAttributeDataSource",
  "XCTRunnerAutomationSession",
  "XCTElementSetTransformer",
  "XCUIXcodeApplicationManaging",
  "XCUIAccessibilityInterface",
  "XCUIApplicationProcessTracker",
  "XCUIRemoteAXInterface",
  "XCTElementSnapshotProvider",
  "XCTUIApplicationMonitor",
  "XCUIAXNotificationHandling",
  "XCTestExpectationDelegate",
  "XCTMemoryCheckerDelegate",
  "XCTestManager_ManagerInterface",
  "XCTTestRunSessionDelegate",
  "XCTWaiterDelegate",
  "XCTestManager_IDEInterface",
  "XCTRunnerIDESessionDelegate",
  "XCTTestWorker"
]

FRAMEWORKS_MAP.each do |_, output_path|

  # Delete these files because they provide no value
  ["NSCoding-Protocol.h",
   "NSCopying-Protocol.h",
   "NSObject-Protocol.h",
   "NSSecureCoding-Protocol.h",
   "DTXProxyChannel-XCTestAdditions.h",
   "__ARCLiteKeyedSubscripting__-Protocol.h"].each do |header|
    FileUtils.rm_f(File.join(output_path, header))
  end

  Dir.glob(File.join(output_path, "*.h")) do |header|
    originals = File.readlines(header)

    # Group properties together
    properties = ""

    # Inserting missing @protocols
    protocol_insert_map = { }

    lines = []

    originals.each do |line|
      if !LINES_TO_REMOVE.include?(line.chomp)

        if line[/<(XCTAutomationSupport|XCTest)\/.+.h>/]
        #if line[/<XCTAutomationSupport\/.+.h>/]
          filename = File.basename(line[/\/.+\.h/])
          line = %Q[#import "#{filename}"#{$-0}]
        end

        IMPORT_PROTOCOLS.each do |protocol_import|
          if line[/#{protocol_import}/]
            tokens = line.split(".")
            line = %Q[#{tokens[0]}-Protocol.h"#{$-0}]
            break
          end
        end

        MISSING_PROTOCOLS.each do |protocol|
          if line[/id\s?<\s?#{protocol}\s?>/]
            protocol_insert_map[protocol] = "@protocol #{protocol};"
            # any line will contain none or exactly one
            break
          end
        end

        if line[/\bint\b/]
          if line[/\bunsigned int\b/]
            line.gsub!(/\bunsigned int\b/, "NSUInteger")
          else
            line.gsub!(/\bint\b/, "NSInteger")
          end
        end

        if line[/\blong long\b/]
          line.gsub!(/\bunsigned long long\b/, "NSUInteger")
          line.gsub!(/\blong long\b/, "NSInteger")
        end

        if line[/\blong\b/]
          line.gsub!(/\bunsigned long\b/, "NSUInteger")
          line.gsub!(/\blong\b/, "NSInteger")
        end

        line.gsub!(%Q[#import "UIGestureRecognizer.h"],
                   "#import <UIKit/UIGestureRecognizer.h>")
        line.gsub!(%Q[#import "UILongPressGestureRecognizer.h"],
                   "#import <UIKit/UILongPressGestureRecognizer.h>")
        line.gsub!(%Q[#import "UIPanGestureRecognizer.h"],
                   "#import <UIKit/UIPanGestureRecognizer.h>")
        line.gsub!(%Q[#import "UIPinchGestureRecognizer.h"],
                   "#import <UIKit/UIPinchGestureRecognizer.h>")
        line.gsub!(%Q[#import "UISwipeGestureRecognizer.h"],
                   "#import <UIKit/UISwipeGestureRecognizer.h>")
        line.gsub!(%Q[#import "UITapGestureRecognizer.h"],
                   "#import <UIKit/UITapGestureRecognizer.h>")

        line.gsub!("id <XCTestManager_IDEInterface><NSObject>",
                   "id <XCTestManager_IDEInterface>")

        line.gsub!("XCTestManager_IDEInterface><NSObject",
                   "XCTestManager_IDEInterface")

        line.gsub!("_Bool", "BOOL")
        line.gsub!("struct CGRect", "CGRect")
        line.gsub!("struct CGPoint", "CGPoint")
        line.gsub!("struct CGVector", "CGVector")

        # Syntax not allowed
        if line[/@class/]
          line.gsub!(/NSObject<OS_dispatch_queue>,\s?/, "")
          line.gsub!(/,\s?NSObject<OS_dispatch_queue>;/, ";")
        end

        # Trailing comments
        line.gsub!(/ \/\/ @synthesize .+$/, "")

        if File.basename(header) == "XCUIDevice.h"
          line.gsub!("+ (id)sharedDevice;", "+ (XCUIDevice *)sharedDevice;")
          line.gsub!("@property(nonatomic) NSInteger orientation;",
                    "@property(nonatomic) UIDeviceOrientation orientation;")
        end

        # Group properties
        if line[/@property/]
          properties = properties + line
        else
          if line[/#import "NS.+\.h/] ||
             line[/#import <Foundation\/.*\.h>/]
            puts "skipping line: #{line}"
          else
            lines << line
          end
        end
      end

      inserted_imports = false
      inserted_missing_protocols = false
      inserted_properties = false

      class_fixes = {}

      File.open(header, "w:UTF-8") do |file|
        file.puts("// class-dump results processed by bin/class-dump/dump.rb")

        if File.basename(file) == "CDStructures.h"

          stop_writing = false
          lines.each do |line|
            if line.chomp == "#pragma mark Named Structures"
              stop_writing  = true
            elsif line.chomp == "#pragma mark Typedef'd Structures"
              stop_writing = false
            elsif line.chomp == "#pragma mark Blocks"
              file.puts(%Q[#import <Foundation/Foundation.h>])
              file.puts("")
            end

            if !stop_writing
              file.write(line)
            end
          end
        else
          lines.each do |line|
            if !inserted_imports && (line[/#import/] || line[/@class/] || line[/@interface/])
              file.puts(%Q[#import <Foundation/Foundation.h>])
              file.puts(%Q[#import <CoreGraphics/CoreGraphics.h>])
              file.puts(%Q[#import <XCTest/XCUIElementTypes.h>])
              file.puts(%Q[#import "CDStructures.h"])
              file.puts("@protocol OS_dispatch_queue;")
              file.puts("@protocol OS_xpc_object;")
              file.puts("")
              inserted_imports = true
            end

            if File.basename(file) == "XCTestManager_ManagerInterface-Protocol.h"
              if !class_fixes[file] && line[/@protocol/]
                file.puts("@class XCTSerializedTransportWrapper;")
                file.puts("@class XCElementSnapshot;")
                file.puts("@class NSXPCListenerEndpoint;")
                file.puts("")
                class_fixes[file] = true
              end
            end

            if File.basename(file) == "XCTAutomationTarget-Protocol.h"
              if !class_fixes[file] && line[/@protocol/]
                file.puts("@class XCTElementQueryResults;")
                file.puts("")
                class_fixes[file] = true
              end
            end

            if File.basename(file) == "XCUIDevice.h"
              if !class_fixes[file] && line[/@class/]
                file.puts("#import <UIKit/UIDevice.h>")
                file.puts("")
                class_fixes[file] = true
              end
            end

            if !inserted_missing_protocols && line[/@interface/]
              if !protocol_insert_map.empty?
                file.puts("")
                protocol_insert_map.each do |_, value|
                  file.puts(value)
                end
                file.puts("")
              end
              inserted_missing_protocols = true
            end

            if !inserted_properties && properties != "" && line == "}#{$-0}"
              file.write(line)
              file.puts("")
              file.write(properties)
              inserted_properties = true
              next
            end

            file.write(line)
          end
        end
      end
    end
  end
end


# Use the version of CDStructures.h in XCTest/
FileUtils.rm(File.join(FRAMEWORKS_MAP["XCTAutomationSupport"], "CDStructures.h"))
FileUtils.mv(File.join(FRAMEWORKS_MAP["XCTest"], "CDStructures.h"),
             File.join(FRAMEWORKS_MAP["XCTest"], ".."))

# Copy the new headers to Server/PrivateHeaders
FileUtils.rm_r(File.join("Server", "PrivateHeaders"))
FileUtils.cp_r(File.join("tmp", "class-dump", "PrivateHeaders"),
               File.join("Server", "PrivateHeaders"))

# Ensure headers are only imported when XCTest is _not_ available
UMBRELLA_HEADER = File.join(FRAMEWORKS_MAP["XCTest"], "..", "CBX-XCTest-Umbrella.h")
File.open(UMBRELLA_HEADER, "w:UTF-8") do |file|
  file.puts("// Generated by bin/class-dump/dump.rb")
  file.puts("")
  file.puts("#ifndef LOAD_XCTEST_PRIVATE_HEADERS")
  headers = Dir.glob(File.join(FRAMEWORKS_MAP["XCTest"], "*.h")).sort

  headers.each do |header|
    file.puts(%Q[#import "XCTest/#{File.basename(header)}"])
  end

  file.puts("#endif")
end

FileUtils.cp(UMBRELLA_HEADER, File.join("Server", "PrivateHeaders"))
