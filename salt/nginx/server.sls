{% set logdir = salt['pillar.get']('nginx:logdir', '/var/log/nginx') %}
nginx:
  pkg.installed:
    - name: nginx
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - pkg: nginx
      - cmd: {{logdir}}
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/files/etc/nginx/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - backup: minion

/etc/nginx/conf.d/:
  file.recurse:
    - source: salt://nginx/files/etc/nginx/conf.d/
    - template: jinja
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

{{logdir}}:
  cmd.run:
    - name: mkdir -p {{logdir}}
    - unless: test -d {{logdir}}
    - require:
      - pkg: nginx

{% if salt['pillar.get']('vhosts', false) %}
{% set dir = salt['pillar.get']('web_root', '/data/webroot') %}
{% for vhost in pillar['vhosts'] %}
{{dir}}/{{vhost}}:
  cmd.run:
    - name: mkdir -p {{dir}}/{{vhost}} && chown -R nginx.nginx {{dir}}/{{vhost}}
    - unless: test -d {{dir}}/{{vhost}}
    - require:
      - pkg: nginx
{% endfor %}
{% endif %}
