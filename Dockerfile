FROM debian:testing

RUN echo "v20161012"; \
   apt-get update -q -y                                                                                    && \
   apt-get upgrade -q -y                                                                                   && \
   export BUILD_PACKAGES='git-core make cmake libz-dev python gcc g++ wget'                                && \
   apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends                   && \
   cd root && mkdir cling-build && cd cling-build                                                          && \
   wget https://raw.githubusercontent.com/root-mirror/root/master/interpreter/cling/tools/packaging/cpt.py && \
   chmod +x cpt.py                                                                                         && \
   ./cpt.py --current-dev=tar                                   \
            --with-clang-url=http://root.cern.ch/git/clang.git  \
            --with-llvm-url=http://root.cern.ch/git/llvm.git    \
            --skip-cleanup                                                                                 && \
   mv /tmp/cling-obj/include/*        /usr/include/                                                        && \
   mv /tmp/cling-obj/lib/libcling.so  /usr/lib                                                             && \
   mv /tmp/cling-obj/lib              /root/__svg_libs                                                     && \
   rm -rf ~/ci /tmp/cling-obj ~/cling-build

ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib/root
ENV ROOT_INCLUDE    /usr/include/c++/6:/usr/include/x86_64-linux-gnu/c++/6:/usr/include/c++/6/backward
