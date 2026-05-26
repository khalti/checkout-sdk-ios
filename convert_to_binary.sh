#!/bin/bash

# Convert KhaltiCheckout SPM to Binary Distribution
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}🔒 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header "Converting KhaltiCheckout to Binary Distribution"

# Check if Xcode is available
if ! command -v xcodebuild &> /dev/null; then
    print_error "Xcode command line tools not found!"
    echo "Please install Xcode and command line tools"
    exit 1
fi

# Check if we have a proper Xcode project
if [ ! -f "Package.swift" ]; then
    print_error "Package.swift not found!"
    exit 1
fi

print_success "Found Package.swift"

# Configuration
FRAMEWORK_NAME="KhaltiCheckout"
BUILD_DIR="build"
ARCHIVE_PATH_IOS="$BUILD_DIR/ios.xcarchive"
ARCHIVE_PATH_SIMULATOR="$BUILD_DIR/ios-simulator.xcarchive"
XCFRAMEWORK_PATH="$BUILD_DIR/$FRAMEWORK_NAME.xcframework"
ZIP_PATH="$BUILD_DIR/$FRAMEWORK_NAME.xcframework.zip"

print_warning "This will create a binary distribution that hides your source code"
print_warning "Users will not be able to see implementation details or debug into your code"
echo ""
read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Conversion cancelled"
    exit 0
fi

# Clean build directory
print_header "Cleaning build directory..."
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
print_success "Build directory cleaned"

# First, we need to create an Xcode project from the SPM package
print_header "Generating Xcode project..."
swift package generate-xcodeproj
print_success "Xcode project generated"

# Build for iOS device
print_header "Building for iOS device..."
xcodebuild archive \
    -project KhaltiCheckout.xcodeproj \
    -scheme KhaltiCheckout-Package \
    -destination "generic/platform=iOS" \
    -archivePath $ARCHIVE_PATH_IOS \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    ONLY_ACTIVE_ARCH=NO

if [ $? -eq 0 ]; then
    print_success "iOS build completed"
else
    print_error "iOS build failed"
    exit 1
fi

# Build for iOS Simulator
print_header "Building for iOS Simulator..."
xcodebuild archive \
    -project KhaltiCheckout.xcodeproj \
    -scheme KhaltiCheckout-Package \
    -destination "generic/platform=iOS Simulator" \
    -archivePath $ARCHIVE_PATH_SIMULATOR \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    ONLY_ACTIVE_ARCH=NO

if [ $? -eq 0 ]; then
    print_success "iOS Simulator build completed"
else
    print_error "iOS Simulator build failed"
    exit 1
fi

# Create XCFramework
print_header "Creating XCFramework..."
xcodebuild -create-xcframework \
    -framework $ARCHIVE_PATH_IOS/Products/Library/Frameworks/$FRAMEWORK_NAME.framework \
    -framework $ARCHIVE_PATH_SIMULATOR/Products/Library/Frameworks/$FRAMEWORK_NAME.framework \
    -output $XCFRAMEWORK_PATH

if [ $? -eq 0 ]; then
    print_success "XCFramework created successfully"
else
    print_error "XCFramework creation failed"
    exit 1
fi

# Create zip file
print_header "Creating zip archive..."
cd $BUILD_DIR
zip -r $FRAMEWORK_NAME.xcframework.zip $FRAMEWORK_NAME.xcframework
cd ..

if [ -f $ZIP_PATH ]; then
    print_success "Zip archive created"
else
    print_error "Zip archive creation failed"
    exit 1
fi

# Calculate checksum
print_header "Calculating checksum..."
if command -v swift &> /dev/null; then
    CHECKSUM=$(swift package compute-checksum $ZIP_PATH)
    print_success "Checksum calculated: $CHECKSUM"
else
    print_warning "Swift not available for checksum calculation"
    CHECKSUM="CALCULATE_MANUALLY"
fi

# Create binary Package.swift
print_header "Creating binary Package.swift..."
cat > Package.binary.swift << EOF
// swift-tools-version:5.3
// Binary distribution Package.swift for KhaltiCheckout

import PackageDescription

let package = Package(
    name: "KhaltiCheckout",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "KhaltiCheckout",
            targets: ["KhaltiCheckout"]
        ),
    ],
    dependencies: [
        // No external dependencies for binary distribution
    ],
    targets: [
        .binaryTarget(
            name: "KhaltiCheckout",
            url: "https://github.com/khalti/checkout-sdk-ios/releases/download/2.0.0-binary/KhaltiCheckout.xcframework.zip",
            checksum: "$CHECKSUM"
        )
    ]
)
EOF

print_success "Binary Package.swift created as Package.binary.swift"

# Create deployment instructions
cat > BINARY_DEPLOYMENT.md << EOF
# Binary Distribution Deployment Instructions

## Files Created
- \`$XCFRAMEWORK_PATH\` - The binary framework
- \`$ZIP_PATH\` - Zip archive for distribution
- \`Package.binary.swift\` - Binary Package.swift configuration

## Deployment Steps

### 1. Upload Binary to GitHub Releases
1. Create a new release on GitHub (e.g., v2.0.0-binary)
2. Upload \`$ZIP_PATH\` to the release assets
3. Note the download URL

### 2. Update Package.swift
Replace your current Package.swift with the binary version:
\`\`\`bash
cp Package.binary.swift Package.swift
\`\`\`

Update the URL in Package.swift to match your GitHub release URL.

### 3. Update Checksum
If the checksum is not automatically calculated, run:
\`\`\`bash
swift package compute-checksum $ZIP_PATH
\`\`\`

### 4. Commit and Tag
\`\`\`bash
git add Package.swift
git commit -m "Convert to binary distribution"
git tag -a 2.0.0-binary -m "Binary distribution release"
git push origin main
git push origin 2.0.0-binary
\`\`\`

## Usage for End Users
Users will install the same way, but get a pre-compiled binary:
\`\`\`swift
dependencies: [
    .package(url: "https://github.com/khalti/checkout-sdk-ios.git", from: "2.0.0")
]
\`\`\`

## Benefits
- ✅ Source code is hidden
- ✅ Faster build times for users
- ✅ Intellectual property protection

## Drawbacks
- ❌ Users cannot debug into your code
- ❌ Larger download size
- ❌ More complex build process
- ❌ Platform-specific builds required

## Checksum
Current checksum: $CHECKSUM
EOF

# Summary
echo ""
print_header "Binary Conversion Complete! 🎉"
echo ""
echo "📦 Files created:"
echo "   - $XCFRAMEWORK_PATH (binary framework)"
echo "   - $ZIP_PATH (distribution archive)"
echo "   - Package.binary.swift (binary package configuration)"
echo "   - BINARY_DEPLOYMENT.md (deployment instructions)"
echo ""
echo "📋 Next steps:"
echo "   1. Review BINARY_DEPLOYMENT.md for deployment instructions"
echo "   2. Upload $ZIP_PATH to GitHub releases"
echo "   3. Update Package.swift with binary configuration"
echo "   4. Test the binary distribution"
echo ""
echo "🔑 Checksum: $CHECKSUM"
echo ""
print_warning "Remember: This hides your source code but makes debugging harder for users"

# Clean up generated Xcode project
rm -rf KhaltiCheckout.xcodeproj

print_success "Conversion completed successfully!"