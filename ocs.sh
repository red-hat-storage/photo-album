home=$( cd "$(dirname "$0")" ; pwd -P )
source $home/format.sh
oc project demo > /dev/null 2>&1
oc apply -f $home/namespace.yaml

__ "Object Bucket Demo"
___ "Cleanup existing environment"
oc delete -f app.yaml
oc delete bc photo-album -n demo
oc delete bc python-app -n demo
___ "Import dependencies and create build config"
oc import-image ubi8/python-38 --from=registry.redhat.io/ubi8/python-38 --confirm -n demo
__ " * Deploy application"
oc create -f app.yaml
__ " * Build the application image"
oc new-build --binary --strategy=docker --name python-app -n demo
oc start-build python-app --from-file python-app.Dockerfile -F -n demo
oc new-build --binary --strategy=docker --name photo-album -n demo
oc start-build photo-album --from-dir . -F -n demo
