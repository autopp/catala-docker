FROM ocaml/opam2:latest

WORKDIR /app

RUN sudo apt update && sudo apt install -y python3-dev python3-setuptools python3-pip man2html rsync colordiff libgmp-dev m4
RUN sudo python3 -m pip install --upgrade pip && sudo pip install virtualenv && sudo pip install pygments
RUN git clone https://github.com/CatalaLang/catala.git
COPY make-build.patch /app/catala

WORKDIR /app/catala
RUN patch -u < make-build.patch && make dependencies && eval "$(opam env)" && make build && sudo make pygments

WORKDIR /app

ENTRYPOINT [ "/app/catala/_build/default/src/catala/catala.exe" ]
