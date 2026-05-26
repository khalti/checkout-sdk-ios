#!/bin/bash

# KhaltiCheckout SPM Deployment Script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}🚀 $1${NC}"
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

print_header "KhaltiCheckout SPM Package Deployment"

# Check if git is available
if ! command -v git &> /dev/null; then
    print_error "Git is not installed or not in PATH"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

# Check if working directory is clean
if [[ -n $(git status --porcelain) ]]; then
    print_warning "Working directory is not clean"
    echo "Uncommitted changes:"
    git status --short
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Deployment cancelled"
        exit 1
    fi
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
print_success "Current branch: $CURRENT_BRANCH"

# Get version number
echo ""
echo "📋 Current tags:"
git tag -l | tail -5

echo ""
read -p "Enter version number (e.g., 2.0.0): " VERSION

if [[ -z "$VERSION" ]]; then
    print_error "Version number is required"
    exit 1
fi

# Validate version format (basic semver check)
if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_warning "Version format should be X.Y.Z (semantic versioning)"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if tag already exists
if git tag -l | grep -q "^$VERSION$"; then
    print_error "Tag $VERSION already exists"
    exit 1
fi

# Run package checks if Swift/Xcode are available
if command -v swift &> /dev/null; then
    print_header "Running pre-deployment tests..."
    
    echo "📦 Resolving package..."
    if swift package resolve; then
        print_success "Package resolved"
    else
        print_error "Package resolution failed"
        exit 1
    fi
    
    echo "🔨 Building iOS package..."
    if command -v xcodebuild &> /dev/null && xcodebuild -scheme KhaltiCheckout -destination generic/platform=iOS build; then
        print_success "iOS package built successfully"
    else
        print_error "iOS package build failed"
        exit 1
    fi
else
    print_warning "Swift not found, skipping pre-deployment tests"
fi

# Create release notes
echo ""
print_header "Creating release notes..."

RELEASE_NOTES="Release $VERSION - SPM-only version

Major Changes:
- Pure Swift Package Manager implementation
- Removed CocoaPods dependencies
- Improved build performance and integration
- Modern package management with native Xcode support

API Compatibility:
- 100% backward compatible
- No code changes required for existing implementations
- Same public interface and functionality

Installation:
dependencies: [
    .package(url: \"https://github.com/khalti/checkout-sdk-ios.git\", from: \"$VERSION\")
]

Migration:
- Remove CocoaPods dependency from Podfile
- Add SPM dependency as shown above
- No code changes needed

For detailed migration instructions, see MIGRATION_GUIDE.md"

echo "Release notes preview:"
echo "========================"
echo "$RELEASE_NOTES"
echo "========================"
echo ""

read -p "Proceed with deployment? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled"
    exit 1
fi

# Commit any remaining changes
if [[ -n $(git status --porcelain) ]]; then
    print_header "Committing changes..."
    git add .
    git commit -m "Prepare release $VERSION

- Finalize SPM-only package structure
- Update documentation and guides
- Ready for deployment"
    print_success "Changes committed"
fi

# Create and push tag
print_header "Creating and pushing tag..."
git tag -a "$VERSION" -m "$RELEASE_NOTES"
print_success "Tag $VERSION created"

# Push to remote
echo "📤 Pushing to remote..."
git push origin "$CURRENT_BRANCH"
git push origin "$VERSION"
print_success "Pushed to remote repository"

# Success message
echo ""
print_header "Deployment Completed Successfully! 🎉"
echo ""
echo "📦 Package Information:"
echo "   Repository: $(git remote get-url origin)"
echo "   Version: $VERSION"
echo "   Branch: $CURRENT_BRANCH"
echo ""
echo "📋 Next Steps:"
echo "   1. Create GitHub release at: $(git remote get-url origin | sed 's/\.git$//')/releases/new"
echo "   2. Select tag: $VERSION"
echo "   3. Add release notes (preview shown above)"
echo "   4. Publish the release"
echo ""
echo "📦 Installation Instructions for Users:"
echo "   Add to Package.swift:"
echo "   .package(url: \"$(git remote get-url origin)\", from: \"$VERSION\")"
echo ""
echo "   Or in Xcode:"
echo "   File → Add Package Dependencies → $(git remote get-url origin)"
echo ""
print_success "KhaltiCheckout $VERSION is now available via Swift Package Manager!"

# Optional: Open GitHub releases page
if command -v open &> /dev/null; then
    REPO_URL=$(git remote get-url origin | sed 's/\.git$//')
    read -p "Open GitHub releases page? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "$REPO_URL/releases/new?tag=$VERSION"
    fi
fi
