#!/usr/bin/env bash

set -o errexit
set -o pipefail


# == Vars
#
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="${SCRIPTS_DIR}/$(basename "${BASH_SOURCE[0]}")"

REPO_URL="${REPO_URL:-'xakraz'}"
JOBS=${JOBS:-2}

ERRORS="${PWD}/errors"


# == Helpers
#
source ${SCRIPTS_DIR}/helpers.bash

build_and_push(){
	base=$1
	suite=$2
	build_dir=$3

	log_info "    * Building ${REPO_URL}/${base}:${suite} for context ${build_dir}"
	docker build --rm --force-rm -t ${REPO_URL}/${base}:${suite} ${build_dir} || return 1
	#img build -t ${REPO_URL}/${base}:${suite} ${build_dir} || true

	# on successful build, push the image
	log_info "                       ---                                   "
	log_info "Successfully built ${base}:${suite} with context ${build_dir}"
	log_info "                       ---                                   "

	# try push a few times because notary server sometimes returns 401 for
	# absolutely no reason
	log_info "    * Pushing ${REPO_URL}/${base}:${suite} for context ${build_dir}"
	n=0
	until [ $n -ge 5 ]; do
		docker push --disable-content-trust=false ${REPO_URL}/${base}:${suite} && break
		log_warn "Try #$n failed... sleeping for 15 seconds"
		n=$[$n+1]
		sleep 15
	done
}

dofile() {
	log_info "---> Computing Docker build command"
	f=$1
	image=${f%Dockerfile}
	base=${image%%\/*}
	build_dir=$(dirname $f)
	suite=${build_dir##*\/}

	if [[ -z "$suite" ]] || [[ "$suite" == "$base" ]]; then
		suite=latest
	fi
	log_info "     * Tag=${suite}"

	{
		log_info "---> Building and Pushind Docker image: ${base}"
		$SCRIPT build_and_push "${base}" "${suite}" "${build_dir}"
	} || {
		# add to errors
		log_error "An error occured, stacking"
		echo "${base}:${suite}" >> $ERRORS
	}
echo
echo
}

main(){
	# get the dockerfiles
	logb_info "===> Getting all Dockefiles"
	IFS=$'\n'
	files=( $(find -L . -iname '*Dockerfile' | sed 's|./||' | sort) )
	unset IFS

	# build all dockerfiles
	logb_info "===> Building all Dockefiles"
	log_warn "     * Running in parallel with ${JOBS} jobs."
	parallel --tag --verbose --ungroup -j"${JOBS}" ${SCRIPT} dofile "{1}" ::: "${files[@]}"

	if [[ ! -f $ERRORS ]]; then
		log_info "---> No errors, hooray!"
	else
		log_error "Some images did not build correctly, see below."
		log_error "These images failed: $(cat $ERRORS)"
		exit 1
	fi
	logb_info "===> Done"
}

run(){
	args=$@
	f=$1

	if [[ "$f" == "" ]]; then
		main $args
	else
		$args
	fi
}

run $@
