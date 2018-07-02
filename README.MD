# Shibboleth Formula
This formula installs and configures both IDP/SP Shibboleth applications.

## Usage
This formula is a base to build your Shibboleth configuration on.  All of the directories/ files you'd normally manage are controlled by Salt.  Since Shib is highly customizable I copied the default config files into the formula.  Adding template variables to them is left to the user.

When specific files are changed the serivce that uses that file will be refreshed.  For example, if you update attribute-resolver.xml the AttributeResolverService will be reloaded.  If you add new config files to services via services.xml you'll need to account for them.

## Pillar Example 
````
shibboleth:
  lookup:
    install:
      java_packages:
        - java-1.8.0-openjdk-devel
        - java-1.8.0-openjdk
      java_home: /usr/lib/jvm/java/
      version: 3.3.2
      directory: /opt
    config:
      container_user: tomcat
      reload_host: localhost:8080
      idp_properties: 
        idp.additionalProperties: '/conf/ldap.properties, /conf/saml-nameid.properties, /conf/services.properties, /conf/authn/duo.properties'
        idp.entityID: 'https://idp.example.com/idp/shibboleth'
        idp.scope: example.com
        idp.sealer.storeResource: '%{idp.home}/credentials/sealer.jks'
        idp.sealer.versionResource: '%{idp.home}/credentials/sealer.kver'
        idp.sealer.storePassword: password
        idp.sealer.keyPassword: password
        idp.signing.key: '%{idp.home}/credentials/idp-signing.key'
        idp.signing.cert: '%{idp.home}/credentials/idp-signing.crt'
        idp.encryption.key: '%{idp.home}/credentials/idp-encryption.key'
        idp.encryption.cert: '%{idp.home}/credentials/idp-encryption.crt'
        idp.authn.flows: Password
        idp.ui.fallbackLanguages: 'en,fr,de'
      ldap_properties: 
        idp.authn.LDAP.ldapURL: 'ldaps://ldap.example.com'
        idp.authn.LDAP.trustCertificates: '%{idp.home}/credentials/ca.crt'
        idp.authn.LDAP.returnAttributes: 'passwordExpirationTime,loginGraceRemaining'
        idp.authn.LDAP.baseDN: 'ou=users,dc=example,dc=com'
        idp.authn.LDAP.userFilter: '(uid={user})'
        idp.authn.LDAP.bindDN: 'cn=svcacct,ou=users,dc=example,dc=com'
        idp.authn.LDAP.bindDNCredential: secret
        idp.authn.LDAP.dnFormat: 'cn=%s,ou=users,dc=example,dc=com'
        idp.authn.LDAP.useStartTLS: false
        idp.authn.LDAP.useSSL: true
        idp.attribute.resolver.LDAP.ldapURL: '%{idp.authn.LDAP.ldapURL}'
        idp.attribute.resolver.LDAP.connectTimeout: '%{idp.authn.LDAP.connectTimeout:PT3S}'
        idp.attribute.resolver.LDAP.responseTimeout: '%{idp.authn.LDAP.responseTimeout:PT3S}'
        idp.attribute.resolver.LDAP.baseDN: '%{idp.authn.LDAP.baseDN:undefined}'
        idp.attribute.resolver.LDAP.bindDN: '%{idp.authn.LDAP.bindDN:undefined}'
        idp.attribute.resolver.LDAP.bindDNCredential: '%{idp.authn.LDAP.bindDNCredential:undefined}'
        idp.attribute.resolver.LDAP.useStartTLS: '%{idp.authn.LDAP.useStartTLS:true}'
        idp.attribute.resolver.LDAP.trustCertificates: '%{idp.authn.LDAP.trustCertificates:undefined}'
        idp.attribute.resolver.LDAP.searchFilter: '(uid=$resolutionContext.principal)'
        ````
