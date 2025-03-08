#!/bin/bash
# Main script to migrate FreeMind from Ant to Maven

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting FreeMind migration from Ant to Maven...${NC}"

# Step 1: Source code migration
echo -e "${YELLOW}Step 1: Migrating source code...${NC}"
./migrate-source.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Source code migration failed. Aborting.${NC}"
    exit 1
fi
echo -e "${GREEN}Source code migration completed.${NC}"

# Step 2: Resource files migration
echo -e "${YELLOW}Step 2: Migrating resource files...${NC}"
./migrate-resources.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Resource files migration failed. Aborting.${NC}"
    exit 1
fi
echo -e "${GREEN}Resource files migration completed.${NC}"

# Step 3: Update package declarations
echo -e "${YELLOW}Step 3: Updating package declarations...${NC}"
./update-packages.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Package declaration update failed. Aborting.${NC}"
    exit 1
fi
echo -e "${GREEN}Package declarations updated.${NC}"

# Step 4: Update import statements
echo -e "${YELLOW}Step 4: Updating import statements...${NC}"
./update-imports.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Import statement update failed. Aborting.${NC}"
    exit 1
fi
echo -e "${GREEN}Import statements updated.${NC}"

# Step 5: Final message
echo -e "${BLUE}Migration completed!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Review the changes and fix any remaining issues"
echo -e "2. Add additional Maven modules for plugins"
echo -e "3. Configure the build plugins in the POM files"
echo -e "4. Run 'mvn compile' to ensure everything compiles"
echo -e "5. Run 'mvn test' to run the tests"
echo -e "6. Create a distribution module"