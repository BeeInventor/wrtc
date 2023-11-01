# Build webrtc
# https://github.com/BeeInventor/node-webrtc/blob/develop/docs/build-from-source.md
FROM gcc:11.4.0 AS build
ENV SKIP_DOWNLOAD=true
#ENV DEBUG=true
#ENV PARALLELISM=2
WORKDIR /app
RUN git clone https://github.com/BeeInventor/wrtc node-webrtc
WORKDIR /app/node-webrtc

RUN curl -SLO https://deb.nodesource.com/nsolid_setup_deb.sh
RUN chmod 500 ./nsolid_setup_deb.sh && ./nsolid_setup_deb.sh 20
#RUN apt-get update && apt-get install nodejs cmake python-is-python3 python3-setuptools ninja-build -y
RUN apt-get update && apt-get install nodejs cmake python python3-pip ninja-build -y
RUN pip install setuptools

RUN npm install
RUN gcc --version && g++ --version && cmake --version
#RUN npm run build
RUN ./node_modules/.bin/ncmake configure && ./node_modules/.bin/ncmake build
#RUN npm test # var promise = this._pc.createOffer(options || {}) // invalida state
RUN npm pack

FROM scratch AS release
WORKDIR /build
COPY --from=build /app/node-webrtc/wrtc-0.5.0.tgz /build/wrtc-0.5.0.tgz
ENTRYPOINT ["ls", "/build/Release"]
