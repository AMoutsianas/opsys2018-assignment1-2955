targz="./test.tar.gz"
download_dir="./test"
repo_dir="./assignments"

function main () {
  clone_sites_from_tar

  cd $repo_dir

  for dir in $(ls); do
    get_metrics $dir
  done
}

function get_metrics () {
  cd $@ 
  dirs=$(find . -mindepth 1 -type d | wc -l) 
  txt=$(find . -type f -name "*.txt" | wc -l)
  diff=$(($(find . -mindepth 1 | wc -l) - $txt - $dirs))

  printf "$@:\n"
  printf "Number of directories: $dirs\n"
  printf "Number of txt files : $txt\n"
  printf "Number of different files : $diff\n"

  if [ -e	
    printf "Directory structure is OK.\n"
  else
    printf "Directory structure is NOT OK.\n"
  fi

  cd ..
}

function clone_sites_from_tar () {
  tar -xzf $targz
  
  mkdir -p $repo_dir

  files=$(find $dir -type f -name "*.txt")

  for filename in $files; do
    while IFS= read -r site
    do
      if [[ $site == *https* ]]; then
        cd $repo_dir
        git clone -q $site

        ret=$?
        if ! test "$ret" -eq 0
        then
          printf "$site: Cloning FAILED"
          cd ..
          break
        fi
        cd ..

        printf "$site: Cloning OK"
      	break
      fi
    done < $filename
  done
}

main
