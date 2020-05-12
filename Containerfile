FROM registry.redhat.io/ubi8/go-toolset:1.13.4

ENV GOPATH="/opt/app-root"
ENV INSTALLER_FOLDER="$GOPATH/src/gerrit.akraino.org/kni/installer"
RUN mkdir -p "$INSTALLER_FOLDER"
RUN git clone "https://gerrit.akraino.org/r/kni/installer" "$INSTALLER_FOLDER/"
 
WORKDIR "$INSTALLER_FOLDER"
RUN make build

FROM registry.redhat.io/ubi8/ubi-minimal:8.2
RUN microdnf install git
COPY --from=0 /opt/app-root/src/gerrit.akraino.org/kni/installer/knictl /usr/bin/knictl
ENV PLUGIN_FOLDER="/usr/bin/plugins/kustomize/plugin/kni.akraino.org/v1alpha1/siteconfig"
RUN mkdir -p "$PLUGIN_FOLDER"
COPY --from=0 /opt/app-root/src/gerrit.akraino.org/kni/installer/plugins/kustomize/plugin/kni.akraino.org/v1alpha1/siteconfig/SiteConfig "$PLUGIN_FOLDER/"

ENTRYPOINT ["/usr/bin/knictl"]

