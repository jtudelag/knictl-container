FROM registry.redhat.io/ubi8/go-toolset:1.13.4

ENV GOPATH="/opt/app-root"
ENV INSTALLER_FOLDER="$GOPATH/src/gerrit.akraino.org/kni/installer"

RUN mkdir -p "$INSTALLER_FOLDER"
RUN git clone "https://gerrit.akraino.org/r/kni/installer" "$INSTALLER_FOLDER/"
 
WORKDIR "$INSTALLER_FOLDER"
RUN make build

FROM registry.redhat.io/ubi8/ubi-minimal:8.2
COPY --from=0 /opt/app-root/src/gerrit.akraino.org/kni/installer/knictl /usr/bin/knictl
ENTRYPOINT ["/usr/bin/knictl"]

