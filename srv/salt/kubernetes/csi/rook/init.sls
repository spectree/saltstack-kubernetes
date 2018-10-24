{%- from "kubernetes/map.jinja" import common with context -%}
{%- from "kubernetes/map.jinja" import master with context -%}

/srv/kubernetes/manifests/rook:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750
    - makedirs: True

{%- if master.storage.get('rook_ceph', {'enabled': False}).enabled %}

/srv/kubernetes/manifests/rook/ceph:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750
    - makedirs: True

/srv/kubernetes/manifests/rook/monitoring:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750
    - makedirs: True

/srv/kubernetes/manifests/rook/monitoring/kube-prometheus:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750
    - makedirs: True

/srv/kubernetes/manifests/rook/rbac.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook
    - source: salt://kubernetes/csi/rook/rbac.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/ceph/cluster.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/ceph
    - source: salt://kubernetes/csi/rook/ceph/cluster.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/ceph/dashboard-external.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/ceph
    - source: salt://kubernetes/csi/rook/ceph/dashboard-external.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/ceph/filesystem.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/ceph
    - source: salt://kubernetes/csi/rook/ceph/filesystem.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/ceph/ingress.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/ceph
    - source: salt://kubernetes/csi/rook/ceph/ingress.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/ceph/object.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/ceph
    - source: salt://kubernetes/csi/rook/ceph/object.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/ceph/operator.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/ceph
    - source: salt://kubernetes/csi/rook/ceph/operator.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/ceph/pool.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/ceph
    - source: salt://kubernetes/csi/rook/ceph/pool.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/ceph/storageclass.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/ceph
    - source: salt://kubernetes/csi/rook/ceph/storageclass.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/ceph/toolbox.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/ceph
    - source: salt://kubernetes/csi/rook/ceph/toolbox.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/monitoring/prometheus-service.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/monitoring
    - source: salt://kubernetes/csi/rook/monitoring/prometheus-service.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/monitoring/prometheus.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/monitoring
    - source: salt://kubernetes/csi/rook/monitoring/prometheus.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/monitoring/service-monitor.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/monitoring
    - source: salt://kubernetes/csi/rook/monitoring/service-monitor.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/monitoring/kube-prometheus/prometheus.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/monitoring/kube-prometheus
    - source: salt://kubernetes/csi/rook/monitoring/kube-prometheus/prometheus.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/monitoring/kube-prometheus/ceph-exporter.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/monitoring/kube-prometheus
    - source: salt://kubernetes/csi/rook/monitoring/kube-prometheus/ceph-exporter.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/monitoring/kube-prometheus/service-monitor.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/monitoring/kube-prometheus
    - source: salt://kubernetes/csi/rook/monitoring/kube-prometheus/service-monitor.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/monitoring/kube-prometheus/grafana-dashboard.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/monitoring/kube-prometheus
    - source: salt://kubernetes/csi/rook/monitoring/kube-prometheus/grafana-dashboard.yaml
    - user: root
    - group: root
    - file_mode: 644

rook-operator-install:
  cmd.run:
    - watch:
      - file: /srv/kubernetes/manifests/rook/ceph/operator.yaml
    - onlyif: curl --silent 'http://127.0.0.1:8080/version/'
    - name: |
        kubectl apply -f /srv/kubernetes/manifests/rook/ceph/operator.yaml

rook-operator-wait:
  cmd.run:
    - require:
      - cmd: rook-operator-install
    - runas: root
    - name: until kubectl -n rook-ceph-system get pods --field-selector=status.phase=Running | grep rook-ceph-operator; do printf 'rook-ceph-operator is not Running' && sleep 5; done
    - use_vt: True
    - timeout: 180

rook-cluster-install:
  cmd.run:
    - require:
      - cmd: rook-operator-wait
      - cmd: rook-operator-install
    - watch:
      - file: /srv/kubernetes/manifests/rook/rbac.yaml
      - file: /srv/kubernetes/manifests/rook/ceph/cluster.yaml
      - file: /srv/kubernetes/manifests/rook/ceph/pool.yaml
      - file: /srv/kubernetes/manifests/rook/ceph/object.yaml
      - file: /srv/kubernetes/manifests/rook/ceph/filesystem.yaml
      - file: /srv/kubernetes/manifests/rook/ceph/storageclass.yaml
      - file: /srv/kubernetes/manifests/rook/ceph/dashboard-external.yaml
      - file: /srv/kubernetes/manifests/rook/ceph/ingress.yaml
    - name: |
        kubectl apply -f /srv/kubernetes/manifests/rook/rbac.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/ceph/cluster.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/ceph/pool.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/ceph/object.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/ceph/filesystem.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/ceph/storageclass.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/ceph/dashboard-external.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/ceph/ingress.yaml

