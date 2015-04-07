#!/bin/bash

cd $(dirname ${0})
HERE=$(pwd)

# Ensure NeoBundle exists.
if ! $(git submodule status | grep -q neobundle); then
  git submodule init
  git submodule update
fi

# Create the directories if they don't already exist.
for d in $(find ${HERE} -maxdepth 1 -mindepth 1 -type d); do
  d=$(basename ${d})
  if [[ "${d}" == ".git" ]]; then
    continue
  fi
  mkdir -p ${HOME}/${d}

  # Install the files.
  pushd ${HOME}/${d} > /dev/null
  for f in $(find ${HERE}/${d} -maxdepth 1 -mindepth 1); do
    [ ! -r $(basename ${f}) ] && ln -s ${f}
  done
  popd > /dev/null
done

# Install the top-level files.
pushd ${HOME} > /dev/null
for f in $(find ${HERE} -maxdepth 1 -mindepth 1 -type f); do
  f=$(basename ${f})
  if [[ "${f}" == "install.sh" ]]; then
    continue
  fi

  [ ! -r $(basename ${f}) ] && ln -s ${HERE}/${f}
done
popd > /dev/null
