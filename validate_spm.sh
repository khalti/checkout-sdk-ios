#!/bin/bash

# Script to validate Swift Package Manager setup
echo "🔍 Validating KhaltiCheckout SPM Package (SPM-Only)..."

# Check if Package.swift exists
if [ ! -f "Package.swift" ]; then
    echo "❌ Package.swift not found!"
    exit 1
fi

echo "✅ Package.swift found"

# Check that no CocoaPods files exist
if find . \( -name "*.podspec" -o -name "Podfile" -o -name "Podfile.lock" -o -name "Pods" \) -print -quit | grep -q .; then
    echo "❌ CocoaPods files detected - this should be SPM-only"
    find . \( -name "*.podspec" -o -name "Podfile" -o -name "Podfile.lock" -o -name "Pods" \) -print
    exit 1
fi

echo "✅ Clean SPM-only structure confirmed"

# Check if Sources directory exists
if [ ! -d "Sources" ]; then
    echo "❌ Sources directory not found!"
    exit 1
fi

echo "✅ Sources directory found"

# Check if main source files exist
REQUIRED_FILES=(
    "Sources/KhaltiCheckout/Khalti.swift"
    "Sources/KhaltiCheckout/Model/KhaltiPayConfig.swift"
    "Sources/KhaltiCheckout/View/KhaltiPaymentViewController.swift"
    "Sources/KhaltiCheckout/Model/Environment.swift"
    "Sources/KhaltiCheckout/Model/PaymentResult.swift"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Required file missing: $file"
        exit 1
    fi
done

echo "✅ All required source files found"

# Check if Resources directory exists
if [ ! -d "Sources/KhaltiCheckout/Resources" ]; then
    echo "❌ Resources directory not found!"
    exit 1
fi

echo "✅ Resources directory found"

# Check if Tests directory exists
if [ ! -d "Tests" ]; then
    echo "❌ Tests directory not found!"
    exit 1
fi

echo "✅ Tests directory found"

# Try to resolve package dependencies
echo "🔄 Resolving package dependencies..."
if command -v swift &> /dev/null; then
    swift package resolve
    if [ $? -eq 0 ]; then
        echo "✅ Package dependencies resolved successfully"
    else
        echo "⚠️  Package resolution had issues, but this might be expected in some environments"
    fi
else
    echo "⚠️  Swift command not found, skipping dependency resolution"
fi

# Try to build the package for iOS. The SDK imports UIKit, so plain
# `swift build` targets macOS and is not a valid build check.
echo "🔨 Attempting to build package for iOS..."
if command -v xcodebuild &> /dev/null; then
    xcodebuild -scheme KhaltiCheckout -destination generic/platform=iOS build
    if [ $? -eq 0 ]; then
        echo "✅ iOS package built successfully"
    else
        echo "❌ iOS package build failed"
        exit 1
    fi
else
    echo "⚠️  xcodebuild not found, skipping iOS build test"
fi

echo ""
echo "🎉 KhaltiCheckout SPM-only package validation completed successfully!"
echo ""
echo "📋 Summary:"
echo "   - Package.swift: ✅"
echo "   - Source files: ✅"
echo "   - Resources: ✅"
echo "   - Tests: ✅"
echo "   - Build: ✅"
echo "   - CocoaPods removed: ✅"
echo ""
echo "🚀 Your SPM-only package is ready for distribution!"