rook-cluster-wait:
  cmd.run:
    - require:
      - cmd: rook-cluster-install
    - runas: root
    - name: until kubectl -n rook-ceph get pods --field-selector=status.phase=Running | grep rook-ceph-mgr; do printf 'rook-ceph-mgr is not Running' && sleep 5; done
    - use_vt: True
    - timeout: 180

rook-monitoring-install:
  cmd.run:
    - require:
      - cmd: rook-cluster-wait
      - cmd: rook-cluster-install
    - watch:
      - file: /srv/kubernetes/manifests/rook/ceph/toolbox.yaml
      - file: /srv/kubernetes/manifests/rook/monitoring/prometheus.yaml
      - file: /srv/kubernetes/manifests/rook/monitoring/prometheus-service.yaml
      - file: /srv/kubernetes/manifests/rook/monitoring/service-monitor.yaml
      - file: /srv/kubernetes/manifests/rook/monitoring/kube-prometheus/ceph-exporter.yaml
      - file: /srv/kubernetes/manifests/rook/monitoring/kube-prometheus/prometheus.yaml
      - file: /srv/kubernetes/manifests/rook/monitoring/kube-prometheus/service-monitor.yaml
      - file: /srv/kubernetes/manifests/rook/monitoring/kube-prometheus/grafana-dashboard.yaml
    - name: |
        kubectl apply -f /srv/kubernetes/manifests/rook/ceph/toolbox.yaml
        {%- if common.addons.get('kube_prometheus', {'enabled': False}).enabled %}
        kubectl apply -f /srv/kubernetes/manifests/rook/monitoring/kube-prometheus/ceph-exporter.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/monitoring/kube-prometheus/grafana-dashboard.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/monitoring/kube-prometheus/prometheus.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/monitoring/kube-prometheus/service-monitor.yaml
        {%- else %}
        kubectl apply -f /srv/kubernetes/manifests/rook/monitoring/prometheus.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/monitoring/prometheus-service.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/monitoring/service-monitor.yaml
        {%- endif %}
{% endif %}


{%- if master.storage.get('rook_minio', {'enabled': False}).enabled %}

/srv/kubernetes/manifests/rook/minio:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750
    - makedirs: True

/srv/kubernetes/manifests/rook/minio/ingress.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/minio
    - source: salt://kubernetes/csi/rook/minio/ingress.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/minio/object-store.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/minio
    - source: salt://kubernetes/csi/rook/minio/object-store.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja

/srv/kubernetes/manifests/rook/minio/operator.yaml:
    file.managed:
    - require:
      - file: /srv/kubernetes/manifests/rook/minio
    - source: salt://kubernetes/csi/rook/minio/operator.yaml
    - user: root
    - group: root
    - file_mode: 644
    - template: jinja


rook-minio-operator-install:
  cmd.run:
    - watch:
      - file: /srv/kubernetes/manifests/rook/minio/operator.yaml
    - onlyif: curl --silent 'http://127.0.0.1:8080/version/'
    - name: |
        kubectl apply -f /srv/kubernetes/manifests/rook/minio/operator.yaml

rook-minio-operator-wait:
  cmd.run:
    - require:
      - cmd: rook-minio-operator-install
    - runas: root
    - name: until kubectl -n rook-minio-system get pods --field-selector=status.phase=Running | grep rook-minio-operator; do printf 'rook-minio-operator is not Running' && sleep 5; done
    - use_vt: True
    - timeout: 180

rook-minio-cluster-install:
  cmd.run:
    - require:
      - cmd: rook-minio-operator-wait
      - cmd: rook-minio-operator-install
    - watch:
      - file: /srv/kubernetes/manifests/rook/minio/object-store.yaml
      - file: /srv/kubernetes/manifests/rook/minio/ingress.yaml
    - name: |
        kubectl apply -f /srv/kubernetes/manifests/rook/minio/object-store.yaml
        kubectl apply -f /srv/kubernetes/manifests/rook/minio/ingress.yaml
{% endif %}