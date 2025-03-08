#!/bin/bash
# Script to migrate resource files to Maven structure
# This script uses git mv to maintain file history

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Path settings
SOURCE_DIR="freemind"
TARGET_DIR="freemind-core/src/main/resources"

# Make sure target directories exist
mkdir -p $TARGET_DIR

echo -e "${YELLOW}Moving resources to Maven structure...${NC}"

# Move property files
echo -e "Moving property files..."
mkdir -p $TARGET_DIR
for file in $SOURCE_DIR/Resources*.properties; do
    git mv "$file" "$TARGET_DIR/"
done

# Move image files
echo -e "Moving image files..."
mkdir -p $TARGET_DIR/images
git mv $SOURCE_DIR/images $TARGET_DIR/

# Move other resource files
echo -e "Moving other resource files..."
git mv $SOURCE_DIR/freemind.properties $TARGET_DIR/
git mv $SOURCE_DIR/freemind.xsd $TARGET_DIR/
git mv $SOURCE_DIR/mindmap_menus.xml $TARGET_DIR/
git mv $SOURCE_DIR/patterns.xml $TARGET_DIR/

# Move accessories and XSL files
mkdir -p $TARGET_DIR/accessories
git mv $SOURCE_DIR/accessories $TARGET_DIR/

echo -e "${GREEN}Resource migration completed!${NC}"