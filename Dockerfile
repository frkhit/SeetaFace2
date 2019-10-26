# build env 
FROM ubuntu:18.04 as build_env 
COPY 	. /SeetaFace2/
RUN		apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y libopencv-dev cmake && \
		cd /SeetaFace2/  && rm -r .git/ && mkdir -p build && cd build && \
		cmake .. -DCMAKE_INSTALL_PREFIX=`pwd`/install -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLE=ON && \
		cmake --build . --config Release && \
		cmake --build .  --config Release --target install  && \
		export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`/lib && \
		mkdir -p /SeetaFace2/build/bin/model/  &&  mv /SeetaFace2/pretained_models/* /SeetaFace2/build/bin/model/ && \
		cd /SeetaFace2/build/bin/model/ && cat datfile.tar.gz.* | tar zx && rm datfile.tar.gz.* && \
		tar -xvf datfile.tar && mv datfile/* ./ && rm -r datfile/ && rm datfile.tar && \
		rm -rf /var/lib/apt/lists/*

# docker
FROM ubuntu:18.04
COPY --from=build_env /SeetaFace2 /SeetaFace2/
RUN		apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y libopencv-dev cmake && \
		rm -rf /var/lib/apt/lists/*
WORKDIR	/SeetaFace2/build/bin
