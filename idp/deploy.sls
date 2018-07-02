{%- from 'shibboleth/idp/map.jinja' import shibboleth with context %}

# Install Java for Shib, make sure your JCE unlimited strength policy files are installed if using Oracle JDK
install_java:
  pkg.installed:
    - pkgs:
      {%- for jpkg in shibboleth.install.java_packages %}
      - {{ jpkg }}
      {%- endfor %}

set_JAVA_HOME:
  file.managed:
    - name: /etc/profile.d/java_home.sh
    - user: root
    - group: root
    - mode: 644
    - contents: 'export JAVA_HOME="{{ shibboleth.install.java_home}}"'

install_support_software:
  pkg.installed:
    - pkgs:
      {%- for spkg in shibboleth.install.support_packages %}
      - {{ spkg }}
      {%- endfor %}

retrieve_shibboleth:
  archive.extracted:
    - name: {{ shibboleth.install.directory }} 
    - source: {{ shibboleth.install.shibboleth_url }}/{{ shibboleth.install.version }}/shibboleth-identity-provider-{{ shibboleth.install.version }}.tar.gz
    - user: root
    - group: root
    - skip_verify: True

create_edit-webapps:
  cmd.run:
    - name: 'shibboleth-identity-provider-{{ shibboleth.install.version }}/bin/ant.sh handleeditwebapp -Didp.target.dir="/opt/shibboleth-identity-provider-{{ shibboleth.install.version }}"'
    - env:
      - JAVA_HOME: {{ shibboleth.install.java_home }}
    - cwd: {{ shibboleth.install.directory }}
    - require:
      - archive: retrieve_shibboleth
    - unless: 'ls {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/edit-webapp'

build_WAR:
  cmd.run:
    - name: 'shibboleth-identity-provider-{{ shibboleth.install.version }}/bin/ant.sh build-war -Didp.target.dir="/opt/shibboleth-identity-provider-{{ shibboleth.install.version }}"'
    - env:
      - JAVA_HOME: {{ shibboleth.install.java_home }}
    - cwd: {{ shibboleth.install.directory }}
    - require:
      - cmd: create_edit-webapps
    - unless: 'ls {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}/war/idp.war'

link_to_current_deployment:
  file.symlink:
    - name: {{ shibboleth.install.directory }}/shibboleth-idp
    - target: {{ shibboleth.install.directory }}/shibboleth-identity-provider-{{ shibboleth.install.version }}
