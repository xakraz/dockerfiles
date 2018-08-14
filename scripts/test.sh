#!/usr/bin/env bash

set -o errexit
set -o pipefail

# == Vars
#
# this is kind of an expensive check, so let's not do this twice if we
# are running more than one validate bundlescript
VALIDATE_REPO='https://github.com/xakraz/dockerfiles.git'
VALIDATE_BRANCH='master'

VALIDATE_HEAD="$(git rev-parse --verify HEAD)"

git fetch -q "$VALIDATE_REPO" "refs/heads/$VALIDATE_BRANCH"
VALIDATE_UPSTREAM="$(git rev-parse --verify FETCH_HEAD)"

VALIDATE_COMMIT_DIFF="$VALIDATE_UPSTREAM...$VALIDATE_HEAD"


SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_REPO="${DOCKER_REPO:-xakraz}"


# == Helpers
#
source ${SCRIPTS_DIR}/helpers.bash

validate_diff() {
	if [ "$VALIDATE_UPSTREAM" != "$VALIDATE_HEAD" ]; then
		git diff "$VALIDATE_COMMIT_DIFF" "$@"
	else
		git diff HEAD~ "$@"
	fi
}


# == Main
#
# get the dockerfiles changed
logb_info "===> Getting changed dockerfiles"
IFS=$'\n'
files=( $(validate_diff --name-only -- '*Dockerfile') )
unset IFS

# build the changed dockerfiles
logb_info "===> Building changed dockerfiles"
for f in "${files[@]}"; do

	log_info "---> ${f}"
	if ! [[ -e "$f" ]]; then
		log_warn "    * ${f} does not exist, skipping ..."
		continue
	fi

	# Computing args
	build_dir=$(dirname "$f")
	log_info "     * build_dir: ${build_dir}"

	base="${build_dir##'src/'}"
	base="${base%%\/*}"
	log_info "     * base: ${base}"

	suite="${build_dir##'src/'}"
	suite="${suite##$base}"
	suite="${suite##\/}"
	if [[ -z "$suite" ]]; then
		suite=latest
	fi
	log_info "     * suite: ${suite}"
	
	if [[ -n "${DOCKER_REPO}" ]]; then
		image="${DOCKER_REPO}/${base}:${suite}"
	else
		image="${base}:${suite}"
	fi

	# Run in subshell ?
	(
		log_info "---> Build ${image}"
		docker build -t ${image} ${build_dir}
	)

	log_info "                       ---                                   "
	log_info "Successfully built ${image} with context ${build_dir}"
	log_info "                       ---                                   "
done
logb_info "===> Done"
