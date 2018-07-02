{%- from "shibboleth/idp/map.jinja" import shibboleth with context %}

# Manage webapp/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}:
  file.directory:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755

# Manage bin/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/bin:
  file.directory:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - recurse:
      - user
      - group

# Manage conf/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/conf:
  file.recurse:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - file_mode: 640
    - dir_mode: 755
    - source: salt://shibboleth/files/idp/conf
    - template: jinja
    - context:
      config: {{ shibboleth.config }}

# Manage credentials/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/credentials:
  file.directory:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - recurse:
      - user
      - group

# Manage dist/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/dist:
  file.directory:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755
    - file_mode: 640
    - recurse:
      - user
      - group
      - mode

# Manage doc/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/doc:
  file.directory:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

# Manage edit-webapp/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/edit-webapp:
  file.recurse:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755
    - file_mode: 644
    - include_empty: true
    - source: salt://shibboleth/files/idp/edit-webapp

# Manage flows/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/flows:
  file.directory:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

# Manage logs/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/logs:
  file.directory:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755
    - file_mode: 660
    - recurse:
      - user
      - group
      - mode

# Manage messages/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/messages:
  file.recurse:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755
    - file_mode: 644
    - include_empty: true
    - source: salt://shibboleth/files/idp/messages
    - clean: true
    - template: jinja
    - context: 
      config: {{ shibboleth.config }}

# Manage metadata/
metadata_files:
  file.recurse:
    - name: {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/metadata
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755
    - file_mode: 644
    - include_empty: true
    - source: salt://shibboleth/files/idp/metadata
    - clean: true
    - template: jinja
    - context: 
      config: {{ shibboleth.config }}

curl --interface 'lo' 'http://{{ shibboleth.config.reload_host }}/idp/profile/admin/reload-service?id=shibboleth.MetadataResolverService':
  cmd.run:
    - onchanges:
      - file: metadata_files


# Manage system/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/system:
  file.directory:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755
    - file_mode: 640
    - recurse:
      - user
      - group
      - mode

# Manage views/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/views:
  file.recurse:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - file_mode: 640
    - dir_mode: 755
    - clean: true
    - source: salt://shibboleth/files/idp/views
    - template: jinja
    - context:
      config: {{ shibboleth.config }}

# Manage war/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/war:
  file.directory:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755
    - file_mode: 640
    - recurse:
      - user
      - group
      - mode

# Manage webapp/
{{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/webapp:
  file.directory:
    - owner: root
    - group: {{ shibboleth.config.container_user }}
    - dir_mode: 755
    - file_mode: 640
    - recurse:
      - user
      - group
      - mode

# Reload services
# The files are managed outside the file.directory states since we need to watch for changes
relying_party:
  file.managed:
    - name: {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/conf/relying-party.xml
    - user: root
    - group: {{ shibboleth.config.container_user }}
    - mode: 640
    - source: salt://shibboleth/files/idp/conf_reload/relying-party.xml
    - template: jinja
    - context:
      config: {{ shibboleth.config }} 

curl --interface 'lo' 'http://{{ shibboleth.config.reload_host }}/idp/profile/admin/reload-service?id=shibboleth.RelyingPartyResolverService':
  cmd.run:
    - onchanges:
      - file: relying_party

attribute_resolver:
  file.managed:
    - name: {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/conf/attribute-resolver.xml
    - user: root
    - group: {{ shibboleth.config.container_user }}
    - mode: 640
    - source: salt://shibboleth/files/idp/conf_reload/attribute-resolver.xml
    - template: jinja
    - context:
      config: {{ shibboleth.config }} 

curl --interface 'lo' 'http://{{ shibboleth.config.reload_host }}/idp/profile/admin/reload-service?id=shibboleth.AttributeResolverService':
  cmd.run:
    - onchanges:
      - file: attribute_resolver

attribute_filter:
  file.managed:
    - name: {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/conf/attribute-filter.xml
    - user: root
    - group: {{ shibboleth.config.container_user }}
    - mode: 640
    - source: salt://shibboleth/files/idp/conf_reload/attribute-filter.xml
    - template: jinja
    - context:
      config: {{ shibboleth.config }} 

curl --interface 'lo' 'http://{{ shibboleth.config.reload_host }}/idp/profile/admin/reload-service?id=shibboleth.AttributeFilterService':
  cmd.run:
    - onchanges:
      - file: attribute_filter


nameid_generator:
  file.managed:
    - name: {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/conf/saml-nameid.xml
    - user: root
    - group: {{ shibboleth.config.container_user }}
    - mode: 640
    - source: salt://shibboleth/files/idp/conf_reload/saml-nameid.xml
    - template: jinja
    - context:
      config: {{ shibboleth.config }} 

curl --interface 'lo' 'http://{{ shibboleth.config.reload_host }}/idp/profile/admin/reload-service?id=shibboleth.NameIdentifierGenerationService':
  cmd.run:
    - onchanges:
      - file: nameid_generator

access_control:
  file.managed:
    - name: {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/conf/access-control.xml
    - user: root
    - group: {{ shibboleth.config.container_user }}
    - mode: 640
    - source: salt://shibboleth/files/idp/conf_reload/access-control.xml
    - template: jinja
    - context:
      config: {{ shibboleth.config }} 

curl --interface 'lo' 'http://{{ shibboleth.config.reload_host }}/idp/profile/admin/reload-service?id=shibboleth.ReloadableAccessControlService':
  cmd.run:
    - onchanges:
      - file: access_control

cas_protocol:
  file.managed:
    - name: {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/conf/cas-protocol.xml
    - user: root
    - group: {{ shibboleth.config.container_user }}
    - mode: 640
    - source: salt://shibboleth/files/idp/conf_reload/cas-protocol.xml
    - template: jinja
    - context:
      config: {{ shibboleth.config }} 

curl --interface 'lo' 'http://{{ shibboleth.config.reload_host }}/idp/profile/admin/reload-service?id=shibboleth.ReloadableCASServiceRegistry':
  cmd.run:
    - onchanges:
      - file: cas_protocol

logging_service:
  file.managed:
    - name: {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/conf/logback.xml
    - user: root
    - group: {{ shibboleth.config.container_user }}
    - mode: 640
    - source: salt://shibboleth/files/idp/conf_reload/logback.xml
    - template: jinja
    - context:
      config: {{ shibboleth.config }} 

curl --interface 'lo' 'http://{{ shibboleth.config.reload_host }}/idp/profile/admin/reload-service?id=shibboleth.LoggingService':
  cmd.run:
    - onchanges:
      - file: logging_service
