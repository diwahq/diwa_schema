#!/bin/bash

# Define function to replace text in all files
replace() {
    search="$1"
    replace="$2"
    echo "Replacing $search with $replace..."
    find lib/diwa_schema -type f -name "*.ex" -exec sed -i '' "s/$search/$replace/g" {} +
}

# Core
replace "DiwaAgent.Storage.Schemas.Context" "DiwaSchema.Core.Context"
replace "Diwa.Storage.Schemas.Context" "DiwaSchema.Core.Context"

replace "DiwaAgent.Storage.Schemas.Memory" "DiwaSchema.Core.Memory"
replace "Diwa.Storage.Schemas.Memory" "DiwaSchema.Core.Memory"

replace "DiwaAgent.Storage.Schemas.MemoryVersion" "DiwaSchema.Core.MemoryVersion"
replace "Diwa.Storage.Schemas.MemoryVersion" "DiwaSchema.Core.MemoryVersion"

replace "DiwaAgent.Storage.Schemas.ContextBinding" "DiwaSchema.Core.ContextBinding"
replace "DiwaAgent.Storage.Schemas.ContextRelationship" "DiwaSchema.Core.ContextRelationship"

# Team
replace "DiwaAgent.Storage.Schemas.Plan" "DiwaSchema.Team.Plan"
replace "Diwa.Storage.Schemas.Plan" "DiwaSchema.Team.Plan"

replace "DiwaAgent.Storage.Schemas.Task" "DiwaSchema.Team.Task"
replace "Diwa.Storage.Schemas.Task" "DiwaSchema.Team.Task"

replace "DiwaAgent.Storage.Schemas.Session" "DiwaSchema.Team.Session"
replace "DiwaAgent.Storage.Schemas.IngestJob" "DiwaSchema.Team.IngestJob"

# Enterprise
replace "DiwaAgent.Storage.Schemas.Organization" "DiwaSchema.Enterprise.Organization"
replace "Diwa.Storage.Schemas.Organization" "DiwaSchema.Enterprise.Organization"

replace "Diwa.Storage.Schemas.Secret" "DiwaSchema.Enterprise.Secret"
replace "Diwa.Storage.Schemas.UsageRecord" "DiwaSchema.Enterprise.UsageRecord"

# Fix alias usages if any (e.g. `alias DiwaAgent.Storage.Schemas.Context`)
# The above strict replacement handles it, but check for `alias DiwaAgent.Storage.Schemas`
replace "alias DiwaAgent.Storage.Schemas" "alias DiwaSchema.Core" # Imperfect, but a start. 
# Actually, better to just rely on full names if possible, or manual fix. 
# Most files likely use full module names or aliases to the specific module.

echo "Renaming done."
