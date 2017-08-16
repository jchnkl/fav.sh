# PREFIX=/usr/local
PREFIX=${HOME}/.local

install:
	cp fav.sh ${PREFIX}/bin/fav
	ln -s ${PREFIX}/bin/fav ${PREFIX}/bin/favs
