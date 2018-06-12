{% from "tinyproxy/defaults.yaml" import rawmap with context %}
{%- set tinp = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('tinyproxy')) %}

  service.running:
    - name: {{ tinp.service }}
    - enable: True
    - watch:
      - pkg: tinyproxy