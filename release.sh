#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

wait_for_ok(){
  printf "\n"
  OK=false
  while [[ ${OK} != "ok" ]] ; do
    read -r -p "${1} (type 'ok'): " OK
  done
}

ask_yes_or_no(){
  local ANSWER=""

  while [ "${ANSWER}" != "y" ] && [ "${ANSWER}" != "n" ]; do
    read -r -p "${1} (type 'y/n'): " ANSWER
  done

  echo "${ANSWER}"
}

# dogu.json will always exist. So get current dogu version from dogu.json.
CURRENT_DOGU_VERSION=$(jq ".Version" --raw-output dogu.json)

# Enter the target version
read -r -p "Current Version is v${CURRENT_DOGU_VERSION}. Please provide the new version: v" NEW_RELEASE_VERSION

# Validate that release version does not start with vv
if [[ ${NEW_RELEASE_VERSION} = v* ]]; then
  echo "WARNING: The new release version (v${NEW_RELEASE_VERSION}) starts with 'vv'."
  echo "You must not enter the v when defining the new version."
  ANSWER=$(ask_yes_or_no "Should the first v be removed?")
  if [ "${ANSWER}" == "y" ]; then
    NEW_RELEASE_VERSION="${NEW_RELEASE_VERSION:1}"
    echo "Release version now is: ${NEW_RELEASE_VERSION}"
  fi
fi;

# Do gitflow
git flow init -df
git checkout master
git pull origin master
git checkout develop
git pull origin develop
git flow release start v"${NEW_RELEASE_VERSION}"

# Update version in dogu.json
jq ".Version = \"${NEW_RELEASE_VERSION}\"" dogu.json > dogu2.json && mv dogu2.json dogu.json
# Update version in Dockerfile
sed -i "s/\(^[ ]*VERSION=\"\)\([^\"]*\)\(.*$\)/\1${NEW_RELEASE_VERSION}\3/" Dockerfile
# Update version in Makefile
if [ -f "Makefile" ]; then
  sed -i "s/\(^VERSION=\)\(.*\)$/\1${NEW_RELEASE_VERSION}/" Makefile
fi
# Update version in package.json
if [ -f "package.json" ]; then
  jq ".version = \"${NEW_RELEASE_VERSION}\"" package.json > package2.json && mv package2.json package.json
fi
# Update version in pom.xml
if [ -f "pom.xml" ]; then
  echo "Updating version in pom.xml..."
  mvn versions:set -DgenerateBackupPoms=false -DnewVersion="${NEW_RELEASE_VERSION}"
fi


# Commit changes to version
wait_for_ok "Please make sure that all versions have been updated correctly now (e.g. via \"git diff\")."
git add Dockerfile
git add dogu.json
git commit -m "Bump version"

# Changelog update
VERSION_TAG_IN_CHANGELOG=""
while [ "${VERSION_TAG_IN_CHANGELOG}" == "" ];
do
  wait_for_ok "Please update CHANGELOG.md now."

  # Validate, that changelog was updated
  VERSION_TAG_IN_CHANGELOG=$(grep "^\#\#[^\#][ ]*\[v${NEW_RELEASE_VERSION}\]*.*$" CHANGELOG.md || true)

  if [[ "${VERSION_TAG_IN_CHANGELOG}" == "" ]]; then
    echo "ERROR: The changelog was not updated correctly. Missing 'v${NEW_RELEASE_VERSION}' entry."
  fi
done

git add CHANGELOG.md
git commit -m "Update changelog"

if ! git diff --exit-code > /dev/null; then
  echo "There are still uncommitted changes:"
  echo ""
  echo "# # # # # # # # # #"
  echo ""
  git --no-pager diff
  echo ""
  echo "# # # # # # # # # #"
fi

echo "All changes compared to develop branch:"
echo ""
echo "# # # # # # # # # #"
echo ""
git --no-pager diff develop
echo ""
echo "# # # # # # # # # #"

# Push changes and delete release branch
wait_for_ok "Dogu upgrade from version v${CURRENT_DOGU_VERSION} to version v${NEW_RELEASE_VERSION} finished. Should the changes be pushed?"
git push origin release/v"${NEW_RELEASE_VERSION}"

echo "Switching back to develop and deleting branch release/v${NEW_RELEASE_VERSION}..."
git checkout develop
git branch -D release/v"${NEW_RELEASE_VERSION}"
