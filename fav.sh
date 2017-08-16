#!/bin/sh

usage()
{
  cat << EOF

  fav - Manage file system favorites (or bookmarks)

  Default location for favorites: ~/.config/fav

  If the FAVORITES environment variable is set, then this location is used
  instead of the default location. If ~/.config/fav or FAVORITES does not
  exist, it will be created.

  Commands:

  favs

      Same as fav ls.

  fav DIRECTORY [NAME]

      Same as fav add DIRECTORY [NAME].

  add DIRECTORY [NAME]

      Add a directory as favorite. If NAME is omitted, then the basename of
      DIRECTORY is used instead.

  rm DIRECTORY | NAME

      Remove a favorite either by destination or by name.

  cd NAME

      Change directory to a favorite location.

  ls [..]

    Show all favorites. Options are passed through to ls(1).

EOF
}

favorites=${FAVORITES:-~/.config/fav}

if [ ! -d "${favorites}" ]; then
  mkdir -p "${favorites}" || exit 1
fi

if [ "$(basename ${0})" = "favs" ]; then
  fav ls
elif [ -d "$(realpath ${1})" ]; then
  ${0} add $@
fi

cmd=$1
shift

case ${cmd} in
  add)
    dir=$1
    name=$2

    if [ -z "${name}" ]; then
      name=$(basename ${dir})
    fi

    ln -s $(realpath ${dir}) ${favorites}/${name}
    ;;

  rm)
    arg=$1
    # is it a directory?
    if [ -d ${arg} ]; then
      for f in ${favorites}/*; do
        if [ "$(realpath ${f})" = "$(realpath ${arg})" ]; then
          rm -f "${f}"
          break
        fi
      done
    else
      rm -f ${favorites}/${arg}
    fi
    ;;

  cd)
    fav=$1
    cd "$(realpath ${favorites}/${fav})"
    ;;

  ls)
    args=$@
    ls ${args} ${favorites}
    ;;

  *)
    usage
    exit 1
    ;;
esac
