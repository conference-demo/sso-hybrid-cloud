#!/bin/bash -ex

keycloak-httpd-client-install --app-name keystone --permit-insecure-transport -r master -s http://vault1:8080 -a root-admin -u admin -p secret --client-originate-method registration --mellon-https-port 443 --mellon-hostname controller --mellon-root /v3 -l "/v3/auth/OS-FEDERATION/websso/mapped" -l "/v3/auth/OS-FEDERATION/identity_providers/mysso/protocols/mapped/websso" -l "/v3/OS-FEDERATION/identity_providers/mysso/protocols/mapped/auth"

openstack domain create federated_domain

openstack project create --domain federated_domain federated_project

openstack group create federated_users --domain federated_domain

openstack role add --group federated_users --group-domain federated_domain --domain federated_domain _member_

openstack role add --group federated_users --group-domain federated_domain --project federated_project _member_

openstack identity provider create --remote-id http://vault1:8080/auth/realms/master mysso

openstack mapping create --rules mapprules.json ssomap

openstack federation protocol create --identity-provider mysso --mapping ssomap mapped
