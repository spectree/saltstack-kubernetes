openebs-cstor:
  file.managed:
    - require:
      - file: /srv/kubernetes/manifests/openebs
    - name: /srv/kubernetes/manifests/openebs/csi-operator.yaml
    - source: salt://{{ tpldir }}/templates/csi-operator.yaml.j2
    - template: jinja
    - user: root
    - group: root
    - mode: "0644"
    - context:
      tpldir: {{ tpldir }}
  cmd.run:
    - watch:
      - file: /srv/kubernetes/manifests/openebs/csi-operator.yaml
    - runas: root
    - name: |
        kubectl apply -f /srv/kubernetes/manifests/openebs/csi-operator.yaml


openebs-cstor-pool-claim:
  file.managed:
    - require:
      - file: /srv/kubernetes/manifests/openebs
    - name: /srv/kubernetes/manifests/openebs/cstor-pool-claim.yaml
    - source: salt://{{ tpldir }}/templates/cstor-pool-claim.yaml.j2
    - template: jinja
    - user: root
    - group: root
    - mode: "0644"
    - context:
      tpldir: {{ tpldir }}
  cmd.run:
    - watch:
      - file: /srv/kubernetes/manifests/openebs/cstor-pool-claim.yaml
      - cmd: openebs-cstor
    - runas: root
    - name: |
        kubectl apply -f /srv/kubernetes/manifests/openebs/cstor-pool-claim.yaml
