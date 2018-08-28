{%- from "kubernetes/map.jinja" import common with context -%}

addon-prometheus-operator:
  git.latest:
    - name: https://github.com/coreos/prometheus-operator
    - target: /srv/kubernetes/manifests/prometheus-operator
    - force_reset: True
    - rev: {{ common.addons.kube_prometheus.version }}

{% if common.addons.get('ingress_traefik', {'enabled': False}).enabled %}
/srv/kubernetes/manifests/prometheus-operator/contrib/kube-prometheus/manifests/dashboard-ingress.yaml:
    file.managed:
    - source: salt://kubernetes/addons/prometheus-operator/dashboard-ingress.yaml
    - user: root
    - template: jinja
    - group: root
    - mode: 644
    - watch:
      - git: addon-prometheus-operator
{% endif %}

{% if common.addons.get('ingress_istio', {'enabled': False}).enabled -%}
/srv/kubernetes/manifests/prometheus-operator/contrib/kube-prometheus/manifests/dashboard-ingress.yaml:
    file.managed:
    - source: salt://kubernetes/addons/prometheus-operator/virtualservice.yaml
    - user: root
    - template: jinja
    - group: root
    - mode: 644
    - watch:
      - git: addon-prometheus-operator
{% endif %}

/srv/kubernetes/manifests/prometheus-operator/contrib/kube-prometheus/manifests/grafana-deployment.yaml:
    file.managed:
    - source: salt://kubernetes/addons/prometheus-operator/grafana-deployment.yaml
    - user: root
    - template: jinja
    - group: root
    - mode: 644
    - watch:
      - git: addon-prometheus-operator

kubernetes-kube-prometheus-install:
  cmd.run:
    - watch:
        - git:  addon-prometheus-operator
        - file: /srv/kubernetes/manifests/prometheus-operator/contrib/kube-prometheus/manifests/dashboard-ingress.yaml
        - file: /srv/kubernetes/manifests/prometheus-operator/contrib/kube-prometheus/manifests/grafana-deployment.yaml
    - runas: root
    - use_vt: True
    - name: |
        kubectl apply -f /srv/kubernetes/manifests/prometheus-operator/contrib/kube-prometheus/manifests/ || true
        kubectl apply -f /srv/kubernetes/manifests/prometheus-operator/contrib/kube-prometheus/manifests/ 2>/dev/null || true
    - onlyif: curl --silent 'http://127.0.0.1:8080/version/'