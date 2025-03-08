#!/bin/bash
# Script to update import statements in Java source files after migration

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Target directory with Java files
TARGET_DIR="freemind-core/src/main/java"

echo -e "${YELLOW}Updating import statements in Java files...${NC}"

# Package prefixes to update
PACKAGES=(
    "freemind.main"
    "freemind.common"
    "freemind.controller"
    "freemind.extensions"
    "freemind.modes"
    "freemind.preferences"
    "freemind.swing"
    "freemind.view"
    "de.foltin"
)

# Find all Java files
find $TARGET_DIR -name "*.java" | while read file; do
    # Update import statements for each known package
    for pkg in "${PACKAGES[@]}"; do
        # Replace dots with slashes for grep
        pkg_path=$(echo $pkg | sed 's|\.|/|g')
        
        # Check if file has an import for this package
        if grep -q "^import $pkg\\." "$file"; then
            # File has imports from this package
            echo "Updating imports in $file for package $pkg"
            
            # Find classes in this package
            find $TARGET_DIR -path "*/$pkg_path/*.java" -exec basename {} .java \; | while read class; do
                # Replace imports with fully qualified imports
                sed -i "s|^import $pkg\\.$class;|import $(echo $pkg | sed 's|\.|.|g').$class;|g" "$file"
            done
        fi
    done
done

# Also update test files
TEST_DIR="freemind-core/src/test/java"
echo -e "${YELLOW}Updating import statements in test files...${NC}"

find $TEST_DIR -name "*.java" | while read file; do
    # Update import statements for each known package
    for pkg in "${PACKAGES[@]}"; do
        # Replace dots with slashes for grep
        pkg_path=$(echo $pkg | sed 's|\.|/|g')
        
        # Check if file has an import for this package
        if grep -q "^import $pkg\\." "$file"; then
            # File has imports from this package
            echo "Updating imports in $file for package $pkg"
            
            # Find classes in this package
            find $TARGET_DIR -path "*/$pkg_path/*.java" -exec basename {} .java \; | while read class; do
                # Replace imports with fully qualified imports
                sed -i "s|^import $pkg\\.$class;|import $(echo $pkg | sed 's|\.|.|g').$class;|g" "$file"
            done
        fi
    done
done

echo -e "${GREEN}Import statements updated!${NC}"