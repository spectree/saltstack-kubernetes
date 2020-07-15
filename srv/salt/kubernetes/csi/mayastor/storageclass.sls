# -*- coding: utf-8 -*-
# vim: ft=jinja

{#- Get the `tplroot` from `tpldir` #}
{% from tpldir ~ "/map.jinja" import mayastor with context %}

mayastor-storageclass:
  file.managed:
    - require:
      - file: /srv/kubernetes/manifests/mayastor
    - name: /srv/kubernetes/manifests/mayastor/storage-class.yaml
    - source: salt://{{ tpldir }}/mayastor/storage-class.yaml.j2
    - template: jinja
    - user: root
    - group: root
    - mode: "0644"
    - context:
      tpldir: {{ tpldir }}
  cmd.run:
    - require:
      - cmd: mayastor
    - watch:
      - file: /srv/kubernetes/manifests/mayastor/storage-class.yaml
    - onlyif: curl --silent 'http://127.0.0.1:8080/version/'
    - name: |
        kubectl apply -f /srv/kubernetes/manifests/mayastor/storage-class.yaml

{% if mayastor.get('default_storageclass', {'enabled': False}).enabled %}
mayastor-default-storageclass:
  cmd.run:
    - require:
      - cmd: mayastor-storageclass
    - onlyif: curl --silent 'http://127.0.0.1:8080/version/'
    - name: |
        kubectl patch storageclass {{ mayastor.default_storageclass.name }} -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}' 
{% endif %}