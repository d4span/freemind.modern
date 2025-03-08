#!/bin/bash
# Script to update package declarations in Java source files

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Target directory with Java files
TARGET_DIR="freemind-core/src/main/java"

echo -e "${YELLOW}Updating package declarations in Java files...${NC}"

# Find all Java files
find $TARGET_DIR -name "*.java" | while read file; do
    # Get the relative path to determine the package
    rel_path=$(dirname "${file#$TARGET_DIR/}")
    package=$(echo $rel_path | sed 's|/|.|g')
    
    # Check if file already has a package declaration
    if grep -q "^package " "$file"; then
        # Update existing package declaration
        sed -i "s|^package .*;|package $package;|" "$file"
    else
        # Add package declaration at the beginning of the file
        # First, check for any license header (comments at the start)
        if head -n 10 "$file" | grep -q "^/\*\|^//"; then
            # Find the end of the comment block
            comment_end=$(grep -n "^\s*\*/" "$file" | head -n 1 | cut -d: -f1)
            if [ -z "$comment_end" ]; then
                # No end comment found, try to find the last single-line comment
                comment_end=$(grep -n "^//" "$file" | tail -n 1 | cut -d: -f1)
                if [ -z "$comment_end" ]; then
                    # No comments found, insert at the beginning
                    sed -i "1i package $package;\n" "$file"
                else
                    # Insert after the last single-line comment
                    sed -i "$comment_end a\\\npackage $package;\n" "$file"
                fi
            else
                # Insert after the end comment
                sed -i "$comment_end a\\\npackage $package;\n" "$file"
            fi
        else
            # No comments, insert at the beginning
            sed -i "1i package $package;\n" "$file"
        fi
    fi
    
    echo "Updated package in $file to $package"
done

# Update test packages
TEST_DIR="freemind-core/src/test/java"
echo -e "${YELLOW}Updating package declarations in test files...${NC}"

find $TEST_DIR -name "*.java" | while read file; do
    # Get the relative path to determine the package
    rel_path=$(dirname "${file#$TEST_DIR/}")
    package=$(echo $rel_path | sed 's|/|.|g')
    
    # Check if file already has a package declaration
    if grep -q "^package " "$file"; then
        # Update existing package declaration
        sed -i "s|^package .*;|package $package;|" "$file"
    else
        # Add package declaration at the beginning of the file
        # First, check for any license header (comments at the start)
        if head -n 10 "$file" | grep -q "^/\*\|^//"; then
            # Find the end of the comment block
            comment_end=$(grep -n "^\s*\*/" "$file" | head -n 1 | cut -d: -f1)
            if [ -z "$comment_end" ]; then
                # No end comment found, try to find the last single-line comment
                comment_end=$(grep -n "^//" "$file" | tail -n 1 | cut -d: -f1)
                if [ -z "$comment_end" ]; then
                    # No comments found, insert at the beginning
                    sed -i "1i package $package;\n" "$file"
                else
                    # Insert after the last single-line comment
                    sed -i "$comment_end a\\\npackage $package;\n" "$file"
                fi
            else
                # Insert after the end comment
                sed -i "$comment_end a\\\npackage $package;\n" "$file"
            fi
        else
            # No comments, insert at the beginning
            sed -i "1i package $package;\n" "$file"
        fi
    fi
    
    echo "Updated package in $file to $package"
done

echo -e "${GREEN}Package declarations updated!${NC}"