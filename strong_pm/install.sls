# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - nodejs
  - strongloop

{% from "strong_pm/map.jinja" import strong_pm with context %}
strong_pm_user:
  user.present:
    - name: {{ strong_pm.lookup.user }}

strong_pm_pkg:
  cmd.run:
    - name: >
        {{ strong_pm.cmd.install }}
        {%- if strong_pm.lookup.init_manager %}
        --{{ strong_pm.lookup.init_manager }}
        {%- if strong_pm.lookup.init_manager == "upstart" %}
        {{ strong_pm.lookup.upstart_version }}
        {%- endif %}
        {%- endif %}
        --base {{ strong_pm.lookup.base }}
        --driver {{ strong_pm.lookup.driver }}
        {%- if strong_pm.lookup.set_env %}
        --set-env {{ strong_pm.lookup.set_env }}
        {%- endif %}
        {%- if strong_pm.lookup.force is sameas true %}
        --force
        {%- endif %}
        {%- if strong_pm.lookup.http_auth %}
        --http-auth {{ strong_pm.lookup.http_auth }}
        {%- endif %}
        --job-file {{ strong_pm.lookup.job_file }}
        {%- if strong_pm.lookup.metrics %}
        --metrics
        {%- endif %}
        {%- if strong_pm.lookup.dry_run is sameas true %}
        --dry-run
        {%- endif %}
        --port {{ strong_pm.lookup.port }}
        --base-port {{ strong_pm.lookup.base_port }}
        --user {{ strong_pm.lookup.user }}
    - unless: '[[ -f "/etc/systemd/system/strong-pm.service" ]] && ! {{ strong_pm.lookup.force }} && echo "0"'
    - user: root
    - cwd: {{ strong_pm.lookup.base }}
    - require:
      - pkg: nodejs
      - npm: strongloop
      - user: {{ strong_pm.lookup.user }}
